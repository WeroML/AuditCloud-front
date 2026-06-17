import '../../core/utils/safe_parser.dart';

/// Modelo de participante de auditoría basado en auditoria_participantes.json del backend
class AuditParticipantModel {
  final int? idParticipante;
  final int idAuditoria;
  final int idAuditor; // id_usuario del auditor
  final DateTime? asignadoEn;

  AuditParticipantModel({
    this.idParticipante,
    required this.idAuditoria,
    required this.idAuditor,
    this.asignadoEn,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_participante': idParticipante,
      'id_auditoria': idAuditoria,
      'id_auditor': idAuditor,
      'asignado_en': asignadoEn?.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON del backend
  factory AuditParticipantModel.fromJson(Map<String, dynamic> json) {
    return AuditParticipantModel(
      idParticipante: SafeParser.parseIntNullable(json, 'id_participante'),
      idAuditoria: SafeParser.parseInt(json, 'id_auditoria'),
      idAuditor: SafeParser.parseInt(json, 'id_auditor'),
      asignadoEn: json['asignado_en'] != null
          ? DateTime.tryParse(json['asignado_en'].toString())
          : null,
    );
  }

  @override
  String toString() {
    return 'AuditParticipantModel(idParticipante: $idParticipante, '
        'idAuditoria: $idAuditoria, idAuditor: $idAuditor)';
  }
}
