import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';

// Definición de RegisteredUser y Enum (Movemos esto aquí para compartirlo)
enum UserType {
  admin,
  bluetooth,
  standard,
  control,
}

extension UserTypeExtension on UserType {
  IconData get icon {
    switch (this) {
      case UserType.admin:
        return Icons.person;
      case UserType.bluetooth:
        return Icons.bluetooth;
      case UserType.standard:
        return Icons.person_outline;
      case UserType.control:
        return Icons.smartphone;
    }
  }

  Color get color {
    switch (this) {
      case UserType.admin:
        return Colors.grey;
      case UserType.bluetooth:
        return AppColors.secondaryBlue;
      case UserType.standard:
        return Colors.grey;
      case UserType.control:
        return AppColors.secondaryBlue;
    }
  }

  String get displayName {
    switch (this) {
      case UserType.admin:
        return 'Admin';
      case UserType.bluetooth:
        return 'Bluetooth';
      case UserType.standard:
        return 'Standard';
      case UserType.control:
        return 'Control';
    }
  }
}

class RegisteredUser {
  final String id;
  final String name;
  final String? email;
  final UserType type;
  final bool isStarred;
  final Set<String> permissions; // Permisos específicos del usuario

  RegisteredUser({
    required this.id,
    required this.name,
    required this.type,
    this.email,
    this.isStarred = false,
    this.permissions = const {},
  });

  RegisteredUser copyWith({
    String? name,
    String? email,
    UserType? type,
    bool? isStarred,
    Set<String>? permissions,
  }) {
    return RegisteredUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      type: type ?? this.type,
      isStarred: isStarred ?? this.isStarred,
      permissions: permissions ?? this.permissions,
    );
  }
}

/// Provider para manejar lista de usuarios por dispositivo
/// Key: DeviceId, Value: List<RegisteredUser>
final sharedUsersProvider = StateNotifierProvider<SharedUsersNotifier, Map<String, List<RegisteredUser>>>((ref) {
  return SharedUsersNotifier();
});

class SharedUsersNotifier extends StateNotifier<Map<String, List<RegisteredUser>>> {
  SharedUsersNotifier() : super({});

  void addUser(String deviceId, RegisteredUser user) {
    final currentList = state[deviceId] ?? [];
    state = {
      ...state,
      deviceId: [...currentList, user],
    };
  }

  void updateUser(String deviceId, RegisteredUser updatedUser) {
    final currentList = state[deviceId] ?? [];
    state = {
      ...state,
      deviceId: currentList.map((u) => u.id == updatedUser.id ? updatedUser : u).toList(),
    };
  }
  
  void removeUser(String deviceId, String userId) {
     final currentList = state[deviceId] ?? [];
    state = {
      ...state,
      deviceId: currentList.where((u) => u.id != userId).toList(),
    };
  }
}
