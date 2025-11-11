import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/disk_info.dart';

class DiskDetailsScreen extends StatelessWidget {
  final DiskInfo disk;

  const DiskDetailsScreen({super.key, required this.disk});

  @override
  Widget build(BuildContext context) {
    final usagePercent = disk.usagePercentValue;
    final color = _getUsageColor(usagePercent);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        title: Text(disk.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      _getIconForType(disk.type),
                      size: 64,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      disk.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: color, width: 2),
                      ),
                      child: Text(
                        '${usagePercent.toStringAsFixed(1)}% Used',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: usagePercent / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Storage Information
            _buildSectionTitle('Storage Information'),
            Card(
              child: Column(
                children: [
                  _buildDetailRow(
                    'Total Size',
                    disk.sizeFormatted,
                    '${disk.size} bytes',
                    Icons.storage,
                  ),
                  const Divider(height: 1),
                  _buildDetailRow(
                    'Used Space',
                    disk.usedFormatted,
                    '${disk.used} bytes',
                    Icons.pie_chart,
                    color: Colors.red,
                  ),
                  const Divider(height: 1),
                  _buildDetailRow(
                    'Available Space',
                    disk.availableFormatted,
                    '${disk.available} bytes',
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Device Information
            _buildSectionTitle('Device Information'),
            Card(
              child: Column(
                children: [
                  _buildDetailRow(
                    'Device Name',
                    disk.name,
                    'Block device identifier',
                    Icons.label,
                  ),
                  const Divider(height: 1),
                  _buildDetailRow(
                    'Device Type',
                    disk.type.toUpperCase(),
                    disk.type == 'disk' ? 'Physical disk' : 'Partition',
                    Icons.category,
                  ),
                  const Divider(height: 1),
                  _buildDetailRow(
                    'File System',
                    disk.fstype.isNotEmpty ? disk.fstype.toUpperCase() : 'N/A',
                    'File system type',
                    Icons.folder,
                  ),
                  const Divider(height: 1),
                  _buildDetailRow(
                    'Mount Point',
                    disk.mountpoint.isNotEmpty ? disk.mountpoint : 'Not mounted',
                    'Where the device is mounted',
                    Icons.location_on,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Usage Statistics
            _buildSectionTitle('Usage Statistics'),
            Card(
              child: Column(
                children: [
                  _buildStatRow('Usage Percentage', '${usagePercent.toStringAsFixed(2)}%'),
                  const Divider(height: 1),
                  _buildStatRow('Free Percentage', '${(100 - usagePercent).toStringAsFixed(2)}%'),
                  const Divider(height: 1),
                  _buildStatRow('Used/Total Ratio', '${(disk.used / disk.size).toStringAsFixed(4)}'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Raw Data
            _buildSectionTitle('Raw Data'),
            Card(
              child: Column(
                children: [
                  _buildCopyableRow('Total Bytes', disk.size.toString()),
                  const Divider(height: 1),
                  _buildCopyableRow('Used Bytes', disk.used.toString()),
                  const Divider(height: 1),
                  _buildCopyableRow('Available Bytes', disk.available.toString()),
                  const Divider(height: 1),
                  _buildCopyableRow('Device Path', '/dev/${disk.name}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, String subtitle, IconData icon, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blue.shade700),
      title: Text(
        label,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCopyableRow(String label, String value) {
    return ListTile(
      title: Text(label),
      subtitle: Text(
        value,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.copy, size: 20),
        onPressed: () {
          Clipboard.setData(ClipboardData(text: value));
        },
      ),
    );
  }

  Color _getUsageColor(double percent) {
    if (percent > 90) return Colors.red;
    if (percent > 70) return Colors.orange;
    return Colors.green;
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'disk':
        return Icons.storage;
      case 'part':
        return Icons.pie_chart_outline;
      default:
        return Icons.device_unknown;
    }
  }
}
