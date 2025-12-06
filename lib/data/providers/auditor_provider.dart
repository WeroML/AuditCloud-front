import 'package:flutter/foundation.dart';
import 'package:audit_cloud_app/data/models/audit_model.dart';
import 'package:audit_cloud_app/services/api_service.dart';

/// Provider que maneja toda la información y estado específico del Auditor (id_rol=2)
/// Gestiona las auditorías asignadas, estadísticas y estado de trabajo del auditor
class AuditorProvider extends ChangeNotifier {
  // Lista de auditorías asignadas al auditor
  List<AuditModel> _auditoriasAsignadas = [];
  List<AuditModel> get auditoriasAsignadas => _auditoriasAsignadas;

  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Estado de error
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ============================================================================
  // ESTADÍSTICAS CALCULADAS
  // ============================================================================

  /// Total de auditorías asignadas
  int get totalAuditorias => _auditoriasAsignadas.length;

  /// Auditorías creadas (estado = 1)
  int get auditoriasCreadas =>
      _auditoriasAsignadas.where((a) => a.idEstado == 1).length;

  /// Auditorías en proceso (estado = 2)
  int get auditoriasEnProceso =>
      _auditoriasAsignadas.where((a) => a.idEstado == 2).length;

  /// Auditorías finalizadas (estado = 3)
  int get auditoriasFinalizadas =>
      _auditoriasAsignadas.where((a) => a.idEstado == 3).length;

  /// Porcentaje de auditorías finalizadas
  double get porcentajeFinalizadas {
    if (totalAuditorias == 0) return 0.0;
    return (auditoriasFinalizadas / totalAuditorias) * 100;
  }

  /// Auditorías activas (creadas + en proceso)
  int get auditoriasActivas => auditoriasCreadas + auditoriasEnProceso;

  // ============================================================================
  // MÉTODOS PRINCIPALES
  // ============================================================================

  /// Carga las auditorías asignadas al auditor desde el backend
  Future<void> cargarAuditoriasAsignadas(int idAuditor) async {
    print(
      '[AuditorProvider] Cargando auditorías asignadas para auditor: $idAuditor',
    );

    _setLoading(true);
    _errorMessage = null;

    try {
      final auditoriasData = await ApiService.getAuditoriasAsignadas(idAuditor);

      if (auditoriasData != null) {
        _auditoriasAsignadas = auditoriasData
            .map((json) => AuditModel.fromJson(json))
            .toList();

        print(
          '[AuditorProvider] ✅ ${_auditoriasAsignadas.length} auditorías cargadas',
        );
        print(
          '[AuditorProvider] Creadas: $auditoriasCreadas, En proceso: $auditoriasEnProceso, Finalizadas: $auditoriasFinalizadas',
        );
      } else {
        _errorMessage = 'No se pudieron cargar las auditorías';
        print('[AuditorProvider] ❌ Error al cargar auditorías');
      }
    } catch (error) {
      _errorMessage = 'Error de conexión: $error';
      print('[AuditorProvider] ❌ Error: $error');
    } finally {
      _setLoading(false);
    }
  }

  /// Refresca las auditorías asignadas
  Future<void> refrescarAuditorias(int idAuditor) async {
    print('[AuditorProvider] Refrescando auditorías...');
    await cargarAuditoriasAsignadas(idAuditor);
  }

  /// Obtiene una auditoría específica por ID
  AuditModel? getAuditoriaById(int idAuditoria) {
    try {
      return _auditoriasAsignadas.firstWhere(
        (a) => a.idAuditoria == idAuditoria,
      );
    } catch (e) {
      return null;
    }
  }

  /// Filtra auditorías por estado
  List<AuditModel> getAuditoriasPorEstado(int idEstado) {
    return _auditoriasAsignadas.where((a) => a.idEstado == idEstado).toList();
  }

  /// Ordena auditorías por fecha de inicio (más recientes primero)
  List<AuditModel> getAuditoriasOrdenadas() {
    final lista = List<AuditModel>.from(_auditoriasAsignadas);
    lista.sort((a, b) {
      if (a.fechaInicio == null && b.fechaInicio == null) return 0;
      if (a.fechaInicio == null) return 1;
      if (b.fechaInicio == null) return -1;
      return b.fechaInicio!.compareTo(a.fechaInicio!);
    });
    return lista;
  }

  /// Obtiene el nombre del estado según el ID
  String getNombreEstado(int idEstado) {
    switch (idEstado) {
      case 1:
        return 'Creada';
      case 2:
        return 'En Proceso';
      case 3:
        return 'Finalizada';
      default:
        return 'Desconocido';
    }
  }

  /// Obtiene la clave del estado según el ID
  String getClaveEstado(int idEstado) {
    switch (idEstado) {
      case 1:
        return 'CREADA';
      case 2:
        return 'EN_PROCESO';
      case 3:
        return 'FINALIZADA';
      default:
        return 'DESCONOCIDO';
    }
  }

  // ============================================================================
  // MÉTODOS AUXILIARES
  // ============================================================================

  /// Actualiza el estado de carga y notifica a los listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Limpia todos los datos del provider
  void clear() {
    _auditoriasAsignadas = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  // ============================================================================
  // MÉTODOS FUTUROS PARA INTEGRACIÓN COMPLETA
  // ============================================================================

  // TODO: Agregar métodos para:
  // - Actualizar estado de una auditoría
  // - Subir evidencias de una auditoría
  // - Obtener evidencias de una auditoría
  // - Generar reporte de una auditoría
  // - Obtener módulos asignados a cada auditoría
}
