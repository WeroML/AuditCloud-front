import '../../core/utils/safe_parser.dart';

/// Modelo de evidencia basado en evidencias.json del backend
class EvidenceModel {
  final int? idEvidencia;
  final int idAuditoria;
  final int idModulo;
  final int idAuditor; // id_usuario del auditor
  final String tipo; // "FOTO", "VIDEO", "DOC"
  final String url; // URL del archivo almacenado
  final String nombreArchivo; // Nombre original del archivo
  final String descripcion;
  final String? ubicacion;
  final DateTime? creadoEn;

  // Información enriquecida de la auditoría asociada
  final String? auditoriaClienteNombre;
  final String? auditoriaEmpresaNombre;
  final int? auditoriaEstado;

  EvidenceModel({
    this.idEvidencia,
    required this.idAuditoria,
    required this.idModulo,
    required this.idAuditor,
    required this.tipo,
    required this.url,
    required this.nombreArchivo,
    required this.descripcion,
    this.ubicacion,
    this.creadoEn,
    this.auditoriaClienteNombre,
    this.auditoriaEmpresaNombre,
    this.auditoriaEstado,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_evidencia': idEvidencia,
      'id_auditoria': idAuditoria,
      'id_modulo': idModulo,
      'id_auditor': idAuditor,
      'tipo': tipo,
      'url': url,
      'nombre_archivo': nombreArchivo,
      'descripcion': descripcion,
      'ubicacion': ubicacion,
      'creado_en': creadoEn?.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON del backend
  factory EvidenceModel.fromJson(Map<String, dynamic> json) {
    return EvidenceModel(
      idEvidencia: SafeParser.parseIntNullable(json, 'id_evidencia'),
      idAuditoria: SafeParser.parseIntFromMultiplePaths(json, ['id_auditoria', 'auditoria.id_auditoria']),
      idModulo: SafeParser.parseInt(json, 'id_modulo'),
      idAuditor: SafeParser.parseIntFromMultiplePaths(json, ['id_auditor', 'auditor.id_usuario']),
      tipo: SafeParser.parseString(json, 'tipo'),
      url: SafeParser.parseString(json, 'url'),
      nombreArchivo: SafeParser.parseString(json, 'nombre_archivo'),
      descripcion: SafeParser.parseString(json, 'descripcion'),
      ubicacion: SafeParser.parseStringNullable(json, 'ubicacion'),
      creadoEn: json['creado_en'] != null
          ? DateTime.tryParse(json['creado_en'].toString())
          : null,
    );
  }

  /// Crea una copia del modelo con campos actualizados
  EvidenceModel copyWith({
    int? idEvidencia,
    int? idAuditoria,
    int? idModulo,
    int? idAuditor,
    String? tipo,
    String? url,
    String? nombreArchivo,
    String? descripcion,
    String? ubicacion,
    DateTime? creadoEn,
    String? auditoriaClienteNombre,
    String? auditoriaEmpresaNombre,
    int? auditoriaEstado,
  }) {
    return EvidenceModel(
      idEvidencia: idEvidencia ?? this.idEvidencia,
      idAuditoria: idAuditoria ?? this.idAuditoria,
      idModulo: idModulo ?? this.idModulo,
      idAuditor: idAuditor ?? this.idAuditor,
      tipo: tipo ?? this.tipo,
      url: url ?? this.url,
      nombreArchivo: nombreArchivo ?? this.nombreArchivo,
      descripcion: descripcion ?? this.descripcion,
      ubicacion: ubicacion ?? this.ubicacion,
      creadoEn: creadoEn ?? this.creadoEn,
      auditoriaClienteNombre:
          auditoriaClienteNombre ?? this.auditoriaClienteNombre,
      auditoriaEmpresaNombre:
          auditoriaEmpresaNombre ?? this.auditoriaEmpresaNombre,
      auditoriaEstado: auditoriaEstado ?? this.auditoriaEstado,
    );
  }

  @override
  String toString() {
    return 'EvidenceModel(idEvidencia: $idEvidencia, tipo: $tipo, '
        'idAuditoria: $idAuditoria, descripcion: $descripcion)';
  }
}
