/// Extended device information model for the home screen
class DeviceInfo {
  final String name;
  final String model;
  final String serialNumber;
  final String connection;
  final String mediaType;
  final String capacity;
  final bool secureEraseSupported;
  final String deviceType; // 'disk', 'nvme', 'usb'
  
  DeviceInfo({
    required this.name,
    required this.model,
    required this.serialNumber,
    required this.connection,
    required this.mediaType,
    required this.capacity,
    required this.secureEraseSupported,
    required this.deviceType,
  });
  
  /// Get icon name based on device type
  String get iconName {
    switch (deviceType.toLowerCase()) {
      case 'nvme':
        return 'memory';
      case 'usb':
        return 'save';
      default:
        return 'database';
    }
  }
}

/// Partition information model
class PartitionInfo {
  final String name;
  final String fileSystem;
  final String size;
  final String mountPoint;
  bool isSelected;
  
  PartitionInfo({
    required this.name,
    required this.fileSystem,
    required this.size,
    required this.mountPoint,
    this.isSelected = false,
  });
}
