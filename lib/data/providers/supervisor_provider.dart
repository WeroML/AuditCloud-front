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

  // Lista de evidencias de todas las auditorías
  List<Map<String, dynamic>> _evidencias = [];
  List<Map<String, dynamic>> get evidencias => _evidencias;

  // Lista de usuarios internos (auditores)
  List<Map<String, dynamic>> _usuariosInternos = [];
  List<Map<String, dynamic>> get usuariosInternos => _usuariosInternos;

  // Lista de reportes finales
  List<Map<String, dynamic>> _reportes = [];
  List<Map<String, dynamic>> get reportes => _reportes;

  // Estado de carga
  bool _isLoadingEmpresas = false;
  bool get isLoadingEmpresas => _isLoadingEmpresas;

  bool _isLoadingSolicitudes = false;
  bool get isLoadingSolicitudes => _isLoadingSolicitudes;

  bool _isLoadingAuditorias = false;
  bool get isLoadingAuditorias => _isLoadingAuditorias;

  bool _isLoadingEvidencias = false;
  bool get isLoadingEvidencias => _isLoadingEvidencias;

  bool _isLoadingUsuarios = false;
  bool get isLoadingUsuarios => _isLoadingUsuarios;

  bool _isLoadingReportes = false;
  bool get isLoadingReportes => _isLoadingReportes;

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

  /// Total de evidencias
  int get totalEvidencias => _evidencias.length;

  /// Evidencias de tipo FOTO
  int get evidenciasFoto =>
      _evidencias.where((e) => e['tipo'] == 'FOTO').length;

  /// Evidencias de tipo VIDEO
  int get evidenciasVideo =>
      _evidencias.where((e) => e['tipo'] == 'VIDEO').length;

  /// Evidencias de tipo DOC
  int get evidenciasDoc => _evidencias.where((e) => e['tipo'] == 'DOC').length;

  /// Total de usuarios internos
  int get totalUsuariosInternos => _usuariosInternos.length;

  /// Usuarios activos (activo = true)
  int get usuariosActivos =>
      _usuariosInternos.where((u) => u['activo'] == true).length;

  /// Total de reportes
  int get totalReportes => _reportes.length;

  /// Reportes de tipo FINAL
  int get reportesFinales =>
      _reportes.where((r) => r['tipo'] == 'FINAL').length;

  /// Reportes con archivo adjunto
  int get reportesConArchivo =>
      _reportes.where((r) => r['url'] != null && r['url'] != '').length;

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
  // MÉTODOS PRINCIPALES - EVIDENCIAS
  // ============================================================================

  /// Carga las evidencias de todas las auditorías del supervisor
  /// GET /api/supervisor/auditorias/:idAuditoria/evidencias (para cada auditoría)
  Future<void> cargarEvidencias() async {
    print('[SupervisorProvider] 🔄 Iniciando carga de evidencias...');

    _isLoadingEvidencias = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Recopilar evidencias de todas las auditorías
      List<Map<String, dynamic>> todasLasEvidencias = [];

      for (final auditoria in _auditorias) {
        final idAuditoria = auditoria.idAuditoria;
        if (idAuditoria == null) continue;

        print(
          '[SupervisorProvider] 📡 Cargando evidencias de auditoría $idAuditoria...',
        );
        final evidenciasData = await ApiService.getEvidenciasSupervisor(
          idAuditoria,
        );

        if (evidenciasData != null) {
          todasLasEvidencias.addAll(evidenciasData);
        }
      }

      _evidencias = todasLasEvidencias;
      print('[SupervisorProvider] ✅ ${_evidencias.length} evidencias cargadas');
      print(
        '[SupervisorProvider] 📊 Fotos: $evidenciasFoto, Videos: $evidenciasVideo, Docs: $evidenciasDoc',
      );
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[SupervisorProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[SupervisorProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[SupervisorProvider] ⏹️ Finalizando carga de evidencias');
      _isLoadingEvidencias = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // MÉTODOS PRINCIPALES - USUARIOS INTERNOS
  // ============================================================================

  /// Carga los usuarios internos (auditores) de la empresa del supervisor
  /// GET /api/supervisor/auditores/:idEmpresa
  Future<void> cargarUsuariosInternos(int idEmpresa) async {
    print(
      '[SupervisorProvider] 🔄 Iniciando carga de usuarios internos para empresa: $idEmpresa',
    );

    _isLoadingUsuarios = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print(
        '[SupervisorProvider] 📡 Llamando a ApiService.getAuditoresEmpresa...',
      );
      final usuariosData = await ApiService.getAuditoresEmpresa(idEmpresa);
      print(
        '[SupervisorProvider] 📥 Respuesta recibida: ${usuariosData != null ? "Datos OK" : "NULL"}',
      );

      if (usuariosData != null) {
        _usuariosInternos = usuariosData;
        print(
          '[SupervisorProvider] ✅ ${_usuariosInternos.length} usuarios internos cargados',
        );
        print(
          '[SupervisorProvider] 📊 Activos: $usuariosActivos / Total: $totalUsuariosInternos',
        );
      } else {
        _errorMessage = 'No se pudieron cargar los usuarios internos';
        print('[SupervisorProvider] ❌ Error: respuesta NULL del backend');
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[SupervisorProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[SupervisorProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[SupervisorProvider] ⏹️ Finalizando carga de usuarios internos');
      _isLoadingUsuarios = false;
      notifyListeners();
    }
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================

  /// Refresca todas las empresas clientes
  Future<void> refrescarEmpresasClientes() async {
    if (_isLoadingEmpresas) {
      print('[SupervisorProvider] ⚠️ Ya hay una carga de empresas en progreso');
      return;
    }
    print('[SupervisorProvider] Refrescando empresas clientes...');
    await cargarEmpresasClientes();
  }

  /// Refresca las solicitudes de pago
  Future<void> refrescarSolicitudesPago(int idEmpresa) async {
    if (_isLoadingSolicitudes) {
      print(
        '[SupervisorProvider] ⚠️ Ya hay una carga de solicitudes en progreso',
      );
      return;
    }
    print('[SupervisorProvider] Refrescando solicitudes de pago...');
    await cargarSolicitudesPago(idEmpresa);
  }

  /// Refresca las auditorías
  Future<void> refrescarAuditorias(int idEmpresa, {int? idEstado}) async {
    if (_isLoadingAuditorias) {
      print(
        '[SupervisorProvider] ⚠️ Ya hay una carga de auditorías en progreso',
      );
      return;
    }
    print('[SupervisorProvider] Refrescando auditorías...');
    await cargarAuditorias(idEmpresa, idEstado: idEstado);
  }

  /// Refresca las evidencias
  Future<void> refrescarEvidencias() async {
    if (_isLoadingEvidencias) {
      print(
        '[SupervisorProvider] ⚠️ Ya hay una carga de evidencias en progreso',
      );
      return;
    }
    print('[SupervisorProvider] Refrescando evidencias...');
    await cargarEvidencias();
  }

  /// Refresca los usuarios internos
  Future<void> refrescarUsuariosInternos(int idEmpresa) async {
    if (_isLoadingUsuarios) {
      print('[SupervisorProvider] ⚠️ Ya hay una carga de usuarios en progreso');
      return;
    }
    print('[SupervisorProvider] Refrescando usuarios internos...');
    await cargarUsuariosInternos(idEmpresa);
  }

  // ============================================================================
  // MÉTODOS PRINCIPALES - REPORTES
  // ============================================================================

  /// Carga los reportes finales de todas las auditorías del supervisor
  /// GET /api/supervisor/auditorias/:id/reporte-final (para cada auditoría)
  Future<void> cargarReportes() async {
    print('[SupervisorProvider] 🔄 Iniciando carga de reportes finales...');

    _isLoadingReportes = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Recopilar reportes de todas las auditorías
      List<Map<String, dynamic>> todosLosReportes = [];

      for (final auditoria in _auditorias) {
        final idAuditoria = auditoria.idAuditoria;
        if (idAuditoria == null) continue;

        print(
          '[SupervisorProvider] 📡 Cargando reporte de auditoría $idAuditoria...',
        );
        final reporteData = await ApiService.getReporteFinal(idAuditoria);

        if (reporteData != null) {
          todosLosReportes.add(reporteData);
        } else {
          print(
            '[SupervisorProvider] ⚠️ No hay reporte final para auditoría $idAuditoria',
          );
        }
      }

      _reportes = todosLosReportes;
      print('[SupervisorProvider] ✅ ${_reportes.length} reportes cargados');
      print(
        '[SupervisorProvider] 📊 Finales: $reportesFinales, Con Archivo: $reportesConArchivo',
      );
      print("[SupervisorProvider] 📊 Info de los reportes: $_reportes");
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[SupervisorProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[SupervisorProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[SupervisorProvider] ⏹️ Finalizando carga de reportes');
      _isLoadingReportes = false;
      notifyListeners();
    }
  }

  /// Refresca los reportes
  Future<void> refrescarReportes() async {
    if (_isLoadingReportes) {
      print('[SupervisorProvider] ⚠️ Ya hay una carga de reportes en progreso');
      return;
    }
    print('[SupervisorProvider] Refrescando reportes...');
    await cargarReportes();
  }

  /// Obtiene reportes ordenados por fecha de creación (más recientes primero)
  List<Map<String, dynamic>> getReportesOrdenados() {
    final lista = List<Map<String, dynamic>>.from(_reportes);
    lista.sort((a, b) {
      final fechaA = a['fecha_creacion'] as String?;
      final fechaB = b['fecha_creacion'] as String?;

      if (fechaA == null && fechaB == null) return 0;
      if (fechaA == null) return 1;
      if (fechaB == null) return -1;

      try {
        final dateA = DateTime.parse(fechaA);
        final dateB = DateTime.parse(fechaB);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });
    return lista;
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================

  /// Obtiene usuarios ordenados por nombre
  List<Map<String, dynamic>> getUsuariosOrdenados() {
    final lista = List<Map<String, dynamic>>.from(_usuariosInternos);
    lista.sort((a, b) {
      final nombreA = a['nombre'] as String? ?? '';
      final nombreB = b['nombre'] as String? ?? '';
      return nombreA.compareTo(nombreB);
    });
    return lista;
  }

  /// Obtiene evidencias ordenadas por fecha de creación (más recientes primero)
  List<Map<String, dynamic>> getEvidenciasOrdenadas() {
    final lista = List<Map<String, dynamic>>.from(_evidencias);
    lista.sort((a, b) {
      final fechaA = a['creado_en'] as String?;
      final fechaB = b['creado_en'] as String?;

      if (fechaA == null && fechaB == null) return 0;
      if (fechaA == null) return 1;
      if (fechaB == null) return -1;

      try {
        final dateA = DateTime.parse(fechaA);
        final dateB = DateTime.parse(fechaB);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
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
    _empresasClientes = [];
    _solicitudesPago = [];
    _auditorias = [];
    _evidencias = [];
    _usuariosInternos = [];
    _reportes = [];
    _errorMessage = null;
    _isLoadingEmpresas = false;
    _isLoadingSolicitudes = false;
    _isLoadingAuditorias = false;
    _isLoadingEvidencias = false;
    _isLoadingUsuarios = false;
    _isLoadingReportes = false;
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
