import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/device_info.dart';
import 'devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit() : super(const DevicesState.initial()) {
    _loadMockData();
  }

  void _loadMockData() {
    // Mock data - will be replaced with real data later
    final devices = [
      DeviceInfo(
        name: 'sda',
        model: 'WDC WD10EZEX',
        serialNumber: 'WD-WCC6Z0E1F2G3',
        connection: 'SATA',
        mediaType: 'Magnetic',
        capacity: '1 TB',
        secureEraseSupported: false,
        deviceType: 'disk',
      ),
      DeviceInfo(
        name: 'nvme0n1',
        model: 'Samsung 970 EVO',
        serialNumber: 'S467NX0K123456',
        connection: 'NVMe Bus',
        mediaType: 'Flash Memory',
        capacity: '512 GB',
        secureEraseSupported: true,
        deviceType: 'nvme',
      ),
      DeviceInfo(
        name: 'sdb',
        model: 'Kingston DataTraveler',
        serialNumber: '001A4D5C6B7A',
        connection: 'USB',
        mediaType: 'Flash Memory',
        capacity: '256 GB',
        secureEraseSupported: false,
        deviceType: 'usb',
      ),
      DeviceInfo(
        name: 'sdc',
        model: 'Crucial MX500',
        serialNumber: '2045E0B4A1B2',
        connection: 'SATA',
        mediaType: 'Flash Memory',
        capacity: '500 GB',
        secureEraseSupported: true,
        deviceType: 'disk',
      ),
    ];

    final partitions = [
      PartitionInfo(
        name: 'sda1',
        fileSystem: 'ext4',
        size: '931.5 GB',
        mountPoint: '/data',
      ),
      PartitionInfo(
        name: 'nvme0n1p1',
        fileSystem: 'vfat',
        size: '512 MB',
        mountPoint: '/boot/efi',
      ),
      PartitionInfo(
        name: 'nvme0n1p2',
        fileSystem: 'btrfs',
        size: '476.4 GB',
        mountPoint: '/',
      ),
      PartitionInfo(
        name: 'sdb1',
        fileSystem: 'ntfs',
        size: '256 GB',
        mountPoint: '-',
      ),
    ];

    emit(state.copyWith(devices: devices, partitions: partitions));
  }

  void togglePartitionSelection(int index) {
    final updatedPartitions = state.partitions.asMap().entries.map((entry) {
      if (entry.key == index) {
        return PartitionInfo(
          name: entry.value.name,
          fileSystem: entry.value.fileSystem,
          size: entry.value.size,
          mountPoint: entry.value.mountPoint,
          isSelected: !entry.value.isSelected,
        );
      }
      return entry.value;
    }).toList();
    
    final allSelected = updatedPartitions.every((p) => p.isSelected);
    
    emit(state.copyWith(
      partitions: updatedPartitions,
      selectAllPartitions: allSelected,
    ));
  }

  void toggleSelectAll(bool value) {
    final updatedPartitions = state.partitions.map((partition) {
      return PartitionInfo(
        name: partition.name,
        fileSystem: partition.fileSystem,
        size: partition.size,
        mountPoint: partition.mountPoint,
        isSelected: value,
      );
    }).toList();
    
    emit(state.copyWith(
      partitions: updatedPartitions,
      selectAllPartitions: value,
    ));
  }

  void setConnectionStatus(bool isConnected) {
    emit(state.copyWith(isConnected: isConnected));
  }
}
