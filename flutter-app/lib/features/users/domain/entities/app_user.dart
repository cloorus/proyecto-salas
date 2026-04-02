import 'package:equatable/equatable.dart';

/// Entidad de Usuario de la Aplicación
class AppUser extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? country;
  final String? profilePhoto;
  final UserRole role;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.country,
    this.profilePhoto,
    this.role = UserRole.user,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        country,
        profilePhoto,
        role,
        createdAt,
      ];
}

/// Roles de usuario en el sistema
enum UserRole {
  admin,      // Administrador
  owner,      // Propietario
  user,       // Usuario estándar
  guest,      // Invitado
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.owner:
        return 'Propietario';
      case UserRole.user:
        return 'Usuario';
      case UserRole.guest:
        return 'Invitado';
    }
  }

  bool get canManageUsers {
    switch (this) {
      case UserRole.admin:
      case UserRole.owner:
        return true;
      case UserRole.user:
      case UserRole.guest:
        return false;
    }
  }

  bool get canManageDevices {
    switch (this) {
      case UserRole.admin:
      case UserRole.owner:
        return true;
      case UserRole.user:
      case UserRole.guest:
        return false;
    }
  }
}