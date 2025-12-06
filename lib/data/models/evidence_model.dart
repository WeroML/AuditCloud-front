/// Modelo de evidencia basado en evidencias.json del backend
class EvidenceModel {
  final int? idEvidencia;
  final int idAuditoria;
  final int idModulo;
  final int idAuditor; // id_usuario del auditor
  final String tipo; // "foto", "documento", "nota"
  final String urlArchivo; // Ruta/URL del archivo almacenado
  final String descripcion;
  final String? ubicacion;
  final DateTime? subidoEn;

  EvidenceModel({
    this.idEvidencia,
    required this.idAuditoria,
    required this.idModulo,
    required this.idAuditor,
    required this.tipo,
    required this.urlArchivo,
    required this.descripcion,
    this.ubicacion,
    this.subidoEn,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_evidencia': idEvidencia,
      'id_auditoria': idAuditoria,
      'id_modulo': idModulo,
      'id_auditor': idAuditor,
      'tipo': tipo,
      'url_archivo': urlArchivo,
      'descripcion': descripcion,
      'ubicacion': ubicacion,
      'subido_en': subidoEn?.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON del backend
  factory EvidenceModel.fromJson(Map<String, dynamic> json) {
    return EvidenceModel(
      idEvidencia: json['id_evidencia'] as int?,
      idAuditoria: json['id_auditoria'] as int,
      idModulo: json['id_modulo'] as int,
      idAuditor: json['id_auditor'] as int,
      tipo: json['tipo'] as String,
      urlArchivo: json['url_archivo'] as String,
      descripcion: json['descripcion'] as String,
      ubicacion: json['ubicacion'] as String?,
      subidoEn: json['subido_en'] != null
          ? DateTime.parse(json['subido_en'] as String)
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
    String? urlArchivo,
    String? descripcion,
    String? ubicacion,
    DateTime? subidoEn,
  }) {
    return EvidenceModel(
      idEvidencia: idEvidencia ?? this.idEvidencia,
      idAuditoria: idAuditoria ?? this.idAuditoria,
      idModulo: idModulo ?? this.idModulo,
      idAuditor: idAuditor ?? this.idAuditor,
      tipo: tipo ?? this.tipo,
      urlArchivo: urlArchivo ?? this.urlArchivo,
      descripcion: descripcion ?? this.descripcion,
      ubicacion: ubicacion ?? this.ubicacion,
      subidoEn: subidoEn ?? this.subidoEn,
    );
  }

  @override
  String toString() {
    return 'EvidenceModel(idEvidencia: $idEvidencia, tipo: $tipo, '
        'idAuditoria: $idAuditoria, descripcion: $descripcion)';
  }
}
