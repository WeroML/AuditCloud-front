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

  /// Obtiene las evidencias de un auditor
  /// GET /api/auditor/evidencias/:idAuditoria
  /// Si idAuditoria es 0, obtiene todas las evidencias del auditor
  static Future<List<Map<String, dynamic>>?> getEvidencias(
    int idAuditoria,
  ) async {
    try {
      final response = await get(
        '/auditor/evidencias/$idAuditoria',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener evidencias: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getEvidencias: $e');
      return null;
    }
  }

  /// Obtiene el detalle de una auditoría específica
  /// GET /api/auditor/auditorias/:id
  static Future<Map<String, dynamic>?> getAuditoriaDetalle(
    int idAuditoria,
  ) async {
    try {
      final response = await get(
        '/auditor/auditorias/$idAuditoria',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        print(
          '[ApiService] Error al obtener detalle de auditoría: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getAuditoriaDetalle: $e');
      return null;
    }
  }

  // ============================================================================
  // MÉTODOS PARA SUPERVISOR
  // ============================================================================

  /// Obtiene las empresas clientes que tienen auditorías con la empresa del supervisor
  /// GET /api/supervisor/clientes-con-auditorias
  static Future<List<Map<String, dynamic>>?> getEmpresasClientes() async {
    try {
      final response = await get(
        '/supervisor/clientes-con-auditorias',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener empresas clientes: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getEmpresasClientes: $e');
      return null;
    }
  }

  /// Obtiene las solicitudes de pago de una empresa
  /// GET /api/supervisor/solicitudes-pago/:idEmpresa
  static Future<List<Map<String, dynamic>>?> getSolicitudesPago(
    int idEmpresa,
  ) async {
    try {
      final response = await get(
        '/supervisor/solicitudes-pago/$idEmpresa',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        // La respuesta viene con estructura: {total, page, limit, data}
        final data = responseData['data'] as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener solicitudes de pago: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getSolicitudesPago: $e');
      return null;
    }
  }

  /// Obtiene las auditorías de una empresa auditora (para Supervisor)
  /// GET /api/supervisor/auditorias/:idEmpresa
  /// Parámetros opcionales:
  /// - idEstado: Filtrar por estado
  static Future<List<Map<String, dynamic>>?> getAuditoriasSupervisor(
    int idEmpresa, {
    int? idEstado,
  }) async {
    try {
      String endpoint = '/supervisor/auditorias/$idEmpresa';
      if (idEstado != null) {
        endpoint += '?id_estado=$idEstado';
      }

      final response = await get(endpoint, requiresAuth: true);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        // La respuesta viene con estructura: {total, page, limit, data}
        final data = responseData['data'] as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener auditorías del supervisor: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getAuditoriasSupervisor: $e');
      return null;
    }
  }

  /// Obtiene las evidencias de una auditoría específica (para Supervisor)
  /// GET /api/supervisor/auditorias/:idAuditoria/evidencias
  static Future<List<Map<String, dynamic>>?> getEvidenciasSupervisor(
    int idAuditoria,
  ) async {
    try {
      final response = await get(
        '/supervisor/auditorias/$idAuditoria/evidencias',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener evidencias del supervisor: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getEvidenciasSupervisor: $e');
      return null;
    }
  }

  /// Obtiene los auditores (usuarios internos) de una empresa
  /// GET /api/supervisor/auditores/:idEmpresa
  static Future<List<Map<String, dynamic>>?> getAuditoresEmpresa(
    int idEmpresa,
  ) async {
    try {
      final response = await get(
        '/supervisor/auditores/$idEmpresa',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        // La respuesta viene con estructura: {total, page, limit, data}
        final data = responseData['data'] as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener auditores: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getAuditoresEmpresa: $e');
      return null;
    }
  }

  // ============================================================================
  // MÉTODOS PARA CLIENTE
  // ============================================================================

  /// Obtiene las auditorías de un cliente
  /// GET /api/cliente/auditorias/:idCliente
  static Future<List<Map<String, dynamic>>?> getAuditoriasCliente(
    int idCliente,
  ) async {
    try {
      final response = await get(
        '/cliente/auditorias/$idCliente',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        // La respuesta viene con estructura: {total, page, limit, data}
        final data = responseData['data'] as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener auditorías del cliente: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getAuditoriasCliente: $e');
      return null;
    }
  }

  /// Obtiene las solicitudes de pago de un cliente
  /// GET /api/cliente/solicitudes-pago/:idCliente
  static Future<List<Map<String, dynamic>>?> getSolicitudesPagoCliente(
    int idCliente,
  ) async {
    try {
      final response = await get(
        '/cliente/solicitudes-pago/$idCliente',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener solicitudes de pago del cliente: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getSolicitudesPagoCliente: $e');
      return null;
    }
  }

  /// Obtiene las empresas auditoras disponibles (para Cliente)
  /// GET /api/cliente/empresas-auditoras
  static Future<List<Map<String, dynamic>>?> getEmpresasAuditoras() async {
    try {
      final response = await get(
        '/cliente/empresas-auditoras',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        return data.cast<Map<String, dynamic>>();
      } else {
        print(
          '[ApiService] Error al obtener empresas auditoras: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getEmpresasAuditoras: $e');
      return null;
    }
  }

  /// Obtiene el detalle de una empresa auditora específica (para Cliente)
  /// GET /api/cliente/empresas-auditoras/:id
  static Future<Map<String, dynamic>?> getDetalleEmpresaAuditora(
    int idEmpresa,
  ) async {
    try {
      final response = await get(
        '/cliente/empresas-auditoras/$idEmpresa',
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        print(
          '[ApiService] Error al obtener detalle de empresa: ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      print('[ApiService] ❌ Error en getDetalleEmpresaAuditora: $e');
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
