import 'package:flutter/foundation.dart';
import 'package:audit_cloud_app/data/models/audit_model.dart';
import 'package:audit_cloud_app/data/models/evidence_model.dart';
import 'package:audit_cloud_app/services/api_service.dart';

/// Provider que maneja toda la información y estado específico del Auditor (id_rol=2)
/// Gestiona las auditorías asignadas, estadísticas y estado de trabajo del auditor
class AuditorProvider extends ChangeNotifier {
  // Lista de auditorías asignadas al auditor
  List<AuditModel> _auditoriasAsignadas = [];
  List<AuditModel> get auditoriasAsignadas => _auditoriasAsignadas;

  // Lista de evidencias del auditor
  List<EvidenceModel> _evidencias = [];
  List<EvidenceModel> get evidencias => _evidencias;

  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Estado de carga de evidencias
  bool _isLoadingEvidencias = false;
  bool get isLoadingEvidencias => _isLoadingEvidencias;

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
  // ESTADÍSTICAS DE EVIDENCIAS
  // ============================================================================

  /// Total de evidencias
  int get totalEvidencias => _evidencias.length;

  /// Evidencias por tipo (mapa con conteo)
  Map<String, int> get evidenciasPorTipo {
    final Map<String, int> conteo = {'FOTO': 0, 'VIDEO': 0, 'DOC': 0};

    for (final evidencia in _evidencias) {
      final tipo = evidencia.tipo.toUpperCase();
      if (conteo.containsKey(tipo)) {
        conteo[tipo] = conteo[tipo]! + 1;
      }
    }

    return conteo;
  }

  /// Evidencias tipo FOTO
  int get evidenciasFoto =>
      _evidencias.where((e) => e.tipo.toUpperCase() == 'FOTO').length;

  /// Evidencias tipo VIDEO
  int get evidenciasVideo =>
      _evidencias.where((e) => e.tipo.toUpperCase() == 'VIDEO').length;

  /// Evidencias tipo DOC (documentos)
  int get evidenciasDocumento =>
      _evidencias.where((e) => e.tipo.toUpperCase() == 'DOC').length;

  // ============================================================================
  // MÉTODOS PRINCIPALES
  // ============================================================================

