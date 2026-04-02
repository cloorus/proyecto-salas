import 'package:dio/dio.dart';
import '../routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoints.dart';

/// Singleton HTTP client para manejar todas las peticiones a la API
/// Configurado con JWT token automático y manejo de errores 401
class ApiClient {
  static ApiClient? _instance;
  static ApiClient get instance => _instance ??= ApiClient._internal();

  late Dio _dio;
  String? _accessToken;
  String? _refreshToken;
  SharedPreferences? _prefs;

  ApiClient._internal() {
    _dio = Dio();
    _setupInterceptors();
  }

  /// Inicializa el cliente con SharedPreferences
  Future<void> initialize(SharedPreferences prefs) async {
    _prefs = prefs;
    await _loadTokensFromStorage();
    _updateBaseOptions();
  }

  /// Configura interceptores de request/response/error
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Auto-attach Authorization header si hay token
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          // Handle 401 - token expirado (skip for auth endpoints)
          final isAuthEndpoint = error.requestOptions.path.contains('/auth/login') || 
                                 error.requestOptions.path.contains('/auth/register');
          if (error.response?.statusCode == 401 && !isAuthEndpoint) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              // Reintentar request original
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $_accessToken';
              try {
                final response = await _dio.request(
                  opts.path,
                  options: Options(
                    method: opts.method,
                    headers: opts.headers,
                  ),
                  data: opts.data,
                  queryParameters: opts.queryParameters,
                );
                handler.resolve(response);
                return;
              } catch (e) {
                // Si falla el retry, seguir con el error original
              }
            }
            
            // Si no se pudo refrescar o falló el retry, limpiar tokens y redirigir a login
            await clearTokens();
            appRouter.go('/');
            
          }
          handler.next(error);
        },
      ),
    );

    // Log interceptor para debug (solo en modo debug)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) {
        // Solo log en debug mode
        assert(() {
          print('[API] $obj');
          return true;
        }());
      },
    ));
  }

  /// Actualiza las opciones base del cliente
  void _updateBaseOptions() {
    _dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  /// Carga tokens desde SharedPreferences
  Future<void> _loadTokensFromStorage() async {
    if (_prefs == null) return;
    
    _accessToken = _prefs!.getString('access_token');
    _refreshToken = _prefs!.getString('refresh_token');
  }

  /// Guarda tokens en memoria y SharedPreferences
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    
    if (_prefs != null) {
      await _prefs!.setString('access_token', accessToken);
      await _prefs!.setString('refresh_token', refreshToken);
    }
  }

  /// Limpia tokens de memoria y SharedPreferences
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    
    if (_prefs != null) {
      await _prefs!.remove('access_token');
      await _prefs!.remove('refresh_token');
      await _prefs!.remove('user_data');
    }
  }

  /// Intenta refrescar el access token usando refresh token
  Future<bool> _tryRefreshToken() async {
    if (_refreshToken == null) return false;

    try {
      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': _refreshToken},
        options: Options(headers: {'Authorization': null}), // Sin auth header
      );

      if (response.statusCode == 200) {
        final data = response.data;
        await saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'] ?? _refreshToken!,
        );
        return true;
      }
    } catch (e) {
      // Error al refrescar, limpiar tokens
      await clearTokens();
    }

    return false;
  }

  /// Getter para verificar si hay token válido
  bool get hasValidToken => _accessToken != null;

  /// Getter para el access token
  String? get accessToken => _accessToken;

  /// Métodos HTTP convenientes
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  Future<Response> postMultipart(String path, {dynamic data}) {
    return _dio.post(path, data: data, options: Options(contentType: 'multipart/form-data'));
  }

  Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path) {
    return _dio.delete(path);
  }

  Future<Response> patch(String path, {dynamic data}) {
    return _dio.patch(path, data: data);
  }
}