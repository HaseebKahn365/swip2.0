import 'package:equatable/equatable.dart';
import '../../models/device_info.dart';

class DevicesState extends Equatable {
  final List<DeviceInfo> devices;
  final List<PartitionInfo> partitions;
  final bool selectAllPartitions;
  final bool isConnected;

  const DevicesState({
    required this.devices,
    required this.partitions,
    required this.selectAllPartitions,
    required this.isConnected,
  });

  const DevicesState.initial()
      : devices = const [],
        partitions = const [],
        selectAllPartitions = false,
        isConnected = true;

  DevicesState copyWith({
    List<DeviceInfo>? devices,
    List<PartitionInfo>? partitions,
    bool? selectAllPartitions,
    bool? isConnected,
  }) {
    return DevicesState(
      devices: devices ?? this.devices,
      partitions: partitions ?? this.partitions,
      selectAllPartitions: selectAllPartitions ?? this.selectAllPartitions,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  bool get hasSelectedPartitions => partitions.any((p) => p.isSelected);

  @override
  List<Object?> get props => [devices, partitions, selectAllPartitions, isConnected];
}
