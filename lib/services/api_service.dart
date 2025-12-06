import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio centralizado para manejar todas las peticiones HTTP al backend
class ApiService {
  // IMPORTANTE: En dispositivos Android/iOS no usar 'localhost'
  // Opciones según dónde estés corriendo la app:
  // - Android Emulator: 'http://10.0.2.2:3000/api'
  // - iOS Simulator: 'http://localhost:3000/api' o 'http://127.0.0.1:3000/api'
  // - Dispositivo físico: 'http://<TU_IP_LOCAL>:3000/api' (ejemplo: 'http://192.168.1.100:3000/api')
  // TODO: Cambiar esta URL por la URL real del backend cuando esté desplegado
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Headers base para todas las peticiones
  static Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json',
  };

  /// Obtiene el token JWT almacenado localmente
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Guarda el token JWT localmente
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    print('[ApiService] Token guardado correctamente');
  }

  /// Elimina el token JWT almacenado
  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    print('[ApiService] Token eliminado');
  }

  /// Headers con autenticación (incluye el token JWT)
  static Future<Map<String, String>> get _authHeaders async {
    final token = await getToken();
    return {
      ..._baseHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ============================================================================
  // MÉTODOS HTTP GENÉRICOS
  // ============================================================================

  /// POST request
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = false,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = requiresAuth ? await _authHeaders : _baseHeaders;

    print('[ApiService] POST $url');
    print('[ApiService] Body: $body');

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('[ApiService] Response status: ${response.statusCode}');
      print('[ApiService] Response body: ${response.body}');

      return response;
    } catch (e) {
      print('[ApiService] ❌ Error en POST $endpoint: $e');
      rethrow;
    }
  }

  /// GET request
  static Future<http.Response> get(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = requiresAuth ? await _authHeaders : _baseHeaders;

    print('[ApiService] GET $url');

    try {
      final response = await http.get(url, headers: headers);

      print('[ApiService] Response status: ${response.statusCode}');
      print('[ApiService] Response body: ${response.body}');

      return response;
    } catch (e) {
      print('[ApiService] ❌ Error en GET $endpoint: $e');
      rethrow;
    }
  }

  /// PUT request
  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = requiresAuth ? await _authHeaders : _baseHeaders;

    print('[ApiService] PUT $url');
    print('[ApiService] Body: $body');

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print('[ApiService] Response status: ${response.statusCode}');
      print('[ApiService] Response body: ${response.body}');

      return response;
    } catch (e) {
      print('[ApiService] ❌ Error en PUT $endpoint: $e');
      rethrow;
    }
  }

  /// DELETE request
  static Future<http.Response> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = requiresAuth ? await _authHeaders : _baseHeaders;

    print('[ApiService] DELETE $url');

    try {
      final response = await http.delete(url, headers: headers);

      print('[ApiService] Response status: ${response.statusCode}');
      print('[ApiService] Response body: ${response.body}');

      return response;
    } catch (e) {
      print('[ApiService] ❌ Error en DELETE $endpoint: $e');
      rethrow;
    }
  }

  // ============================================================================
  // MÉTODOS ESPECÍFICOS DE AUTENTICACIÓN
  // ============================================================================

  /// Login tradicional con correo y contraseña
  /// POST /api/auth/login
  static Future<Map<String, dynamic>?> login(
    String correo,
    String password,
  ) async {
    try {
      final response = await post('/auth/login', {
        'correo': correo,
        'password': password,
      }, requiresAuth: false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        // Guardar el token JWT
        if (data['token'] != null) {
          await saveToken(data['token'] as String);
        }

        return data;
      } else {
        print('[ApiService] Login falló: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en login: $e');
      return null;
    }
  }

  /// Logout (elimina el token local)
  static Future<void> logout() async {
    await deleteToken();
  }

  // ============================================================================
  // MÉTODOS PARA AUDITOR
  // ============================================================================

  /// Obtiene las auditorías asignadas a un auditor
  /// GET /api/auditor/auditorias-asignadas/:idAuditor
  static Future<List<Map<String, dynamic>>?> getAuditoriasAsignadas(
    int idAuditor,
  ) async {
    try {
      final response = await get(
        '/auditor/auditorias-asignadas/$idAuditor',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener auditorías asignadas: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getAuditoriasAsignadas: $e');
      return null;
    }
  }

  // ============================================================================
  // MÉTODOS FUTUROS PARA OTRAS ENTIDADES
  // ============================================================================

  // TODO: Agregar métodos para:
  // - Obtener empresas
  // - Crear/actualizar auditorías
  // - Gestionar conversaciones y mensajes
  // - Subir evidencias
  // - Generar reportes
  // etc.
}
