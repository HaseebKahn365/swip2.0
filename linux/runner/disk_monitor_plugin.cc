#include "disk_monitor_plugin.h"
#include <cstring>
#include <sstream>
#include <vector>
#include <map>
#include <array>
#include <memory>
#include <chrono>
#include <thread>

struct _DiskMonitorPlugin {
  GObject parent_instance;
  FlBinaryMessenger* messenger;
  FlEventChannel* event_channel;
  FlMethodChannel* method_channel;
  std::thread* monitor_thread;
  std::atomic<bool> monitoring;
};

G_DEFINE_TYPE(DiskMonitorPlugin, disk_monitor_plugin, G_TYPE_OBJECT)

// Execute shell command and return output
static std::string exec_command(const char* cmd) {
  std::array<char, 128> buffer;
  std::string result;
  std::unique_ptr<FILE, decltype(&pclose)> pipe(popen(cmd, "r"), pclose);
  if (!pipe) {
    return "";
  }
  while (fgets(buffer.data(), buffer.size(), pipe.get()) != nullptr) {
    result += buffer.data();
  }
  return result;
}

// Helper function to clean device name (remove tree characters)
static std::string clean_device_name(const std::string& name) {
  std::string result;
  bool found_alpha = false;
  
  for (size_t i = 0; i < name.length(); i++) {
    unsigned char c = static_cast<unsigned char>(name[i]);
    
    // Skip UTF-8 tree drawing characters (multi-byte) and spaces
    if (!found_alpha) {
      if (c == ' ' || c > 127) {
        // Skip UTF-8 continuation bytes
        while (i + 1 < name.length() && (static_cast<unsigned char>(name[i + 1]) & 0xC0) == 0x80) {
          i++;
        }
        continue;
      }
    }
    
    found_alpha = true;
    result += name[i];
  }
  
  return result;
}

