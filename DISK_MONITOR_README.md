# Linux Disk Monitor - Flutter Application

A Flutter application that monitors and displays detailed information about all attached disks on a Linux system in real-time.

## Features

- **Real-time Monitoring**: Stream live updates of disk information every 2 seconds
- **Detailed Disk Information**: 
  - Disk name and type (disk, partition, loop device, etc.)
  - Total size, used space, and available space
  - Mount points
  - File system type
  - Usage percentage with visual progress bar
- **Two Modes**:
  - **Static Mode**: Fetch disk information on-demand
  - **Live Mode**: Continuous streaming of disk updates
- **Visual Indicators**: Color-coded usage bars (green < 70%, orange < 90%, red >= 90%)
- **Responsive UI**: Material Design 3 with clean, modern interface

## Architecture

### Linux Backend (C++)
- **Location**: `linux/runner/disk_monitor_plugin.cc`
- **Commands Used**:
  - `lsblk`: Lists block devices with size, type, and mount points
  - `df`: Provides disk usage statistics (used, available, percentage)
- **Communication**:
  - **MethodChannel** (`disk_monitor/method`): For one-time disk info requests
  - **EventChannel** (`disk_monitor/event`): For streaming real-time updates
- **Monitoring Thread**: Background thread that polls disk information every 2 seconds

### Flutter Frontend
- **Models** (`lib/models/disk_info.dart`): Data model for disk information
- **Services** (`lib/services/disk_monitor_service.dart`): Platform channel communication
- **UI** (`lib/main.dart`): Main application with disk display cards

## Building and Running

### Prerequisites
- Flutter SDK (3.9.2 or higher)
- Linux development environment
- GTK 3.0 development libraries

### Build Commands

```bash
# Get dependencies
flutter pub get

# Run in debug mode
flutter run -d linux

# Build release version
flutter build linux --release
```

### Running the Application

```bash
# From project root
flutter run -d linux

# Or run the built executable
./build/linux/x64/release/bundle/swipe
```

## Usage

1. **Launch the app**: The app starts with no data loaded
2. **Load disk info**: Click the refresh button or "Load Disk Info" button
3. **Enable live monitoring**: Click the play button in the app bar to start streaming
4. **Pause monitoring**: Click the pause button to stop streaming
5. **Manual refresh**: Click the refresh button anytime in static mode

## Disk Information Displayed

For each disk/partition:
- **Name**: Device name (e.g., sda, sda1, nvme0n1)
- **Type**: Device type (disk, part, loop, rom)
- **File System**: ext4, ntfs, vfat, etc.
- **Total Size**: Total capacity in human-readable format
- **Used Space**: Amount of space used
- **Available Space**: Free space remaining
- **Mount Point**: Where the device is mounted (if mounted)
- **Usage Bar**: Visual representation of disk usage with color coding

## Testing

Test the application with various disk configurations:

1. **Internal drives**: Primary system disk and additional internal drives
2. **External drives**: USB drives, external HDDs/SSDs
3. **Partitions**: Multiple partitions on a single disk
4. **Loop devices**: Mounted ISO files or snap packages
5. **Network mounts**: NFS or CIFS mounted drives (if supported)

### Test Scenarios

```bash
# Attach a USB drive while the app is running in live mode
# The app should automatically detect and display the new device

# Fill up disk space
dd if=/dev/zero of=/tmp/testfile bs=1M count=1000
# Watch the usage percentage update in real-time

# Unmount a device
sudo umount /dev/sdb1
# The device should show as "Not Mounted"
```

## Performance Considerations

- **Polling Interval**: Set to 2 seconds (configurable in `disk_monitor_plugin.cc`)
- **Thread Safety**: Uses atomic operations for thread synchronization
- **Resource Usage**: Minimal CPU usage, commands are lightweight
- **Scalability**: Efficiently handles multiple devices (tested with 10+ devices)

## Customization

### Change Polling Interval

Edit `linux/runner/disk_monitor_plugin.cc`:

```cpp
// Change from 2 seconds to desired interval
std::this_thread::sleep_for(std::chrono::seconds(2));
```

### Modify Displayed Information

Edit the `lsblk` and `df` commands in `disk_monitor_plugin.cc` to include additional fields:

```cpp
// Add more fields to lsblk
"lsblk -b -o NAME,SIZE,MOUNTPOINT,TYPE,FSTYPE,MODEL,SERIAL --noheadings 2>/dev/null"
```

## Troubleshooting

### App doesn't show any disks
- Ensure you have proper permissions to run `lsblk` and `df`
- Check if the commands work in terminal: `lsblk` and `df`

### Live monitoring not updating
- Check the app bar for the green "Live Monitoring Active" indicator
- Restart the app and try again

### Build errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter build linux
```

## Platform Channels Reference

### MethodChannel: `disk_monitor/method`
- **Method**: `getDiskInfo`
- **Returns**: List of disk information maps

### EventChannel: `disk_monitor/event`
- **Stream**: Continuous disk information updates
- **Frequency**: Every 2 seconds
- **Format**: List of disk information maps

## License

This project is part of a Flutter demonstration application.
