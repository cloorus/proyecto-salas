import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to manage permissions per device.
/// Key: deviceId
/// Value: List of allowed permission strings
final permissionsProvider = StateNotifierProvider<PermissionsNotifier, Map<String, Set<String>>>((ref) {
  return PermissionsNotifier();
});

class PermissionsNotifier extends StateNotifier<Map<String, Set<String>>> {
  PermissionsNotifier() : super({});

  void setPermissions(String deviceId, Set<String> permissions) {
    state = {
      ...state,
      deviceId: permissions,
    };
  }

  void addPermission(String deviceId, String permission) {
    final current = state[deviceId] ?? {};
    state = {
      ...state,
      deviceId: {...current, permission},
    };
  }

  void removePermission(String deviceId, String permission) {
    final current = state[deviceId] ?? {};
    state = {
      ...state,
      deviceId: current.where((p) => p != permission).toSet(),
    };
  }
}
