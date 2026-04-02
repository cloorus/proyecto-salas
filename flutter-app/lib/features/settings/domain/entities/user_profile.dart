import 'package:equatable/equatable.dart';

/// Entidad del Perfil de Usuario
class UserProfile extends Equatable {
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? country;
  final String? language;
  final String? profilePhotoUrl;

  const UserProfile({
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.country,
    this.language,
    this.profilePhotoUrl,
  });

  /// Crea una copia del perfil con los campos especificados actualizados
  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? country,
    String? language,
    String? profilePhotoUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      country: country ?? this.country,
      language: language ?? this.language,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
    );
  }

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        address,
        country,
        language,
        profilePhotoUrl,
      ];
}