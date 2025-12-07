import 'package:flutter/foundation.dart';
import 'package:audit_cloud_app/data/models/audit_model.dart';
import 'package:audit_cloud_app/services/api_service.dart';

/// Provider que maneja toda la información y estado específico del Cliente (id_rol=3)
/// Gestiona auditorías asignadas, solicitudes de pago y estado de trabajo del cliente
class ClienteProvider extends ChangeNotifier {
  // Lista de auditorías del cliente
  List<AuditModel> _auditorias = [];
  List<AuditModel> get auditorias => _auditorias;

  // Lista de solicitudes de pago del cliente
  List<Map<String, dynamic>> _solicitudesPago = [];
  List<Map<String, dynamic>> get solicitudesPago => _solicitudesPago;

  // Lista de empresas auditoras disponibles
  List<Map<String, dynamic>> _empresasAuditoras = [];
  List<Map<String, dynamic>> get empresasAuditoras => _empresasAuditoras;

  // Estado de carga
  bool _isLoadingAuditorias = false;
  bool get isLoadingAuditorias => _isLoadingAuditorias;

  bool _isLoadingSolicitudes = false;
  bool get isLoadingSolicitudes => _isLoadingSolicitudes;

  bool _isLoadingEmpresas = false;
  bool get isLoadingEmpresas => _isLoadingEmpresas;

  // Estado de error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ============================================================================
  // ESTADÍSTICAS CALCULADAS
  // ============================================================================

  /// Total de auditorías del cliente
  int get totalAuditorias => _auditorias.length;

  /// Auditorías creadas (estado = 1)
  int get auditoriasCreadas => _auditorias.where((a) => a.idEstado == 1).length;

  /// Auditorías en proceso (estado = 2)
  int get auditoriasEnProceso =>
      _auditorias.where((a) => a.idEstado == 2).length;

  /// Auditorías finalizadas (estado = 3)
  int get auditoriasFinalizadas =>
      _auditorias.where((a) => a.idEstado == 3).length;

  /// Auditorías activas (estado 1=CREADA o 2=EN_PROCESO)
  int get auditoriasActivas =>
      _auditorias.where((a) => a.idEstado == 1 || a.idEstado == 2).length;

  /// Total de solicitudes de pago
  int get totalSolicitudesPago => _solicitudesPago.length;

  /// Solicitudes de pago pendientes (id_estado = 1)
  int get solicitudesPagoPendientes =>
      _solicitudesPago.where((s) => s['id_estado'] == 1).length;

  /// Solicitudes de pago pagadas (id_estado = 2)
  int get solicitudesPagoPagadas =>
      _solicitudesPago.where((s) => s['id_estado'] == 2).length;

  /// Solicitudes de pago rechazadas (id_estado = 3)
  int get solicitudesPagoRechazadas =>
      _solicitudesPago.where((s) => s['id_estado'] == 3).length;

  /// Total de empresas auditoras disponibles
  int get totalEmpresasAuditoras => _empresasAuditoras.length;

  // ============================================================================
  // MÉTODOS PRINCIPALES - AUDITORÍAS
  // ============================================================================

