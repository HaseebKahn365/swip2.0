#include "device_registry.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/hdreg.h>
#include <linux/nvme_ioctl.h>
#include <dirent.h>
#include <blkid/blkid.h>
#include <endian.h>

// ATA IDENTIFY DEVICE structure (simplified)
#define ATA_ID_WORDS 256
#define ATA_ID_SERNO 10
#define ATA_ID_FW_REV 23
#define ATA_ID_PROD 27
#define ATA_ID_COMMAND_SET_2 83
#define ATA_ID_SECURITY 128

// Helper function to read sysfs attribute
static char* read_sysfs_attr(const char* path) {
    FILE* f = fopen(path, "r");
    if (!f) return NULL;
    
    char* buffer = malloc(256);
    if (!buffer) {
        fclose(f);
        return NULL;
    }
    
    if (fgets(buffer, 256, f) == NULL) {
        free(buffer);
        fclose(f);
        return NULL;
    }
    
    // Remove trailing newline
    size_t len = strlen(buffer);
    if (len > 0 && buffer[len-1] == '\n') {
        buffer[len-1] = '\0';
    }
    
    fclose(f);
    return buffer;
}

// Helper function to convert ATA string (word-swapped)
static void ata_string_to_c_string(const uint16_t* ata_string, char* c_string, int words) {
    for (int i = 0; i < words; i++) {
        uint16_t word = le16toh(ata_string[i]);
        c_string[i*2] = (word >> 8) & 0xFF;
        c_string[i*2 + 1] = word & 0xFF;
    }
    c_string[words * 2] = '\0';
    
    // Trim trailing spaces
    for (int i = words * 2 - 1; i >= 0 && c_string[i] == ' '; i--) {
        c_string[i] = '\0';
    }
}

// Get device type from sysfs
static const char* get_device_type(const char* device_name) {
    char path[512];
    snprintf(path, sizeof(path), "/sys/block/%s/device/type", device_name);
    
    char* type_str = read_sysfs_attr(path);
    if (!type_str) {
        // Check if it's NVMe
        if (strncmp(device_name, "nvme", 4) == 0) {
            return "nvme";
        }
        return "unknown";
    }
    
    int type = atoi(type_str);
    free(type_str);
    
    // SCSI device types
    switch (type) {
        case 0: return "sata";  // Direct access device
        case 5: return "scsi";  // CD/DVD
        default: return "unknown";
    }
}

// Get ATA identity information
FlValue* device_registry_get_ata_identity(const char* device_path, GError** error) {
    int fd = open(device_path, O_RDONLY | O_NONBLOCK);
    if (fd < 0) {
        g_set_error(error, G_IO_ERROR, G_IO_ERROR_FAILED,
                    "Failed to open device: %s", device_path);
        return NULL;
    }
    
    struct hd_driveid id;
    if (ioctl(fd, HDIO_GET_IDENTITY, &id) < 0) {
        close(fd);
        g_set_error(error, G_IO_ERROR, G_IO_ERROR_FAILED,
                    "HDIO_GET_IDENTITY ioctl failed");
        return NULL;
    }
    
    close(fd);
    
    // Parse ATA identity data
    char model[41], serial[21], firmware[9];
    ata_string_to_c_string((uint16_t*)&id.model, model, 20);
    ata_string_to_c_string((uint16_t*)&id.serial_no, serial, 10);
    ata_string_to_c_string((uint16_t*)&id.fw_rev, firmware, 4);
    
    // Security status (Word 128)
    uint16_t security_word = le16toh(id.command_set_2);
    bool security_supported = (security_word & 0x0002) != 0;
    bool security_enabled = (security_word & 0x0004) != 0;
    bool security_locked = (security_word & 0x0008) != 0;
    bool security_frozen = (security_word & 0x0010) != 0;
    bool enhanced_erase_supported = (security_word & 0x0020) != 0;
    
    // Build FlValue map
    FlValue* result = fl_value_new_map();
    fl_value_set_string_take(result, "modelName", fl_value_new_string(model));
    fl_value_set_string_take(result, "serialNumber", fl_value_new_string(serial));
    fl_value_set_string_take(result, "firmwareRevision", fl_value_new_string(firmware));
    fl_value_set_string_take(result, "dmaSupport", fl_value_new_bool(true));
    fl_value_set_string_take(result, "enhancedSecurityEraseTimeMinutes", fl_value_new_int(0));
    
    // Security information
    FlValue* security = fl_value_new_map();
    fl_value_set_string_take(security, "isSecuritySupported", fl_value_new_bool(security_supported));
    fl_value_set_string_take(security, "isSecurityEnabled", fl_value_new_bool(security_enabled));
    fl_value_set_string_take(security, "isSecurityLocked", fl_value_new_bool(security_locked));
    fl_value_set_string_take(security, "isSecurityFrozen", fl_value_new_bool(security_frozen));
    fl_value_set_string_take(security, "isEnhancedEraseSupported", fl_value_new_bool(enhanced_erase_supported));
    
    fl_value_set_string_take(result, "security", security);
    
    return result;
}