// Parse disk information and create FlValue
static FlValue* get_disk_info() {
  FlValue* disk_list = fl_value_new_list();
  
  // Get disk usage information using df - map by device name
  std::string df_output = exec_command(
    "df -B1 --output=source,size,used,avail,pcent,target 2>/dev/null | tail -n +2"
  );
  
  // Parse df output into maps by both mountpoint and device
  std::map<std::string, std::map<std::string, std::string>> df_by_mount;
  std::map<std::string, std::map<std::string, std::string>> df_by_device;
  std::istringstream df_stream(df_output);
  std::string line;
  
  while (std::getline(df_stream, line)) {
    if (line.empty()) continue;
    
    std::istringstream line_stream(line);
    std::string source, size, used, avail, pcent;
    std::string target;
    
    line_stream >> source >> size >> used >> avail >> pcent;
    std::getline(line_stream, target);
    
    // Trim leading spaces from target
    size_t start = target.find_first_not_of(" \t");
    if (start != std::string::npos) {
      target = target.substr(start);
    }
    
    if (!source.empty() && !target.empty()) {
      df_by_mount[target]["source"] = source;
      df_by_mount[target]["size"] = size;
      df_by_mount[target]["used"] = used;
      df_by_mount[target]["avail"] = avail;
      df_by_mount[target]["pcent"] = pcent;
      
      // Also map by device name (extract just the device part)
      std::string device = source;
      if (device.find("/dev/") == 0) {
        device = device.substr(5); // Remove /dev/
      }
      df_by_device[device] = df_by_mount[target];
    }
  }
  
  // Use lsblk with plain output - parse more carefully
  std::string lsblk_plain = exec_command(
    "lsblk -b -o NAME,SIZE,MOUNTPOINT,TYPE,FSTYPE,MODEL --noheadings 2>/dev/null"
  );
  
  std::istringstream plain_stream(lsblk_plain);
  while (std::getline(plain_stream, line)) {
    if (line.empty()) continue;
    
    // Split line into fields more carefully
    std::vector<std::string> fields;
    std::istringstream line_stream(line);
    std::string field;
    
    // Read NAME
    line_stream >> field;
    std::string name = clean_device_name(field);
    
    // Read SIZE
    std::string size_str;
    line_stream >> size_str;
    
    // Read rest of line to parse mountpoint, type, fstype
    std::string rest;
    std::getline(line_stream, rest);
    
    std::string mountpoint, type, fstype, model;
    
    // Parse the rest - mountpoint might have spaces
    std::istringstream rest_stream(rest);
    std::string token;
    std::vector<std::string> tokens;
    
    while (rest_stream >> token) {
      tokens.push_back(token);
    }
    
    // Determine fields based on whether mountpoint exists
    if (!tokens.empty()) {
      if (tokens[0].find("/") == 0) {
        // Has mountpoint
        mountpoint = tokens[0];
        if (tokens.size() > 1) type = tokens[1];
        if (tokens.size() > 2) fstype = tokens[2];
        if (tokens.size() > 3) {
          for (size_t i = 3; i < tokens.size(); i++) {
            if (!model.empty()) model += " ";
            model += tokens[i];
          }
        }
      } else {
        // No mountpoint
        type = tokens[0];
        if (tokens.size() > 1) fstype = tokens[1];
        if (tokens.size() > 2) {
          for (size_t i = 2; i < tokens.size(); i++) {
            if (!model.empty()) model += " ";
            model += tokens[i];
          }
        }
      }
    }
    
    // Create disk info object
    FlValue* disk_info = fl_value_new_map();
    
    fl_value_set_string_take(disk_info, "name", 
                              fl_value_new_string(name.c_str()));
    fl_value_set_string_take(disk_info, "size", 
                              fl_value_new_string(size_str.c_str()));
    fl_value_set_string_take(disk_info, "type", 
                              fl_value_new_string(type.c_str()));
    fl_value_set_string_take(disk_info, "fstype", 
                              fl_value_new_string(fstype.c_str()));
    fl_value_set_string_take(disk_info, "mountpoint", 
                              fl_value_new_string(mountpoint.c_str()));
    fl_value_set_string_take(disk_info, "model",
                              fl_value_new_string(model.c_str()));
    
    // Add usage information - try both mountpoint and device name
    bool found_usage = false;
    
    if (!mountpoint.empty() && df_by_mount.find(mountpoint) != df_by_mount.end()) {
      auto& usage = df_by_mount[mountpoint];
      fl_value_set_string_take(disk_info, "used", 
                                fl_value_new_string(usage["used"].c_str()));
      fl_value_set_string_take(disk_info, "available", 
                                fl_value_new_string(usage["avail"].c_str()));
      fl_value_set_string_take(disk_info, "usagePercent", 
                                fl_value_new_string(usage["pcent"].c_str()));
      found_usage = true;
    } else if (df_by_device.find(name) != df_by_device.end()) {
      auto& usage = df_by_device[name];
      fl_value_set_string_take(disk_info, "used", 
                                fl_value_new_string(usage["used"].c_str()));
      fl_value_set_string_take(disk_info, "available", 
                                fl_value_new_string(usage["avail"].c_str()));
      fl_value_set_string_take(disk_info, "usagePercent", 
                                fl_value_new_string(usage["pcent"].c_str()));
      found_usage = true;
    }
    
    if (!found_usage) {
      fl_value_set_string_take(disk_info, "used", fl_value_new_string("0"));
      fl_value_set_string_take(disk_info, "available", fl_value_new_string("0"));
      fl_value_set_string_take(disk_info, "usagePercent", fl_value_new_string("0%"));
    }
    
    fl_value_append_take(disk_list, disk_info);
  }
  
  return disk_list;
}

// Method call handler
static void method_call_handler(FlMethodChannel* channel,
                                FlMethodCall* method_call,
                                gpointer user_data) {
  const gchar* method = fl_method_call_get_name(method_call);
  
  g_autoptr(FlMethodResponse) response = nullptr;
  
  if (strcmp(method, "getDiskInfo") == 0) {
    FlValue* disk_info = get_disk_info();
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(disk_info));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }
  
  fl_method_call_respond(method_call, response, nullptr);
}

// Event channel listen handler
static FlMethodErrorResponse* listen_handler(FlEventChannel* channel,
                                             FlValue* args,
                                             gpointer user_data) {
  DiskMonitorPlugin* self = DISK_MONITOR_PLUGIN(user_data);
  disk_monitor_plugin_start_monitoring(self);
  return nullptr;
}

