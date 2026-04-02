import '../../domain/entities/app_user.dart';

/// Datos mock de usuarios para pruebas y demos
class MockUsers {
  static final List<AppUser> _users = [
    AppUser(
      id: '1',
      name: 'Carlos Mena',
      email: 'carlos@bgnius.com',
      phone: '+506 8888-8888',
      country: 'Costa Rica',
      role: UserRole.admin,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    AppUser(
      id: '2',
      name: 'Ana García',
      email: 'ana.garcia@email.com',
      phone: '+506 7777-7777',
      country: 'Costa Rica',
      role: UserRole.owner,
      createdAt: DateTime.now().subtract(const Duration(days: 200)),
    ),
    AppUser(
      id: '3',
      name: 'Widget Carro Esposa',
      email: 'esposa@email.com',
      phone: '+506 6666-6666',
      country: 'Costa Rica',
      role: UserRole.user,
      createdAt: DateTime.now().subtract(const Duration(days: 150)),
    ),
    AppUser(
      id: '4',
      name: 'Usuario 1',
      email: 'usuario1@email.com',
      phone: '+506 5555-5555',
      country: 'Costa Rica',
      role: UserRole.user,
      createdAt: DateTime.now().subtract(const Duration(days: 100)),
    ),
    AppUser(
      id: '5',
      name: 'Usuario 2',
      email: 'usuario2@email.com',
      phone: '+506 4444-4444',
      country: 'Costa Rica',
      role: UserRole.user,
      createdAt: DateTime.now().subtract(const Duration(days: 75)),
    ),
    AppUser(
      id: '6',
      name: 'Usuario con control 1',
      email: 'control1@email.com',
      phone: '+506 3333-3333',
      country: 'Costa Rica',
      role: UserRole.user,
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
    ),
    AppUser(
      id: '7',
      name: 'Botón Carro',
      email: 'carro@email.com',
      phone: '+506 2222-2222',
      country: 'Costa Rica',
      role: UserRole.guest,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    AppUser(
      id: '8',
      name: 'Pedro Jiménez',
      email: 'pedro.jimenez@email.com',
      phone: '+506 1111-1111',
      country: 'Costa Rica',
      role: UserRole.user,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
  ];

  /// Obtiene todos los usuarios
  static List<AppUser> getAll() => List.from(_users);

  /// Obtiene un usuario por ID
  static AppUser? getById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Obtiene usuarios por dispositivo (simulado con algunos usuarios por defecto)
  static List<AppUser> getByDeviceId(String deviceId) {
    // Para simulación, devolver usuarios según el ID del dispositivo
    switch (deviceId) {
      case '1': // Dispositivo principal
        return _users.where((user) => ['1', '2', '3', '4'].contains(user.id)).toList();
      case '2':
        return _users.where((user) => ['1', '2', '5', '6'].contains(user.id)).toList();
      case '3':
        return _users.where((user) => ['1', '7', '8'].contains(user.id)).toList();
      default:
        return _users.take(3).toList(); // Usuarios por defecto
    }
  }

  /// Obtiene usuarios con rol específico
  static List<AppUser> getByRole(UserRole role) {
    return _users.where((user) => user.role == role).toList();
  }

  /// Actualiza el rol de un usuario (simulación)
  static AppUser updateUserRole(String userId, UserRole newRole) {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex == -1) {
      throw Exception('Usuario no encontrado');
    }

    final user = _users[userIndex];
    final updatedUser = AppUser(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      country: user.country,
      profilePhoto: user.profilePhoto,
      role: newRole,
      createdAt: user.createdAt,
    );

    _users[userIndex] = updatedUser;
    return updatedUser;
  }
}