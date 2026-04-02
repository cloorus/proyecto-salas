import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/users_repository.dart';
import '../../data/repositories/api_users_repository.dart';

/// Provider del repositorio de usuarios
final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  return ApiUsersRepository();
});

/// Provider para obtener todos los usuarios
final usersProvider = FutureProvider<List<AppUser>>((ref) async {
  final repository = ref.read(usersRepositoryProvider);
  final result = await repository.getUsers();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (users) => users,
  );
});

/// Provider para obtener un usuario por ID
final userByIdProvider = FutureProvider.family<AppUser, String>((ref, userId) async {
  final repository = ref.read(usersRepositoryProvider);
  final result = await repository.getUserById(userId);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (user) => user,
  );
});

/// Provider para obtener usuarios de un dispositivo específico
final deviceUsersProvider = FutureProvider.family<List<AppUser>, String>((ref, deviceId) async {
  final repository = ref.read(usersRepositoryProvider);
  final result = await repository.getDeviceUsers(deviceId);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (users) => users,
  );
});

/// StateNotifier para manejar la actualización de roles de usuario
class UsersNotifier extends StateNotifier<AsyncValue<List<AppUser>>> {
  UsersNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadUsers();
  }

  final UsersRepository _repository;

  Future<void> _loadUsers() async {
    final result = await _repository.getUsers();
    state = result.fold(
      (failure) => AsyncValue.error(failure.message, StackTrace.current),
      (users) => AsyncValue.data(users),
    );
  }

  Future<void> updateUserRole(String userId, String deviceId, UserRole newRole) async {
    state = const AsyncValue.loading();
    
    final result = await _repository.updateUserRole(userId, deviceId, newRole);
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (_) => _loadUsers(), // Reload users after update
    );
  }

  void refresh() {
    _loadUsers();
  }
}

/// Provider del StateNotifier para usuarios
final usersNotifierProvider = StateNotifierProvider<UsersNotifier, AsyncValue<List<AppUser>>>((ref) {
  final repository = ref.read(usersRepositoryProvider);
  return UsersNotifier(repository);
});