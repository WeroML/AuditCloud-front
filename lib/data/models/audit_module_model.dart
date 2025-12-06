/// Modelo de relación auditoría-módulo basado en auditoria_modulos.json del backend
class AuditModuleModel {
  final int? idAuditoriaModulo;
  final int idAuditoria;
  final int idModulo;
  final DateTime? registradoEn;

  AuditModuleModel({
    this.idAuditoriaModulo,
    required this.idAuditoria,
    required this.idModulo,
    this.registradoEn,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_auditoria_modulo': idAuditoriaModulo,
      'id_auditoria': idAuditoria,
      'id_modulo': idModulo,
      'registrado_en': registradoEn?.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON del backend
  factory AuditModuleModel.fromJson(Map<String, dynamic> json) {
    return AuditModuleModel(
      idAuditoriaModulo: json['id_auditoria_modulo'] as int?,
      idAuditoria: json['id_auditoria'] as int,
      idModulo: json['id_modulo'] as int,
      registradoEn: json['registrado_en'] != null
          ? DateTime.parse(json['registrado_en'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'AuditModuleModel(idAuditoriaModulo: $idAuditoriaModulo, '
        'idAuditoria: $idAuditoria, idModulo: $idModulo)';
  }
}