// Get NVMe identity information
FlValue* device_registry_get_nvme_identity(const char* device_path, GError** error) {
    int fd = open(device_path, O_RDONLY);
    if (fd < 0) {
        g_set_error(error, G_IO_ERROR, G_IO_ERROR_FAILED,
                    "Failed to open NVMe device: %s", device_path);
        return NULL;
    }
    
    // Prepare NVMe admin command for Identify Controller
    struct nvme_admin_cmd cmd = {
        .opcode = 0x06,  // Identify command
        .nsid = 0,
        .addr = 0,
        .data_len = 4096,
        .cdw10 = 1,  // Identify Controller
    };
    
    uint8_t data[4096];
    cmd.addr = (uint64_t)data;
    
    if (ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd) < 0) {
        close(fd);
        g_set_error(error, G_IO_ERROR, G_IO_ERROR_FAILED,
                    "NVME_IOCTL_ADMIN_CMD failed");
        return NULL;
    }
    
    close(fd);
    
    // Parse NVMe Identify Controller data
    char serial[21], model[41];
    memcpy(serial, data + 4, 20);
    serial[20] = '\0';
    memcpy(model, data + 24, 40);
    model[40] = '\0';
    
    // Trim spaces
    for (int i = 19; i >= 0 && serial[i] == ' '; i--) serial[i] = '\0';
    for (int i = 39; i >= 0 && model[i] == ' '; i--) model[i] = '\0';
    
    // Vendor ID (bytes 0-1)
    uint16_t vendor_id = *(uint16_t*)data;
    
    // Sanitize Capabilities (byte 328)
    uint32_t sanicap = *(uint32_t*)(data + 328);
    bool crypto_erase = (sanicap & 0x01) != 0;
    bool block_erase = (sanicap & 0x02) != 0;
    bool overwrite = (sanicap & 0x04) != 0;
    
    // Build FlValue map
    FlValue* result = fl_value_new_map();
    fl_value_set_string_take(result, "serialNumber", fl_value_new_string(serial));
    fl_value_set_string_take(result, "modelName", fl_value_new_string(model));
    
    char vendor_str[16];
    snprintf(vendor_str, sizeof(vendor_str), "0x%04X", vendor_id);
    fl_value_set_string_take(result, "vendorId", fl_value_new_string(vendor_str));
    fl_value_set_string_take(result, "controllerId", fl_value_new_string("0"));
    fl_value_set_string_take(result, "nvmeVersion", fl_value_new_string("1.0"));
    fl_value_set_string_take(result, "criticalCompositeTemperature", fl_value_new_int(0));
    fl_value_set_string_take(result, "hostMemoryBufferPreferredSize", fl_value_new_int(0));
    
    // Sanitize capabilities
    FlValue* sanitize_methods = fl_value_new_list();
    if (crypto_erase) {
        fl_value_append_take(sanitize_methods, fl_value_new_string("nvme_sanitize"));
    }
    if (block_erase || overwrite) {
        fl_value_append_take(sanitize_methods, fl_value_new_string("nvme_format_nvm"));
    }
    
    fl_value_set_string_take(result, "supportedSanitizationMethods", sanitize_methods);
    
    return result;
}

