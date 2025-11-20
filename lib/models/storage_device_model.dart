/// Root model for storage device information
class StorageDeviceModel {
  final String uuid;
  final String devicePath;
  final int totalBytes;
  final String modelName;
  final String serialNumber;
  final DeviceType deviceType;
  final DiskGeometryModel geometry;
  final DeviceSecurityModel security;
  final List<PartitionModel> partitions;
  final AtaIdentityModel? ataIdentity;
  final NVMeIdentityModel? nvmeIdentity;

  StorageDeviceModel({
    required this.uuid,
    required this.devicePath,
    required this.totalBytes,
    required this.modelName,
    required this.serialNumber,
    required this.deviceType,
    required this.geometry,
    required this.security,
    required this.partitions,
    this.ataIdentity,
    this.nvmeIdentity,
  });

  factory StorageDeviceModel.fromJson(Map<String, dynamic> json) {
    return StorageDeviceModel(
      uuid: json['uuid'] as String? ?? '',
      devicePath: json['devicePath'] as String,
      totalBytes: json['totalBytes'] as int,
      modelName: json['modelName'] as String? ?? 'Unknown',
      serialNumber: json['serialNumber'] as String? ?? 'Unknown',
      deviceType: DeviceType.fromString(json['deviceType'] as String? ?? 'unknown'),
      geometry: DiskGeometryModel.fromJson(json['geometry'] as Map<String, dynamic>),
      security: DeviceSecurityModel.fromJson(json['security'] as Map<String, dynamic>),
      partitions: (json['partitions'] as List<dynamic>?)
              ?.map((p) => PartitionModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      ataIdentity: json['ataIdentity'] != null
          ? AtaIdentityModel.fromJson(json['ataIdentity'] as Map<String, dynamic>)
          : null,
      nvmeIdentity: json['nvmeIdentity'] != null
          ? NVMeIdentityModel.fromJson(json['nvmeIdentity'] as Map<String, dynamic>)
          : null,
    );
  }

  String get formattedCapacity => _formatBytes(totalBytes);

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    if (bytes < 1024 * 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
    return '${(bytes / (1024 * 1024 * 1024 * 1024)).toStringAsFixed(2)} TB';
  }
}

/// Device type enumeration
enum DeviceType {
  ata,
  sata,
  nvme,
  usb,
  scsi,
  mmc,
  unknown;

  static DeviceType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'ata':
      case 'sata':
        return DeviceType.sata;
      case 'nvme':
        return DeviceType.nvme;
      case 'usb':
        return DeviceType.usb;
      case 'scsi':
        return DeviceType.scsi;
      case 'mmc':
        return DeviceType.mmc;
      default:
        return DeviceType.unknown;
    }
  }

  String get displayName {
    switch (this) {
      case DeviceType.ata:
      case DeviceType.sata:
        return 'SATA';
      case DeviceType.nvme:
        return 'NVMe';
      case DeviceType.usb:
        return 'USB';
      case DeviceType.scsi:
        return 'SCSI';
      case DeviceType.mmc:
        return 'MMC';
      case DeviceType.unknown:
        return 'Unknown';
    }
  }
}

/// Partition information model
class PartitionModel {
  final String partitionPath;
  final int startSector;
  final int sizeSectors;
  final String filesystemType;
  final String partitionLabel;
  final String mountPoint;

  PartitionModel({
    required this.partitionPath,
    required this.startSector,
    required this.sizeSectors,
    required this.filesystemType,
    required this.partitionLabel,
    required this.mountPoint,
  });

  factory PartitionModel.fromJson(Map<String, dynamic> json) {
    return PartitionModel(
      partitionPath: json['partitionPath'] as String,
      startSector: json['startSector'] as int,
      sizeSectors: json['sizeSectors'] as int,
      filesystemType: json['filesystemType'] as String? ?? 'unknown',
      partitionLabel: json['partitionLabel'] as String? ?? '',
      mountPoint: json['mountPoint'] as String? ?? '',
    );
  }

  int get sizeBytes => sizeSectors * 512; // Assuming 512-byte sectors

  String get formattedSize {
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(2)} KB';
    }
    if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

/// Disk geometry information
class DiskGeometryModel {
  final int logicalSectorSize;
  final int physicalSectorSize;
  final int userAddressableSectors;

  DiskGeometryModel({
    required this.logicalSectorSize,
    required this.physicalSectorSize,
    required this.userAddressableSectors,
  });

  factory DiskGeometryModel.fromJson(Map<String, dynamic> json) {
    return DiskGeometryModel(
      logicalSectorSize: json['logicalSectorSize'] as int? ?? 512,
      physicalSectorSize: json['physicalSectorSize'] as int? ?? 512,
      userAddressableSectors: json['userAddressableSectors'] as int? ?? 0,
    );
  }

  int get totalBytes => userAddressableSectors * logicalSectorSize;
}

