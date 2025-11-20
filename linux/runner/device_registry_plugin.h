#ifndef DEVICE_REGISTRY_PLUGIN_H_
#define DEVICE_REGISTRY_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

G_DECLARE_FINAL_TYPE(DeviceRegistryPlugin, device_registry_plugin, DEVICE_REGISTRY, PLUGIN, GObject)

DeviceRegistryPlugin* device_registry_plugin_new(FlBinaryMessenger* messenger);

G_END_DECLS

#endif  // DEVICE_REGISTRY_PLUGIN_H_
