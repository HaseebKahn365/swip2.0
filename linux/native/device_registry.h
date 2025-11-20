#ifndef DEVICE_REGISTRY_H
#define DEVICE_REGISTRY_H

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

/**
 * device_registry_enumerate_all_devices:
 * 
 * Enumerates all storage devices on the system.
 * 
 * Returns: (transfer full): A FlValue containing a list of device information maps
 */
FlValue* device_registry_enumerate_all_devices(GError** error);

/**
 * device_registry_get_ata_identity:
 * @device_path: Path to the device (e.g., "/dev/sda")
 * 
 * Retrieves ATA IDENTIFY DEVICE data using HDIO_GET_IDENTITY ioctl.
 * 
 * Returns: (transfer full): A FlValue containing ATA identity information
 */
FlValue* device_registry_get_ata_identity(const char* device_path, GError** error);

/**
 * device_registry_get_nvme_identity:
 * @device_path: Path to the NVMe device (e.g., "/dev/nvme0")
 * 
 * Retrieves NVMe Identify Controller data using NVME_IOCTL_ADMIN_CMD.
 * 
 * Returns: (transfer full): A FlValue containing NVMe identity information
 */
FlValue* device_registry_get_nvme_identity(const char* device_path, GError** error);

G_END_DECLS

#endif // DEVICE_REGISTRY_H