// Event channel cancel handler
static FlMethodErrorResponse* cancel_handler(FlEventChannel* channel,
                                             FlValue* args,
                                             gpointer user_data) {
  DiskMonitorPlugin* self = DISK_MONITOR_PLUGIN(user_data);
  disk_monitor_plugin_stop_monitoring(self);
  return nullptr;
}

// Monitoring thread function with udev monitoring
static void monitor_thread_func(DiskMonitorPlugin* self) {
  std::string last_state = "";
  
  while (self->monitoring.load()) {
    // Get current disk state
    std::string current_state = exec_command(
      "lsblk -b -o NAME,SIZE,MOUNTPOINT,TYPE,FSTYPE --noheadings 2>/dev/null && "
      "df -B1 --output=source,size,used,avail,pcent,target 2>/dev/null | tail -n +2"
    );
    
    // Only send update if state changed
    if (current_state != last_state) {
      FlValue* disk_info = get_disk_info();
      
      // Send event to Flutter on main thread
      g_idle_add([](gpointer user_data) -> gboolean {
        auto* data = static_cast<std::pair<DiskMonitorPlugin*, FlValue*>*>(user_data);
        fl_event_channel_send(data->first->event_channel, data->second, nullptr, nullptr);
        delete data;
        return G_SOURCE_REMOVE;
      }, new std::pair<DiskMonitorPlugin*, FlValue*>(self, disk_info));
      
      last_state = current_state;
    }
    
    // Check every 500ms for faster response
    std::this_thread::sleep_for(std::chrono::milliseconds(500));
  }
}

void disk_monitor_plugin_start_monitoring(DiskMonitorPlugin* self) {
  if (self->monitoring.load()) {
    return;  // Already monitoring
  }
  
  self->monitoring.store(true);
  self->monitor_thread = new std::thread(monitor_thread_func, self);
}

void disk_monitor_plugin_stop_monitoring(DiskMonitorPlugin* self) {
  if (!self->monitoring.load()) {
    return;  // Not monitoring
  }
  
  self->monitoring.store(false);
  if (self->monitor_thread && self->monitor_thread->joinable()) {
    self->monitor_thread->join();
    delete self->monitor_thread;
    self->monitor_thread = nullptr;
  }
}

static void disk_monitor_plugin_dispose(GObject* object) {
  DiskMonitorPlugin* self = DISK_MONITOR_PLUGIN(object);
  
  disk_monitor_plugin_stop_monitoring(self);
  
  g_clear_object(&self->messenger);
  g_clear_object(&self->event_channel);
  g_clear_object(&self->method_channel);
  
  G_OBJECT_CLASS(disk_monitor_plugin_parent_class)->dispose(object);
}

static void disk_monitor_plugin_class_init(DiskMonitorPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = disk_monitor_plugin_dispose;
}

static void disk_monitor_plugin_init(DiskMonitorPlugin* self) {
  self->monitor_thread = nullptr;
  self->monitoring.store(false);
}

DiskMonitorPlugin* disk_monitor_plugin_new(FlBinaryMessenger* messenger) {
  DiskMonitorPlugin* self = DISK_MONITOR_PLUGIN(
      g_object_new(disk_monitor_plugin_get_type(), nullptr));
  
  self->messenger = FL_BINARY_MESSENGER(g_object_ref(messenger));
  
  // Create method channel
  g_autoptr(FlStandardMethodCodec) method_codec = fl_standard_method_codec_new();
  self->method_channel = fl_method_channel_new(
      messenger,
      "disk_monitor/method",
      FL_METHOD_CODEC(method_codec));
  fl_method_channel_set_method_call_handler(
      self->method_channel,
      method_call_handler,
      self,
      nullptr);
  
  // Create event channel
  g_autoptr(FlStandardMethodCodec) event_codec = fl_standard_method_codec_new();
  self->event_channel = fl_event_channel_new(
      messenger,
      "disk_monitor/event",
      FL_METHOD_CODEC(event_codec));
  fl_event_channel_set_stream_handlers(
      self->event_channel,
      listen_handler,
      cancel_handler,
      self,
      nullptr);
  
  return self;
}
