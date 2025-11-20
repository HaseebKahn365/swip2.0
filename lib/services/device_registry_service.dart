import 'dart:async';
import 'dart:isolate';
import 'package:flutter/services.dart';
import '../models/storage_device_model.dart';

/// Device Registry Service
/// 
/// Implements a long-lived worker isolate for non-blocking device enumeration
/// Uses MethodChannel to communicate with native C/C++ code
class DeviceRegistryService {
  static const MethodChannel _channel =
      MethodChannel('com.swipe.device/registry');

  Isolate? _workerIsolate;
  SendPort? _workerSendPort;
  final _deviceStreamController =
      StreamController<List<StorageDeviceModel>>.broadcast();
  ReceivePort? _receivePort;

  /// Stream of device updates
  Stream<List<StorageDeviceModel>> get deviceStream =>
      _deviceStreamController.stream;

  /// Initialize the worker isolate
  Future<void> initialize() async {
    if (_workerIsolate != null) {
      return; // Already initialized
    }

    _receivePort = ReceivePort();

    // Spawn the worker isolate
    _workerIsolate = await Isolate.spawn(
      _workerIsolateEntry,
      _receivePort!.sendPort,
      debugName: 'DeviceRegistryWorker',
    );

    // Listen for messages from the worker isolate
    _receivePort!.listen((message) {
      if (message is SendPort) {
        // Worker isolate is ready
        _workerSendPort = message;
      } else if (message is List<Map<String, dynamic>>) {
        // Received device list from worker
        final devices = message
            .map((json) => StorageDeviceModel.fromJson(json))
            .toList();
        _deviceStreamController.add(devices);
      } else if (message is String && message.startsWith('ERROR:')) {
        // Error from worker isolate
        _deviceStreamController.addError(message.substring(6));
      }
    });

    // Wait for worker to be ready
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// Request device enumeration
  Future<void> enumerateDevices() async {
    if (_workerSendPort == null) {
      throw StateError('Worker isolate not initialized');
    }

    _workerSendPort!.send('ENUMERATE');
  }

  /// Get device list (one-time call)
  Future<List<StorageDeviceModel>> getDeviceList() async {
    try {
      final List<dynamic> result =
          await _channel.invokeMethod('getDeviceList');
      return result
          .map((json) =>
              StorageDeviceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on PlatformException catch (e) {
      throw Exception('Failed to get device list: ${e.message}');
    }
  }

  /// Dispose resources
  void dispose() {
    _workerIsolate?.kill(priority: Isolate.immediate);
    _workerIsolate = null;
    _workerSendPort = null;
    _receivePort?.close();
    _deviceStreamController.close();
  }

  /// Worker isolate entry point
  static void _workerIsolateEntry(SendPort mainSendPort) {
    final workerReceivePort = ReceivePort();

    // Send our SendPort to the main isolate
    mainSendPort.send(workerReceivePort.sendPort);

    // Listen for commands from main isolate
    workerReceivePort.listen((message) async {
      if (message == 'ENUMERATE') {
        try {
          // Call native method
          const channel = MethodChannel('com.swipe.device/registry');
          final List<dynamic> result =
              await channel.invokeMethod('getDeviceList');

          // Send results back to main isolate
          mainSendPort.send(
            result.map((e) => e as Map<String, dynamic>).toList(),
          );
        } catch (e) {
          mainSendPort.send('ERROR: $e');
        }
      }
    });
  }
}

/// Singleton instance
final deviceRegistryService = DeviceRegistryService();
