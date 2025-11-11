import 'package:flutter/material.dart';
import 'dart:async';
import 'services/disk_monitor_service.dart';
import 'models/disk_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disk Monitor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const DiskMonitorPage(),
    );
  }
}

class DiskMonitorPage extends StatefulWidget {
  const DiskMonitorPage({super.key});

  @override
  State<DiskMonitorPage> createState() => _DiskMonitorPageState();
}

class _DiskMonitorPageState extends State<DiskMonitorPage> {
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

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
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

          // Separate disks into categories
          final physicalDisks = <DiskInfo>[];
          final partitions = <DiskInfo>[];
          final loopDevices = <DiskInfo>[];
          
          for (var disk in disks) {
            if (disk.type == 'disk') {
              physicalDisks.add(disk);
            } else if (disk.type == 'part') {
              partitions.add(disk);
            } else if (disk.type == 'loop' && disk.mountpoint.startsWith('/snap')) {
              loopDevices.add(disk);
            }
          }

          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              if (physicalDisks.isNotEmpty) ...[
                _buildSectionHeader('Physical Disks', physicalDisks.length),
                ...physicalDisks.map((disk) => CompactDiskCard(
                  key: ValueKey(disk.name),
                  disk: disk,
                )),
              ],
              if (partitions.isNotEmpty) ...[
                _buildSectionHeader('Partitions', partitions.length),
                ...partitions.map((disk) => CompactDiskCard(
                  key: ValueKey(disk.name),
                  disk: disk,
                )),
              ],
              if (loopDevices.isNotEmpty) ...[
                _buildSectionHeader('Loop Devices (Snap)', loopDevices.length),
                ...loopDevices.map((disk) => CompactDiskCard(
                  key: ValueKey(disk.name),
                  disk: disk,
                  isCompact: true,
                )),
              ],
            ],
          );
        },
      ),
    );
  }
}

class CompactDiskCard extends StatelessWidget {
  final DiskInfo disk;
  final bool isCompact;

  const CompactDiskCard({
    super.key, 
    required this.disk,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final usagePercent = disk.usagePercentValue;
    final color = usagePercent > 90
        ? Colors.red
        : usagePercent > 70
            ? Colors.orange
            : Colors.green;

    final isMounted = disk.mountpoint.isNotEmpty;
    final hasUsageData = disk.used > 0 || disk.available > 0;

    if (isCompact) {
      return Card(
        margin: const EdgeInsets.only(bottom: 4),
        elevation: 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Icon(
                _getIconForType(disk.type),
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  disk.name,
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              Text(
                disk.sizeFormatted,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getIconForType(disk.type),
                  size: 20,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            disk.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (disk.model.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                disk.model,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (isMounted)
                        Text(
                          disk.mountpoint,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        )
                      else
                        Text(
                          'Not mounted',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (hasUsageData) ...[
                      Text(
                        '${disk.usedFormatted} / ${disk.sizeFormatted}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${disk.availableFormatted} free',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ] else ...[
                      Text(
                        disk.sizeFormatted,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (disk.fstype.isNotEmpty)
                        Text(
                          disk.fstype,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ],
                ),
              ],
            ),
            if (hasUsageData) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: usagePercent / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: color, width: 1),
                    ),
                    child: Text(
                      '${usagePercent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'disk':
        return Icons.storage;
      case 'part':
        return Icons.pie_chart_outline;
      case 'loop':
        return Icons.loop;
      default:
        return Icons.device_unknown;
    }
  }
}
