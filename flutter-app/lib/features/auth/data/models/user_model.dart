import '../../domain/entities/user.dart';

/// Modelo de datos de Usuario (DTO)
/// Convierte entre JSON y Entity
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.photoUrl,
    super.role,
    required super.createdAt,
  });
  
  /// Convierte from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: (json['name'] ?? json['full_name'] ?? '') as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      photoUrl: (json['photoUrl'] ?? json['photo_url']) as String?,
      role: _parseRole(json['role'] as String?),
      createdAt: DateTime.tryParse(
        (json['createdAt'] ?? json['created_at'] ?? '').toString(),
      ) ?? DateTime.now(),
    );
  }
  
  /// Convierte to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  /// Convierte a Entity
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      role: role,
      createdAt: createdAt,
    );
  }
  
  /// Crea desde Entity
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      photoUrl: user.photoUrl,
      role: user.role,
      createdAt: user.createdAt,
    );
  }
  
  static UserRole _parseRole(String? role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'user':
        return UserRole.user;
      case 'guest':
        return UserRole.guest;
      default:
        return UserRole.user;
    }
  }
}
