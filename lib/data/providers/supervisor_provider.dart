import 'package:flutter/foundation.dart';
import 'package:audit_cloud_app/data/models/audit_model.dart';
import 'package:audit_cloud_app/services/api_service.dart';

/// Provider que maneja toda la información y estado específico del Supervisor (id_rol=1)
/// Gestiona empresas clientes, solicitudes de pago, auditorías y estado de trabajo del supervisor
class SupervisorProvider extends ChangeNotifier {
  // Lista de empresas clientes
  List<Map<String, dynamic>> _empresasClientes = [];
  List<Map<String, dynamic>> get empresasClientes => _empresasClientes;

  // Lista de solicitudes de pago
  List<Map<String, dynamic>> _solicitudesPago = [];
  List<Map<String, dynamic>> get solicitudesPago => _solicitudesPago;

  // Lista de auditorías de la empresa
  List<AuditModel> _auditorias = [];
  List<AuditModel> get auditorias => _auditorias;

  // Estado de carga
  bool _isLoadingEmpresas = false;
  bool get isLoadingEmpresas => _isLoadingEmpresas;

  bool _isLoadingSolicitudes = false;
  bool get isLoadingSolicitudes => _isLoadingSolicitudes;

  bool _isLoadingAuditorias = false;
  bool get isLoadingAuditorias => _isLoadingAuditorias;

  // Estado de error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ============================================================================
  // ESTADÍSTICAS CALCULADAS
  // ============================================================================

  /// Total de empresas clientes
  int get totalEmpresasClientes => _empresasClientes.length;

  /// Total de solicitudes de pago
  int get totalSolicitudesPago => _solicitudesPago.length;

  /// Solicitudes de pago pendientes (status = "pendiente")
  int get solicitudesPagoPendientes =>
      _solicitudesPago.where((s) => s['status'] == 'pendiente').length;

  /// Total de auditorías
  int get totalAuditorias => _auditorias.length;

  /// Auditorías activas (estado 1=CREADA o 2=EN_PROCESO)
  int get auditoriasActivas =>
      _auditorias.where((a) => a.idEstado == 1 || a.idEstado == 2).length;

  /// Auditorías creadas (estado = 1)
  int get auditoriasCreadas => _auditorias.where((a) => a.idEstado == 1).length;

  /// Auditorías en proceso (estado = 2)
  int get auditoriasEnProceso =>
      _auditorias.where((a) => a.idEstado == 2).length;

  /// Auditorías finalizadas (estado = 3)
  int get auditoriasFinalizadas =>
      _auditorias.where((a) => a.idEstado == 3).length;

  // ============================================================================
  // MÉTODOS PRINCIPALES - EMPRESAS CLIENTES
  // ============================================================================

