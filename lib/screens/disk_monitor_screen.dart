import 'package:flutter/material.dart';
import 'dart:async';
import '../services/disk_monitor_service.dart';
import '../models/disk_info.dart';
import '../widgets/disk_card.dart';

class DiskMonitorScreen extends StatefulWidget {
  const DiskMonitorScreen({super.key});

  @override
  State<DiskMonitorScreen> createState() => _DiskMonitorScreenState();
}

class _DiskMonitorScreenState extends State<DiskMonitorScreen> {
  final DiskMonitorService _diskMonitorService = DiskMonitorService();
  StreamSubscription<List<DiskInfo>>? _subscription;
  bool _isConnected = false;
  String _statusMessage = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    setState(() {
      _isConnected = true;
      _statusMessage = 'Connected';
    });

    _subscription = _diskMonitorService.diskInfoStream.listen(
      (disks) {
        // Stream is working, no need to update state
      },
      onError: (error) {
        setState(() {
          _isConnected = false;
          _statusMessage = 'Error: $error';
        });
        // Auto-reconnect after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_isConnected) {
            _startMonitoring();
          }
        });
      },
      onDone: () {
        setState(() {
          _isConnected = false;
          _statusMessage = 'Disconnected';
        });
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.storage, size: 20),
            const SizedBox(width: 8),
            const Text('Disk Monitor', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _isConnected ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isConnected ? Icons.circle : Icons.error,
                    size: 8,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isConnected ? 'LIVE' : 'OFFLINE',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<List<DiskInfo>>(
        stream: _diskMonitorService.diskInfoStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Connecting to disk monitor...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _startMonitoring,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final disks = snapshot.data ?? [];
          
          if (disks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storage, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No disks detected'),
                ],
              ),
            );
          }

          // Show ALL disks and partitions, only exclude snap loop devices
          final filteredDisks = disks.where((d) {
            // Exclude snap loop devices
            if (d.type == 'loop' && d.mountpoint.startsWith('/snap')) {
              return false;
            }
            // Include all physical disks and partitions (mounted or not)
            if (d.type == 'disk' || d.type == 'part') {
              return true;
            }
            // Include other mounted devices (like loop devices for ISOs)
            if (d.mountpoint.isNotEmpty && !d.mountpoint.startsWith('/snap')) {
              return true;
            }
            return false;
          }).toList();

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.blue.shade50,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap any disk to view detailed information',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredDisks.length,
                  itemBuilder: (context, index) {
                    return DiskCard(
                      key: ValueKey(filteredDisks[index].name),
                      disk: filteredDisks[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
