import 'package:equatable/equatable.dart';

/// Entidad de Usuario
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final UserRole role;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.role = UserRole.user,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, phone, photoUrl, role, createdAt];
}

/// Roles de usuario
enum UserRole {
  admin,
  user,
  guest,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.user:
        return 'Usuario';
      case UserRole.guest:
        return 'Invitado';
    }
  }
}