  /// Carga las auditorías asignadas al auditor desde el backend
  Future<void> cargarAuditoriasAsignadas(int idAuditor) async {
    print(
      '[AuditorProvider] 🔄 Iniciando carga de auditorías para auditor: $idAuditor',
    );

    _setLoading(true);
    _errorMessage = null;

    try {
      print(
        '[AuditorProvider] 📡 Llamando a ApiService.getAuditoriasAsignadas...',
      );
      final auditoriasData = await ApiService.getAuditoriasAsignadas(idAuditor);
      print(
        '[AuditorProvider] 📥 Respuesta recibida: ${auditoriasData != null ? "Datos OK" : "NULL"}',
      );

      if (auditoriasData != null) {
        print(
          '[AuditorProvider] 🔄 Convirtiendo ${auditoriasData.length} registros a AuditModel...',
        );

        _auditoriasAsignadas = auditoriasData.map((json) {
          print(
            '[AuditorProvider] 📝 Procesando auditoría: ${json['id_auditoria']}',
          );
          try {
            return AuditModel.fromJson(json);
          } catch (e) {
            print(
              '[AuditorProvider] ❌ Error al parsear auditoría ${json['id_auditoria']}: $e',
            );
            print('[AuditorProvider] JSON problemático: $json');
            rethrow;
          }
        }).toList();

        print(
          '[AuditorProvider] ✅ ${_auditoriasAsignadas.length} auditorías cargadas exitosamente',
        );
        print(
          '[AuditorProvider] 📊 Estadísticas - Creadas: $auditoriasCreadas, En proceso: $auditoriasEnProceso, Finalizadas: $auditoriasFinalizadas',
        );
      } else {
        _errorMessage = 'No se pudieron cargar las auditorías';
        print('[AuditorProvider] ❌ Error: respuesta NULL del backend');
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[AuditorProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[AuditorProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[AuditorProvider] ⏹️ Finalizando carga (loading=false)');
      _setLoading(false);
    }
  }

  /// Refresca las auditorías asignadas
  Future<void> refrescarAuditorias(int idAuditor) async {
    print('[AuditorProvider] Refrescando auditorías...');
    await cargarAuditoriasAsignadas(idAuditor);
  }

  /// Carga todas las evidencias del auditor desde el backend
  /// idAuditoria = 0 para obtener todas las evidencias del auditor
  Future<void> cargarEvidencias({int idAuditoria = 0}) async {
    print(
      '[AuditorProvider] 🔄 Iniciando carga de evidencias (idAuditoria: $idAuditoria)',
    );

    _isLoadingEvidencias = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('[AuditorProvider] 📡 Llamando a ApiService.getEvidencias...');
      final evidenciasData = await ApiService.getEvidencias(idAuditoria);
      print(
        '[AuditorProvider] 📥 Respuesta recibida: ${evidenciasData != null ? "Datos OK" : "NULL"}',
      );

      if (evidenciasData != null) {
        print(
          '[AuditorProvider] 🔄 Convirtiendo ${evidenciasData.length} registros a EvidenceModel...',
        );

        // Obtener IDs únicos de auditorías
        final auditoriasIds = evidenciasData
            .map((e) => e['id_auditoria'] as int)
            .toSet()
            .toList();

        print(
          '[AuditorProvider] 📋 Auditorías únicas encontradas: $auditoriasIds',
        );

        // Cargar detalles de cada auditoría
        final Map<int, Map<String, dynamic>> auditoriasDetalles = {};
        for (final idAud in auditoriasIds) {
          print('[AuditorProvider] 📡 Cargando detalle de auditoría $idAud...');
          final detalle = await ApiService.getAuditoriaDetalle(idAud);
          if (detalle != null) {
            auditoriasDetalles[idAud] = detalle;
            print('[AuditorProvider] ✅ Detalle de auditoría $idAud cargado');
          }
        }

        _evidencias = evidenciasData.map((json) {
          print(
            '[AuditorProvider] 📝 Procesando evidencia: ${json['id_evidencia']}',
          );
          try {
            final evidencia = EvidenceModel.fromJson(json);

            // Enriquecer con datos de auditoría
            final auditoriaDetalle = auditoriasDetalles[evidencia.idAuditoria];
            if (auditoriaDetalle != null) {
              final cliente =
                  auditoriaDetalle['cliente'] as Map<String, dynamic>?;
              return evidencia.copyWith(
                auditoriaClienteNombre: cliente?['nombre'] as String?,
                auditoriaEmpresaNombre: cliente?['nombre_empresa'] as String?,
                auditoriaEstado: auditoriaDetalle['id_estado'] as int?,
              );
            }

            return evidencia;
          } catch (e) {
            print(
              '[AuditorProvider] ❌ Error al parsear evidencia ${json['id_evidencia']}: $e',
            );
            print('[AuditorProvider] JSON problemático: $json');
            rethrow;
          }
        }).toList();

        print(
          '[AuditorProvider] ✅ ${_evidencias.length} evidencias cargadas exitosamente',
        );
        print(
          '[AuditorProvider] 📊 Estadísticas - Fotos: $evidenciasFoto, Videos: $evidenciasVideo, Documentos: $evidenciasDocumento',
        );
      } else {
        _errorMessage = 'No se pudieron cargar las evidencias';
        print('[AuditorProvider] ❌ Error: respuesta NULL del backend');
      }
    } catch (error, stackTrace) {
      _errorMessage = 'Error de conexión: $error';
      print('[AuditorProvider] ❌ EXCEPCIÓN CAPTURADA: $error');
      print('[AuditorProvider] 📍 Stack trace: $stackTrace');
    } finally {
      print('[AuditorProvider] ⏹️ Finalizando carga de evidencias');
      _isLoadingEvidencias = false;
      notifyListeners();
    }
  }

  /// Refresca las evidencias
  Future<void> refrescarEvidencias({int idAuditoria = 0}) async {
    print('[AuditorProvider] Refrescando evidencias...');
    await cargarEvidencias(idAuditoria: idAuditoria);
  }

  /// Obtiene evidencias ordenadas por fecha (más recientes primero)
  List<EvidenceModel> getEvidenciasOrdenadas() {
    final lista = List<EvidenceModel>.from(_evidencias);
    lista.sort((a, b) {
      if (a.creadoEn == null && b.creadoEn == null) return 0;
      if (a.creadoEn == null) return 1;
      if (b.creadoEn == null) return -1;
      return b.creadoEn!.compareTo(a.creadoEn!);
    });
    return lista;
  }

  /// Filtra evidencias por tipo
  List<EvidenceModel> getEvidenciasPorTipo(String tipo) {
    return _evidencias.where((e) => e.tipo == tipo).toList();
  }

  /// Obtiene evidencias de una auditoría específica
  List<EvidenceModel> getEvidenciasPorAuditoria(int idAuditoria) {
    return _evidencias.where((e) => e.idAuditoria == idAuditoria).toList();
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
  /// Usa creada_en como fallback si fecha_inicio es null
  List<AuditModel> getAuditoriasOrdenadas() {
    final lista = List<AuditModel>.from(_auditoriasAsignadas);
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
    _evidencias = [];
    _errorMessage = null;
    _isLoading = false;
    _isLoadingEvidencias = false;
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
