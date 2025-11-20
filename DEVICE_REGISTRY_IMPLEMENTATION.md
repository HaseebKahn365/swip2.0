# Device Registry Implementation

## Overview

This document describes the implementation of the device information retrieval system for the Swipe application, following the specifications in `about_device_info_retrieval.md`.

## Architecture

### 1. Concurrency Layer (Dart)

**File**: `lib/services/device_registry_service.dart`

- Implements a long-lived worker Isolate using `Isolate.spawn()`
- Uses `SendPort` and `ReceivePort` for bidirectional communication
- Provides a `Stream<List<StorageDeviceModel>>` for reactive UI updates
- Handles errors gracefully and reports them through the stream

**Key Features**:
- Non-blocking device enumeration
- Automatic error handling and recovery
- Broadcast stream for multiple listeners
- Clean resource disposal

### 2. Platform Channel (Dart ↔ Native)

**Channel Name**: `com.swipe.device/registry`
**Channel Type**: `MethodChannel`

**Methods**:
- `getDeviceList()` → `Future<List<Map<String, dynamic>>>`
  - Calls native `device_registry_enumerate_all_devices()`
  - Returns list of device information maps

### 3. Data Models (Dart)

**File**: `lib/models/storage_device_model.dart`

Implements immutable Dart model classes:

| Model Class | Purpose |
|------------|---------|
| `StorageDeviceModel` | Root device information |
| `PartitionModel` | Partition details |
| `DiskGeometryModel` | Physical geometry |
| `DeviceSecurityModel` | Security capabilities |
| `AtaIdentityModel` | ATA-specific data |
| `NVMeIdentityModel` | NVMe-specific data |

All models include:
- `fromJson()` factory constructors
- Proper null safety
- Helper methods for formatting

### 4. Native Implementation (C)

**Files**:
- `linux/native/device_registry.h` - Header file
- `linux/native/device_registry.c` - Implementation
- `linux/runner/device_registry_plugin.h` - Plugin header
- `linux/runner/device_registry_plugin.cc` - Plugin implementation

## Native Data Retrieval

### A. High-Level Information (libblkid)

**Library**: `libblkid`

Retrieves:
- Filesystem type (ext4, NTFS, etc.)
- Disk UUID/ID
- Partition list
- Partition labels

### B. ATA/SATA Devices

**IOCTL**: `HDIO_GET_IDENTITY`
**Command**: ATA IDENTIFY DEVICE (0xEC)
**Data Structure**: 512-byte `IDENTIFY_DEVICE_DATA`

**Retrieved Information**:
- Model name (ATA Word 27-46)
- Serial number (ATA Word 10-19)
- Firmware revision
- Total bytes
- Security status (ATA Word 128):
  - `SecuritySupported`
  - `SecurityFrozen`
  - `SecurityLocked`
  - `SecurityEnabled`
  - `EnhancedEraseSupported`

### C. NVMe Devices

**IOCTL**: `NVME_IOCTL_ADMIN_CMD`
**Command**: Identify Controller (opcode 0x06, cdw10=1)
**Data Structure**: 4096-byte `nvme_id_ctrl`

**Retrieved Information**:
- Serial number (`sn`)
- Model name (`mn`)
- Vendor ID (`vid`)
- Controller ID (`cntlid`)
- Sanitize Capabilities (`sanicap`):
  - Crypto Erase support
  - Block Erase support
  - Overwrite support

### D. SysFS Information

**Path**: `/sys/block/<device>/`

**Retrieved Information**:
- Device size (sectors)
- Partition geometry (start, size)
- Device type
- Logical/physical sector size

## Data Flow

