import 'package:flutter/material.dart';
import '../models/disk_info.dart';
import '../screens/disk_details_screen.dart';

class DiskCard extends StatelessWidget {
  final DiskInfo disk;

  const DiskCard({super.key, required this.disk});

  @override
  Widget build(BuildContext context) {
    final usagePercent = disk.usagePercentValue;
    final color = _getUsageColor(usagePercent);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DiskDetailsScreen(disk: disk),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
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
                        Text(
                          disk.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          disk.mountpoint.isNotEmpty 
                              ? disk.mountpoint 
                              : 'Not mounted',
                          style: TextStyle(
                            fontSize: 11,
                            color: disk.mountpoint.isNotEmpty 
                                ? Colors.grey.shade600 
                                : Colors.orange.shade600,
                            fontStyle: disk.mountpoint.isEmpty 
                                ? FontStyle.italic 
                                : FontStyle.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        disk.mountpoint.isNotEmpty
                            ? '${disk.usedFormatted} / ${disk.sizeFormatted}'
                            : disk.sizeFormatted,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        disk.mountpoint.isNotEmpty
                            ? '${disk.availableFormatted} free'
                            : 'Unmounted',
                        style: TextStyle(
                          fontSize: 10,
                          color: disk.mountpoint.isNotEmpty
                              ? Colors.grey.shade600
                              : Colors.orange.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (disk.mountpoint.isNotEmpty)
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
          ),
        ),
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
