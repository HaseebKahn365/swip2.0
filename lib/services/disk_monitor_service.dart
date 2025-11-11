import 'package:flutter/services.dart';
import '../models/disk_info.dart';

class DiskMonitorService {
  static const MethodChannel _methodChannel =
      MethodChannel('disk_monitor/method');
  static const EventChannel _eventChannel =
      EventChannel('disk_monitor/event');

  /// Fetch disk information once
  Future<List<DiskInfo>> getDiskInfo() async {
    try {
      final List<dynamic> result = await _methodChannel.invokeMethod('getDiskInfo');
      return result.map((disk) => DiskInfo.fromMap(disk)).toList();
    } on PlatformException catch (e) {
      print('Failed to get disk info: ${e.message}');
      return [];
    }
  }

  /// Stream real-time disk information updates
  Stream<List<DiskInfo>> get diskInfoStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      if (event is List) {
        return event.map((disk) => DiskInfo.fromMap(disk)).toList();
      }
      return <DiskInfo>[];
    });
  }
}