// Enumerate all devices
FlValue* device_registry_enumerate_all_devices(GError** error) {
    FlValue* devices = fl_value_new_list();
    
    DIR* dir = opendir("/sys/block");
    if (!dir) {
        g_set_error(error, G_IO_ERROR, G_IO_ERROR_FAILED,
                    "Failed to open /sys/block");
        return devices;
    }
    
    struct dirent* entry;
    while ((entry = readdir(dir)) != NULL) {
        // Skip . and ..
        if (entry->d_name[0] == '.') continue;
        
        // Skip loop devices and ram devices
        if (strncmp(entry->d_name, "loop", 4) == 0 ||
            strncmp(entry->d_name, "ram", 3) == 0) {
            continue;
        }
        
        char device_path[512];
        snprintf(device_path, sizeof(device_path), "/dev/%s", entry->d_name);
        
        // Get device information
        FlValue* device = fl_value_new_map();
        
        // Device path and name
        fl_value_set_string_take(device, "devicePath", fl_value_new_string(device_path));
        fl_value_set_string_take(device, "deviceName", fl_value_new_string(entry->d_name));
        
        // Device type
        const char* dev_type = get_device_type(entry->d_name);
        fl_value_set_string_take(device, "deviceType", fl_value_new_string(dev_type));
        
        // Get size from sysfs
        char size_path[512];
        snprintf(size_path, sizeof(size_path), "/sys/block/%s/size", entry->d_name);
        char* size_str = read_sysfs_attr(size_path);
        int64_t total_bytes = 0;
        if (size_str) {
            int64_t sectors = atoll(size_str);
            total_bytes = sectors * 512;  // Assuming 512-byte sectors
            free(size_str);
        }
        fl_value_set_string_take(device, "totalBytes", fl_value_new_int(total_bytes));
        
        // Try to get detailed identity information
        if (strcmp(dev_type, "nvme") == 0) {
            FlValue* nvme_id = device_registry_get_nvme_identity(device_path, NULL);
            if (nvme_id) {
                fl_value_set_string_take(device, "nvmeIdentity", nvme_id);
            }
        } else if (strcmp(dev_type, "sata") == 0) {
            FlValue* ata_id = device_registry_get_ata_identity(device_path, NULL);
            if (ata_id) {
                fl_value_set_string_take(device, "ataIdentity", ata_id);
            }
        }
        
        // Add basic geometry
        FlValue* geometry = fl_value_new_map();
        fl_value_set_string_take(geometry, "logicalSectorSize", fl_value_new_int(512));
        fl_value_set_string_take(geometry, "physicalSectorSize", fl_value_new_int(512));
        fl_value_set_string_take(geometry, "userAddressableSectors", fl_value_new_int(total_bytes / 512));
        fl_value_set_string_take(device, "geometry", geometry);
        
        // Add basic security (will be populated from identity data)
        FlValue* security = fl_value_new_map();
        fl_value_set_string_take(security, "isSecuritySupported", fl_value_new_bool(false));
        fl_value_set_string_take(security, "isSecurityEnabled", fl_value_new_bool(false));
        fl_value_set_string_take(security, "isSecurityLocked", fl_value_new_bool(false));
        fl_value_set_string_take(security, "isSecurityFrozen", fl_value_new_bool(false));
        fl_value_set_string_take(security, "isEnhancedEraseSupported", fl_value_new_bool(false));
        fl_value_set_string_take(security, "supportedSanitizationMethods", fl_value_new_list());
        fl_value_set_string_take(device, "security", security);
        
        // Add empty partitions list (will be populated separately)
        fl_value_set_string_take(device, "partitions", fl_value_new_list());
        
        // UUID (placeholder)
        fl_value_set_string_take(device, "uuid", fl_value_new_string(""));
        
        // Model and serial (placeholders, will be from identity)
        fl_value_set_string_take(device, "modelName", fl_value_new_string("Unknown"));
        fl_value_set_string_take(device, "serialNumber", fl_value_new_string("Unknown"));
        
        fl_value_append_take(devices, device);
    }
    
    closedir(dir);
    return devices;
}
