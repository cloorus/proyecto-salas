import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'dart:convert';

/// Data Source para operaciones locales de autenticación
abstract class AuthLocalDataSource {
  /// Guarda el token localmente
  Future<void> saveToken(String token);
  
  /// Obtiene el token guardado
  Future<String?> getToken();
  
  /// Elimina el token
  Future<void> deleteToken();
  
  /// Guarda usuario localmente
  Future<void> saveUser(UserModel user);
  
  /// Obtiene usuario guardado
  Future<UserModel?> getUser();
  
  /// Elimina usuario
  Future<void> deleteUser();
  
  /// Guarda estado de "recordarme"
  Future<void> saveRememberMe(bool rememberMe);
  
  /// Obtiene estado de "recordarme"
  Future<bool> getRememberMe();
}

/// Implementación con SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  
  static const _keyToken = 'auth_token';
  static const _keyUser = 'auth_user';
  static const _keyRememberMe = 'auth_remember_me';
  
  AuthLocalDataSourceImpl(this.sharedPreferences);
  
  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_keyToken, token);
  }
  
  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_keyToken);
  }
  
  @override
  Future<void> deleteToken() async {
    await sharedPreferences.remove(_keyToken);
  }
  
  @override
  Future<void> saveUser(UserModel user) async {
    final json = jsonEncode(user.toJson());
    await sharedPreferences.setString(_keyUser, json);
  }
  
  @override
  Future<UserModel?> getUser() async {
    final json = sharedPreferences.getString(_keyUser);
    if (json == null) return null;
    
    final map = jsonDecode(json) as Map<String, dynamic>;
    return UserModel.fromJson(map);
  }
  
  @override
  Future<void> deleteUser() async {
    await sharedPreferences.remove(_keyUser);
  }
  
  @override
  Future<void> saveRememberMe(bool rememberMe) async {
    await sharedPreferences.setBool(_keyRememberMe, rememberMe);
  }
  
  @override
  Future<bool> getRememberMe() async {
    return sharedPreferences.getBool(_keyRememberMe) ?? false;
  }
}