  /// Carga las auditorías del cliente
  /// GET /api/cliente/auditorias/:idCliente
  Future<void> cargarAuditorias(int idCliente) async {
    print(
      '[ClienteProvider] 🔄 Iniciando carga de auditorías para cliente: $idCliente',
    );

    _isLoadingAuditorias = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print(
        '[ClienteProvider] 📡 Llamando a ApiService.getAuditoriasCliente...',
      );
      final auditoriasData = await ApiService.getAuditoriasCliente(idCliente);
      print(
        '[ClienteProvider] 📥 Respuesta recibida: ${auditoriasData != null ? "Datos OK" : "NULL"}',
      );

      if (auditoriasData != null) {
        print(
          '[ClienteProvider] 🔄 Convirtiendo ${auditoriasData.length} registros a AuditModel...',
        );

        // Primero, obtener los IDs únicos de empresas auditoras
        final empresasIds = auditoriasData
            .map((a) => a['id_empresa_auditora'] as int)
            .toSet()
            .toList();

        print('[ClienteProvider] 📋 Empresas auditoras únicas: $empresasIds');

        // Cargar nombres de empresas auditoras
        final Map<int, String> empresasNombres = {};
        for (final idEmpresa in empresasIds) {
          try {
            final detalle = await ApiService.getDetalleEmpresaAuditora(
              idEmpresa,
            );
            if (detalle != null && detalle['nombre'] != null) {
              empresasNombres[idEmpresa] = detalle['nombre'] as String;
              print(
                '[ClienteProvider] ✅ Empresa $idEmpresa: ${detalle['nombre']}',
              );
            }
          } catch (e) {
            print(
              '[ClienteProvider] ⚠️ No se pudo obtener nombre de empresa $idEmpresa: $e',
            );
          }
        }

        _auditorias = auditoriasData.map((json) {
          print(
            '[ClienteProvider] 📝 Procesando auditoría: ${json['id_auditoria']}',
          );
          print('[ClienteProvider] 📊 Datos: $json');
          try {
            final auditoria = AuditModel.fromJson(json);

            // Enriquecer con nombre de empresa auditora
            final nombreEmpresa = empresasNombres[auditoria.idEmpresaAuditora];
            if (nombreEmpresa != null) {
              return auditoria.copyWith(empresaAuditoraNombre: nombreEmpresa);
            }

            return auditoria;
          } catch (e) {
            print(
              '[ClienteProvider] ❌ Error al parsear auditoría ${json['id_auditoria']}: $e',
            );
            print('[ClienteProvider] JSON problemático: $json');
            rethrow;
          }
        }).toList();

        print(
          '[ClienteProvider] ✅ ${_auditorias.length} auditorías cargadas exitosamente',
        );
        print(
          '[ClienteProvider] 📊 Estadísticas - Activas: $auditoriasActivas, Creadas: $auditoriasCreadas, En proceso: $auditoriasEnProceso, Finalizadas: $auditoriasFinalizadas',
        );
      } else {
        _errorMessage = 'No se pudieron cargar las auditorías';
        print('[ClienteProvider] ❌ Error: respuesta NULL del backend');
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[ClienteProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[ClienteProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[ClienteProvider] ⏹️ Finalizando carga de auditorías');
      _isLoadingAuditorias = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // MÉTODOS PRINCIPALES - SOLICITUDES DE PAGO
  // ============================================================================

  /// Carga las solicitudes de pago del cliente
  /// GET /api/cliente/solicitudes-pago/:idCliente
  Future<void> cargarSolicitudesPago(int idCliente) async {
    print(
      '[ClienteProvider] 🔄 Iniciando carga de solicitudes de pago para cliente: $idCliente',
    );

    _isLoadingSolicitudes = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print(
        '[ClienteProvider] 📡 Llamando a ApiService.getSolicitudesPagoCliente...',
      );
      final solicitudesData = await ApiService.getSolicitudesPagoCliente(
        idCliente,
      );
      print(
        '[ClienteProvider] 📥 Respuesta recibida: ${solicitudesData != null ? "Datos OK" : "NULL"}',
      );

      if (solicitudesData != null) {
        _solicitudesPago = solicitudesData;
        print(
          '[ClienteProvider] ✅ ${_solicitudesPago.length} solicitudes de pago cargadas',
        );
        print(
          '[ClienteProvider] 📊 Pendientes: $solicitudesPagoPendientes, Pagadas: $solicitudesPagoPagadas, Rechazadas: $solicitudesPagoRechazadas',
        );
      } else {
        _errorMessage = 'No se pudieron cargar las solicitudes de pago';
        print('[ClienteProvider] ❌ Error: respuesta NULL del backend');
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[ClienteProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[ClienteProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[ClienteProvider] ⏹️ Finalizando carga de solicitudes de pago');
      _isLoadingSolicitudes = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // MÉTODOS PRINCIPALES - EMPRESAS AUDITORAS
  // ============================================================================

  /// Carga las empresas auditoras disponibles
  /// GET /api/cliente/empresas-auditoras
  Future<void> cargarEmpresasAuditoras() async {
    print('[ClienteProvider] 🔄 Iniciando carga de empresas auditoras...');

    _isLoadingEmpresas = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print(
        '[ClienteProvider] 📡 Llamando a ApiService.getEmpresasAuditoras...',
      );
      final empresasData = await ApiService.getEmpresasAuditoras();
      print(
        '[ClienteProvider] 📥 Respuesta recibida: ${empresasData != null ? "Datos OK" : "NULL"}',
      );

      if (empresasData != null) {
        // Cargar detalles de cada empresa para obtener módulos completos
        print(
          '[ClienteProvider] 🔄 Cargando detalles de ${empresasData.length} empresas...',
        );
        _empresasAuditoras = [];

        for (var empresa in empresasData) {
          final idEmpresa = empresa['id_empresa'] as int;
          print(
            '[ClienteProvider] 📡 Obteniendo detalle de empresa $idEmpresa...',
          );

          final detalle = await ApiService.getDetalleEmpresaAuditora(idEmpresa);
          if (detalle != null) {
            _empresasAuditoras.add(detalle);
          } else {
            // Si falla el detalle, usar la info básica sin módulos_detalle
            _empresasAuditoras.add(empresa);
          }
        }

        print(
          '[ClienteProvider] ✅ ${_empresasAuditoras.length} empresas auditoras cargadas',
        );
      } else {
        _errorMessage = 'No se pudieron cargar las empresas auditoras';
        print('[ClienteProvider] ❌ Error: respuesta NULL del backend');
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[ClienteProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[ClienteProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[ClienteProvider] ⏹️ Finalizando carga de empresas auditoras');
      _isLoadingEmpresas = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================

  /// Refresca las auditorías
  Future<void> refrescarAuditorias(int idCliente) async {
    print('[ClienteProvider] Refrescando auditorías...');
    await cargarAuditorias(idCliente);
  }

  /// Refresca las solicitudes de pago
  Future<void> refrescarSolicitudesPago(int idCliente) async {
    print('[ClienteProvider] Refrescando solicitudes de pago...');
    await cargarSolicitudesPago(idCliente);
  }

  /// Refresca las empresas auditoras
  Future<void> refrescarEmpresasAuditoras() async {
    print('[ClienteProvider] Refrescando empresas auditoras...');
    await cargarEmpresasAuditoras();
  }

  /// Obtiene empresas auditoras ordenadas alfabéticamente
  List<Map<String, dynamic>> getEmpresasAuditorasOrdenadas() {
    final lista = List<Map<String, dynamic>>.from(_empresasAuditoras);
    lista.sort((a, b) {
      final nombreA = a['nombre'] as String? ?? '';
      final nombreB = b['nombre'] as String? ?? '';
      return nombreA.compareTo(nombreB);
    });
    return lista;
  }

  /// Obtiene auditorías ordenadas por fecha de creación (más recientes primero)
  List<AuditModel> getAuditoriasOrdenadas() {
    final lista = List<AuditModel>.from(_auditorias);
    lista.sort((a, b) {
      final fechaA = a.fechaInicio ?? a.creadaEn;
      final fechaB = b.fechaInicio ?? b.creadaEn;

      if (fechaA == null && fechaB == null) return 0;
      if (fechaA == null) return 1;
      if (fechaB == null) return -1;
      return fechaB.compareTo(fechaA);
    });
    return lista;
  }

  /// Filtra auditorías por estado
  List<AuditModel> getAuditoriasPorEstado(int idEstado) {
    return _auditorias.where((a) => a.idEstado == idEstado).toList();
  }

  /// Obtiene el nombre del estado
  String getNombreEstado(int idEstado) {
    switch (idEstado) {
      case 1:
        return 'Creada';
      case 2:
        return 'En Progreso';
      case 3:
        return 'Finalizada';
      default:
        return 'Desconocido';
    }
  }

  /// Limpia todos los datos del provider
  void clear() {
    _auditorias = [];
    _solicitudesPago = [];
    _empresasAuditoras = [];
    _errorMessage = null;
    _isLoadingAuditorias = false;
    _isLoadingSolicitudes = false;
    _isLoadingEmpresas = false;
    notifyListeners();
  }
}
