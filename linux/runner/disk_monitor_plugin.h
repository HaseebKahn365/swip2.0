#ifndef DISK_MONITOR_PLUGIN_H_
#define DISK_MONITOR_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>
#include <thread>
#include <atomic>
#include <memory>

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(DiskMonitorPlugin, disk_monitor_plugin, DISK_MONITOR, PLUGIN, GObject)

DiskMonitorPlugin* disk_monitor_plugin_new(FlBinaryMessenger* messenger);

void disk_monitor_plugin_start_monitoring(DiskMonitorPlugin* self);
void disk_monitor_plugin_stop_monitoring(DiskMonitorPlugin* self);

G_END_DECLS

#endif  // DISK_MONITOR_PLUGIN_H_
