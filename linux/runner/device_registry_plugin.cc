#include "device_registry_plugin.h"
#include "../native/device_registry.h"

struct _DeviceRegistryPlugin {
  GObject parent_instance;
  FlMethodChannel* channel;
};

G_DEFINE_TYPE(DeviceRegistryPlugin, device_registry_plugin, G_TYPE_OBJECT)

// Handle method calls from Dart
static void method_call_handler(FlMethodChannel* channel,
                                FlMethodCall* method_call,
                                gpointer user_data) {
  const gchar* method = fl_method_call_get_name(method_call);

  g_autoptr(FlMethodResponse) response = nullptr;

  if (strcmp(method, "getDeviceList") == 0) {
    g_autoptr(GError) error = nullptr;
    FlValue* devices = device_registry_enumerate_all_devices(&error);
    
    if (error != nullptr) {
      response = FL_METHOD_RESPONSE(fl_method_error_response_new(
          "DEVICE_ENUM_ERROR",
          error->message,
          nullptr));
    } else {
      response = FL_METHOD_RESPONSE(fl_method_success_response_new(devices));
    }
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(method_call, response, &error)) {
    g_warning("Failed to send method call response: %s", error->message);
  }
}

static void device_registry_plugin_dispose(GObject* object) {
  DeviceRegistryPlugin* self = DEVICE_REGISTRY_PLUGIN(object);
  g_clear_object(&self->channel);
  G_OBJECT_CLASS(device_registry_plugin_parent_class)->dispose(object);
}

static void device_registry_plugin_class_init(DeviceRegistryPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = device_registry_plugin_dispose;
}

static void device_registry_plugin_init(DeviceRegistryPlugin* self) {}

DeviceRegistryPlugin* device_registry_plugin_new(FlBinaryMessenger* messenger) {
  DeviceRegistryPlugin* self = DEVICE_REGISTRY_PLUGIN(
      g_object_new(device_registry_plugin_get_type(), nullptr));

  // Create method channel
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->channel = fl_method_channel_new(
      messenger,
      "com.swipe.device/registry",
      FL_METHOD_CODEC(codec));
  
  fl_method_channel_set_method_call_handler(
      self->channel,
      method_call_handler,
      self,
      nullptr);

  return self;
}