/// Device security capabilities and status
class DeviceSecurityModel {
  final bool isSecuritySupported;
  final bool isSecurityEnabled;
  final bool isSecurityLocked;
  final bool isSecurityFrozen;
  final bool isEnhancedEraseSupported;
  final List<SanitizationMethod> supportedSanitizationMethods;

  DeviceSecurityModel({
    required this.isSecuritySupported,
    required this.isSecurityEnabled,
    required this.isSecurityLocked,
    required this.isSecurityFrozen,
    required this.isEnhancedEraseSupported,
    required this.supportedSanitizationMethods,
  });

  factory DeviceSecurityModel.fromJson(Map<String, dynamic> json) {
    return DeviceSecurityModel(
      isSecuritySupported: json['isSecuritySupported'] as bool? ?? false,
      isSecurityEnabled: json['isSecurityEnabled'] as bool? ?? false,
      isSecurityLocked: json['isSecurityLocked'] as bool? ?? false,
      isSecurityFrozen: json['isSecurityFrozen'] as bool? ?? false,
      isEnhancedEraseSupported: json['isEnhancedEraseSupported'] as bool? ?? false,
      supportedSanitizationMethods: (json['supportedSanitizationMethods'] as List<dynamic>?)
              ?.map((m) => SanitizationMethod.fromString(m as String))
              .toList() ??
          [],
    );
  }

  bool get canPerformSecureErase =>
      isSecuritySupported && !isSecurityLocked && !isSecurityFrozen;
}

/// Sanitization methods enumeration
enum SanitizationMethod {
  ataSecureErase,
  ataEnhancedSecureErase,
  nvmeSanitize,
  nvmeFormatNvm,
  scsiSanitize,
  scsiFormat,
  overwrite;

  static SanitizationMethod fromString(String method) {
    switch (method.toLowerCase()) {
      case 'ata_secure_erase':
        return SanitizationMethod.ataSecureErase;
      case 'ata_enhanced_secure_erase':
        return SanitizationMethod.ataEnhancedSecureErase;
      case 'nvme_sanitize':
        return SanitizationMethod.nvmeSanitize;
      case 'nvme_format_nvm':
        return SanitizationMethod.nvmeFormatNvm;
      case 'scsi_sanitize':
        return SanitizationMethod.scsiSanitize;
      case 'scsi_format':
        return SanitizationMethod.scsiFormat;
      case 'overwrite':
        return SanitizationMethod.overwrite;
      default:
        return SanitizationMethod.overwrite;
    }
  }

  String get displayName {
    switch (this) {
      case SanitizationMethod.ataSecureErase:
        return 'ATA Secure Erase';
      case SanitizationMethod.ataEnhancedSecureErase:
        return 'ATA Enhanced Secure Erase';
      case SanitizationMethod.nvmeSanitize:
        return 'NVMe Sanitize';
      case SanitizationMethod.nvmeFormatNvm:
        return 'NVMe Format NVM';
      case SanitizationMethod.scsiSanitize:
        return 'SCSI Sanitize';
      case SanitizationMethod.scsiFormat:
        return 'SCSI Format';
      case SanitizationMethod.overwrite:
        return 'Overwrite';
    }
  }
}

/// ATA-specific identity information
class AtaIdentityModel {
  final String firmwareRevision;
  final bool dmaSupport;
  final int enhancedSecurityEraseTimeMinutes;

  AtaIdentityModel({
    required this.firmwareRevision,
    required this.dmaSupport,
    required this.enhancedSecurityEraseTimeMinutes,
  });

  factory AtaIdentityModel.fromJson(Map<String, dynamic> json) {
    return AtaIdentityModel(
      firmwareRevision: json['firmwareRevision'] as String? ?? 'Unknown',
      dmaSupport: json['dmaSupport'] as bool? ?? false,
      enhancedSecurityEraseTimeMinutes:
          json['enhancedSecurityEraseTimeMinutes'] as int? ?? 0,
    );
  }
}

/// NVMe-specific identity information
class NVMeIdentityModel {
  final String vendorId;
  final String controllerId;
  final String nvmeVersion;
  final int criticalCompositeTemperature;
  final int hostMemoryBufferPreferredSize;

  NVMeIdentityModel({
    required this.vendorId,
    required this.controllerId,
    required this.nvmeVersion,
    required this.criticalCompositeTemperature,
    required this.hostMemoryBufferPreferredSize,
  });

  factory NVMeIdentityModel.fromJson(Map<String, dynamic> json) {
    return NVMeIdentityModel(
      vendorId: json['vendorId'] as String? ?? 'Unknown',
      controllerId: json['controllerId'] as String? ?? 'Unknown',
      nvmeVersion: json['nvmeVersion'] as String? ?? 'Unknown',
      criticalCompositeTemperature:
          json['criticalCompositeTemperature'] as int? ?? 0,
      hostMemoryBufferPreferredSize:
          json['hostMemoryBufferPreferredSize'] as int? ?? 0,
    );
  }
}