  /// Carga las empresas clientes que tienen auditorías con la empresa del supervisor
  /// GET /api/supervisor/clientes-con-auditorias
  Future<void> cargarEmpresasClientes() async {
    print('[SupervisorProvider] 🔄 Iniciando carga de empresas clientes...');

    _isLoadingEmpresas = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print(
        '[SupervisorProvider] 📡 Llamando a ApiService.getEmpresasClientes...',
      );
      final empresasData = await ApiService.getEmpresasClientes();
      print(
        '[SupervisorProvider] 📥 Respuesta recibida: ${empresasData != null ? "Datos OK" : "NULL"}',
      );

      if (empresasData != null) {
        _empresasClientes = empresasData;
        print(
          '[SupervisorProvider] ✅ ${_empresasClientes.length} empresas clientes cargadas',
        );
      } else {
        _errorMessage = 'No se pudieron cargar las empresas clientes';
        print('[SupervisorProvider] ❌ Error: respuesta NULL del backend');
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[SupervisorProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[SupervisorProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[SupervisorProvider] ⏹️ Finalizando carga de empresas clientes');
      _isLoadingEmpresas = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // MÉTODOS PRINCIPALES - SOLICITUDES DE PAGO
  // ============================================================================

  /// Carga las solicitudes de pago de la empresa del supervisor
  /// GET /api/supervisor/solicitudes-pago/:idEmpresa
  Future<void> cargarSolicitudesPago(int idEmpresa) async {
    print(
      '[SupervisorProvider] 🔄 Iniciando carga de solicitudes de pago para empresa: $idEmpresa',
    );

    _isLoadingSolicitudes = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print(
        '[SupervisorProvider] 📡 Llamando a ApiService.getSolicitudesPago...',
      );
      final solicitudesData = await ApiService.getSolicitudesPago(idEmpresa);
      print(
        '[SupervisorProvider] 📥 Respuesta recibida: ${solicitudesData != null ? "Datos OK" : "NULL"}',
      );

      if (solicitudesData != null) {
        _solicitudesPago = solicitudesData;
        print(
          '[SupervisorProvider] ✅ ${_solicitudesPago.length} solicitudes de pago cargadas',
        );
        print('[SupervisorProvider] 📊 Pendientes: $solicitudesPagoPendientes');
      } else {
        _errorMessage = 'No se pudieron cargar las solicitudes de pago';
        print('[SupervisorProvider] ❌ Error: respuesta NULL del backend');
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[SupervisorProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[SupervisorProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[SupervisorProvider] ⏹️ Finalizando carga de solicitudes de pago');
      _isLoadingSolicitudes = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // MÉTODOS PRINCIPALES - AUDITORÍAS
  // ============================================================================

  /// Carga las auditorías de la empresa del supervisor
  /// GET /api/supervisor/auditorias/:idEmpresa
  /// Parámetros opcionales:
  /// - idEstado: Filtrar por estado (1=CREADA, 2=EN_PROCESO, 3=FINALIZADA)
  Future<void> cargarAuditorias(int idEmpresa, {int? idEstado}) async {
    print(
      '[SupervisorProvider] 🔄 Iniciando carga de auditorías para empresa: $idEmpresa',
    );

    _isLoadingAuditorias = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print(
        '[SupervisorProvider] 📡 Llamando a ApiService.getAuditoriasSupervisor...',
      );
      final auditoriasData = await ApiService.getAuditoriasSupervisor(
        idEmpresa,
        idEstado: idEstado,
      );
      print(
        '[SupervisorProvider] 📥 Respuesta recibida: ${auditoriasData != null ? "Datos OK" : "NULL"}',
      );

      if (auditoriasData != null) {
        print(
          '[SupervisorProvider] 🔄 Convirtiendo ${auditoriasData.length} registros a AuditModel...',
        );

        _auditorias = auditoriasData.map((json) {
          print(
            '[SupervisorProvider] 📝 Procesando auditoría: ${json['id_auditoria']}',
          );
          try {
            // Transformar el JSON para que coincida con AuditModel
            final transformedJson = {
              'id_auditoria': json['id_auditoria'],
              'id_empresa_auditora': json['id_empresa_auditora'],
              'id_cliente': json['id_cliente'],
              'id_estado': json['id_estado'],
              'monto': json['monto'],
              'fecha_inicio': json['fecha_inicio'],
              'creada_en': json['fecha_creacion'],
              'estado_actualizado_en': null,
              // Datos del cliente
              'cliente': json['empresa_cliente'] != null
                  ? {
                      'nombre': json['cliente']?['nombre'],
                      'nombre_empresa': json['empresa_cliente']['nombre'],
                    }
                  : null,
            };

            return AuditModel.fromJson(transformedJson);
          } catch (e) {
            print(
              '[SupervisorProvider] ❌ Error al parsear auditoría ${json['id_auditoria']}: $e',
            );
            print('[SupervisorProvider] JSON problemático: $json');
            rethrow;
          }
        }).toList();

        print(
          '[SupervisorProvider] ✅ ${_auditorias.length} auditorías cargadas exitosamente',
        );
        print(
          '[SupervisorProvider] 📊 Estadísticas - Activas: $auditoriasActivas, Creadas: $auditoriasCreadas, En proceso: $auditoriasEnProceso, Finalizadas: $auditoriasFinalizadas',
        );
      } else {
        _errorMessage = 'No se pudieron cargar las auditorías';
        print('[SupervisorProvider] ❌ Error: respuesta NULL del backend');
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[SupervisorProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[SupervisorProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[SupervisorProvider] ⏹️ Finalizando carga de auditorías');
      _isLoadingAuditorias = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================

  /// Refresca todas las empresas clientes
  Future<void> refrescarEmpresasClientes() async {
    print('[SupervisorProvider] Refrescando empresas clientes...');
    await cargarEmpresasClientes();
  }

  /// Refresca las solicitudes de pago
  Future<void> refrescarSolicitudesPago(int idEmpresa) async {
    print('[SupervisorProvider] Refrescando solicitudes de pago...');
    await cargarSolicitudesPago(idEmpresa);
  }

  /// Refresca las auditorías
  Future<void> refrescarAuditorias(int idEmpresa, {int? idEstado}) async {
    print('[SupervisorProvider] Refrescando auditorías...');
    await cargarAuditorias(idEmpresa, idEstado: idEstado);
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
    _empresasClientes = [];
    _solicitudesPago = [];
    _auditorias = [];
    _errorMessage = null;
    _isLoadingEmpresas = false;
    _isLoadingSolicitudes = false;
    _isLoadingAuditorias = false;
    notifyListeners();
  }

  // ============================================================================
  // MÉTODOS FUTUROS PARA INTEGRACIÓN COMPLETA
  // ============================================================================

  // TODO: Agregar métodos para:
  // - Crear nuevas auditorías
  // - Asignar auditores a auditorías
  // - Gestionar módulos de auditorías
  // - Aprobar/rechazar solicitudes de pago
  // - Generar reportes globales
  // - Gestionar usuarios internos (auditores)
}
