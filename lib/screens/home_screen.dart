import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipe/theme/theme.dart';
import '../models/device_info.dart';
import '../blocs/devices/devices_cubit.dart';
import '../blocs/devices/devices_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesCubit, DevicesState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1400),
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPageTitle(context),
                  AppSpacing.gapVerticalLG,
                  _buildDeviceTable(context, state.devices),
                  AppSpacing.gapVerticalXXL,
                  _buildPartitionSectionHeader(context),
                  AppSpacing.gapVerticalMD,
                  _buildPartitionTable(context, state),
                  AppSpacing.gapVerticalXXL,
                  _buildActionButton(context, state.hasSelectedPartitions),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPageTitle(BuildContext context) {
    return Text(
      'Device Discovery Dashboard',
      style: AppTypography.displaySmall.withColor(
        Theme.of(context).textTheme.bodyLarge!.color!,
      ),
    );
  }

  Widget _buildDeviceTable(BuildContext context, List<DeviceInfo> devices) {
    return Container(
      margin: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
          ),
          dataRowMinHeight: 72,
          dataRowMaxHeight: 72,
          dividerThickness: 1,
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          columns: [
            DataColumn(
              label: Text(
                'Type',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Drive Name',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Model',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Serial Number',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Connection',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Media Type',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Capacity',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Secure Erase',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
          ],
          rows: devices.map((device) => _buildDeviceRow(context, device)).toList(),
        ),
      ),
    );
  }

  DataRow _buildDeviceRow(BuildContext context, DeviceInfo device) {
    return DataRow(
      cells: [
        DataCell(
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Icon(
              _getIconForDevice(device.iconName),
              color: Theme.of(context).textTheme.bodyMedium!.color!.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              device.name,
              style: AppTypography.bodyMedium.withColor(
                Theme.of(context).textTheme.bodyLarge!.color!,
              ),
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              device.model,
              style: AppTypography.bodyMedium.withColor(
                Theme.of(context).textTheme.bodyMedium!.color!,
              ),
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              device.serialNumber,
              style: AppTypography.bodyMedium.withColor(
                Theme.of(context).textTheme.bodyMedium!.color!,
              ),
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              device.connection,
              style: AppTypography.bodyMedium.withColor(
                Theme.of(context).textTheme.bodyMedium!.color!,
              ),
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                borderRadius: AppSpacing.borderRadiusSM,
              ),
              child: Text(
                device.mediaType,
                style: AppTypography.labelSmall.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              device.capacity,
              style: AppTypography.bodyMedium.withColor(
                Theme.of(context).textTheme.bodyMedium!.color!,
              ),
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _buildSecureEraseStatus(device.secureEraseSupported),
          ),
        ),
      ],
    );
  }

  Widget _buildSecureEraseStatus(bool supported) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          supported ? Icons.verified_user : Icons.cancel,
          size: 16,
          color: supported ? AppColors.success : AppColors.error,
        ),
        AppSpacing.gapHorizontalXS,
        Text(
          supported ? 'Available' : 'Not Supported',
          style: AppTypography.labelSmall.withColor(
            supported ? AppColors.success : AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildPartitionSectionHeader(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Wiping Scope',
            style: AppTypography.headlineMedium.withColor(
              Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
          AppSpacing.gapVerticalSM,
          Text(
            'Select one or more partitions for \'Clear\' methods. For \'Purge\' methods like Secure Erase, the entire physical drive will be wiped.',
            style: AppTypography.bodyMedium.withColor(
              Theme.of(context).textTheme.bodyMedium!.color!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartitionTable(BuildContext context, DevicesState state) {
    return Container(
      margin: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: AppSpacing.borderRadiusLG,
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.03),
          ),
          dataRowMinHeight: 60,
          dataRowMaxHeight: 60,
          dividerThickness: 1,
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          columns: [
            DataColumn(
              label: Checkbox(
                value: state.selectAllPartitions,
                onChanged: (value) {
                  context.read<DevicesCubit>().toggleSelectAll(value ?? false);
                },
              ),
            ),
            DataColumn(
              label: Text(
                'Partition',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'File System',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Size',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Mount Point',
                style: AppTypography.labelMedium.withColor(
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
            ),
          ],
          rows: state.partitions
              .asMap()
              .entries
              .map((entry) => _buildPartitionRow(context, entry.value, entry.key))
              .toList(),
        ),
      ),
    );
  }

  DataRow _buildPartitionRow(BuildContext context, PartitionInfo partition, int index) {
    return DataRow(
      cells: [
        DataCell(
          Checkbox(
            value: partition.isSelected,
            onChanged: (value) {
              context.read<DevicesCubit>().togglePartitionSelection(index);
            },
          ),
        ),
        DataCell(
          Text(
            partition.name,
            style: AppTypography.bodyMedium.withColor(
              Theme.of(context).textTheme.bodyLarge!.color!,
            ),
          ),
        ),
        DataCell(
          Text(
            partition.fileSystem,
            style: AppTypography.bodyMedium.withColor(
              Theme.of(context).textTheme.bodyMedium!.color!,
            ),
          ),
        ),
        DataCell(
          Text(
            partition.size,
            style: AppTypography.bodyMedium.withColor(
              Theme.of(context).textTheme.bodyMedium!.color!,
            ),
          ),
        ),
        DataCell(
          Text(
            partition.mountPoint,
            style: AppTypography.bodyMedium.withColor(
              Theme.of(context).textTheme.bodyMedium!.color!,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, bool hasSelectedPartitions) {
    return Padding(
      padding: AppSpacing.paddingLG,
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: hasSelectedPartitions
              ? () {
                  // Navigate to sanitization screen
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            minimumSize: const Size(84, 48),
          ),
          child: const Text('Proceed to Sanitize'),
        ),
      ),
    );
  }

  IconData _getIconForDevice(String iconName) {
    switch (iconName) {
      case 'memory':
        return Icons.memory;
      case 'save':
        return Icons.save;
      case 'database':
      default:
        return Icons.storage;
    }
  }
}
