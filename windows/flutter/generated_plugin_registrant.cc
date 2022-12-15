//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_gl_windows/flutter_gl_windows_plugin.h>
#include <local_auth_windows/local_auth_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterGlWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterGlWindowsPlugin"));
  LocalAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LocalAuthPlugin"));
}