```
1. Dart UI calls deviceRegistryService.enumerateDevices()
   ↓
2. Worker Isolate receives command
   ↓
3. Worker calls MethodChannel.invokeMethod('getDeviceList')
   ↓
4. Native plugin receives method call
   ↓
5. device_registry_enumerate_all_devices() executes:
   - Scans /sys/block for devices
   - For each device:
     * Reads SysFS attributes
     * Calls device_registry_get_ata_identity() or
     * Calls device_registry_get_nvme_identity()
     * Uses libblkid for filesystem info
   - Builds FlValue map structure
   ↓
6. FlValue returned to Dart as List<Map<String, dynamic>>
   ↓
7. Worker Isolate converts to List<StorageDeviceModel>
   ↓
8. Models sent to main Isolate via SendPort
   ↓
9. Stream emits new device list
   ↓
10. UI rebuilds with new data
```

## Security Considerations

### Permissions Required

The application needs:
- Read access to `/sys/block/*`
- Read access to `/dev/*` devices
- IOCTL permissions for device commands

### Privilege Escalation

For production use, consider:
1. Running with `CAP_SYS_RAWIO` capability
2. Using a privileged helper daemon
3. Implementing proper permission checks

### Data Validation

All native code:
- Validates buffer sizes
- Checks IOCTL return values
- Handles endianness correctly
- Sanitizes string data
- Prevents buffer overflows

## Error Handling

### Native Layer
- Returns `GError` for all failures
- Provides descriptive error messages
- Gracefully handles missing devices
- Falls back to SysFS when IOCTLs fail

### Dart Layer
- Catches `PlatformException`
- Emits errors through stream
- Provides user-friendly error messages
- Implements automatic retry logic

## Building

### Dependencies

Install required libraries:
```bash
sudo apt-get install libblkid-dev
```

### CMake Configuration

The `linux/runner/CMakeLists.txt` includes:
- `device_registry_plugin.cc`
- `../native/device_registry.c`
- Links against `libblkid`

### Compilation

```bash
flutter build linux
```

## Testing

### Unit Tests

Test individual components:
```dart
test('StorageDeviceModel.fromJson parses correctly', () {
  final json = {...};
  final model = StorageDeviceModel.fromJson(json);
  expect(model.devicePath, '/dev/sda');
});
```

### Integration Tests

Test native bridge:
```dart
test('getDeviceList returns devices', () async {
  final devices = await deviceRegistryService.getDeviceList();
  expect(devices, isNotEmpty);
});
```

### Manual Testing

Run with elevated privileges:
```bash
sudo flutter run -d linux
```

## Performance

### Optimization Strategies

1. **Caching**: Cache device information for 1-2 seconds
2. **Lazy Loading**: Only retrieve detailed info when needed
3. **Parallel Enumeration**: Use threads for multiple devices
4. **Selective Updates**: Only update changed devices

### Benchmarks

Expected performance:
- Device enumeration: < 100ms for 4 devices
- ATA identity retrieval: < 50ms per device
- NVMe identity retrieval: < 30ms per device

## Future Enhancements

1. **SCSI Support**: Add SCSI INQUIRY commands
2. **USB Bridge Detection**: Identify USB-to-SATA adapters
3. **SMART Data**: Retrieve health information
4. **Real-time Monitoring**: Watch for device hotplug events
5. **Partition Enumeration**: Full partition table parsing
6. **Mount Point Detection**: Use `/proc/mounts`

## References

- [ATA/ATAPI Command Set](https://www.t13.org/)
- [NVMe Specification](https://nvmexpress.org/)
- [Linux Kernel Documentation](https://www.kernel.org/doc/html/latest/)
- [libblkid Documentation](https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/)
- [SysFS Documentation](https://www.kernel.org/doc/Documentation/filesystems/sysfs.txt)

## Troubleshooting

### Common Issues

**Issue**: "Permission denied" when opening devices
**Solution**: Run with sudo or add user to `disk` group

**Issue**: IOCTL returns ENOTTY
**Solution**: Device doesn't support the command, fall back to SysFS

**Issue**: Garbled model/serial numbers
**Solution**: Check endianness conversion and string trimming

**Issue**: libblkid not found
**Solution**: Install `libblkid-dev` package

## License

This implementation follows the project's license terms.
