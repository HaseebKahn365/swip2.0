class DiskInfo {
  final String name;
  final int size;
  final int used;
  final int available;
  final String mountpoint;
  final String type;
  final String fstype;
  final String usagePercent;
  final String model;

  DiskInfo({
    required this.name,
    required this.size,
    required this.used,
    required this.available,
    required this.mountpoint,
    required this.type,
    required this.fstype,
    required this.usagePercent,
    required this.model,
  });

  factory DiskInfo.fromMap(Map<dynamic, dynamic> map) {
    return DiskInfo(
      name: map['name'] ?? '',
      size: int.tryParse(map['size'] ?? '0') ?? 0,
      used: int.tryParse(map['used'] ?? '0') ?? 0,
      available: int.tryParse(map['available'] ?? '0') ?? 0,
      mountpoint: map['mountpoint'] ?? '',
      type: map['type'] ?? '',
      fstype: map['fstype'] ?? '',
      usagePercent: map['usagePercent'] ?? '0%',
      model: map['model'] ?? '',
    );
  }

  String get sizeFormatted => _formatBytes(size);
  String get usedFormatted => _formatBytes(used);
  String get availableFormatted => _formatBytes(available);

  double get usagePercentValue {
    final percentStr = usagePercent.replaceAll('%', '');
    return double.tryParse(percentStr) ?? 0.0;
  }

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
