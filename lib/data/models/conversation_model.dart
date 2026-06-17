import '../../core/utils/safe_parser.dart';

/// Modelo de conversación basado en conversaciones.json del backend
class ConversationModel {
  final int? idConversacion;
  final int idCliente; // id_usuario del cliente
  final int idEmpresaAuditora;
  final String asunto;
  final DateTime? creadoEn;
  final bool activo;

  ConversationModel({
    this.idConversacion,
    required this.idCliente,
    required this.idEmpresaAuditora,
    required this.asunto,
    this.creadoEn,
    this.activo = true,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_conversacion': idConversacion,
      'id_cliente': idCliente,
      'id_empresa_auditora': idEmpresaAuditora,
      'asunto': asunto,
      'creado_en': creadoEn?.toIso8601String(),
      'activo': activo,
    };
  }

  /// Crea una instancia desde JSON del backend
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      idConversacion: SafeParser.parseIntNullable(json, 'id_conversacion'),
      idCliente: SafeParser.parseIntFromMultiplePaths(json, ['id_cliente', 'cliente.id_usuario', 'cliente.id_empresa']),
      idEmpresaAuditora: SafeParser.parseIntFromMultiplePaths(json, ['id_empresa_auditora', 'empresa.id_empresa', 'empresa_auditora.id_empresa']),
      asunto: SafeParser.parseString(json, 'asunto'),
      creadoEn: json['creado_en'] != null
          ? DateTime.tryParse(json['creado_en'].toString())
          : null,
      activo: SafeParser.parseBool(json, 'activo', defaultValue: true),
    );
  }

  /// Crea una copia del modelo con campos actualizados
  ConversationModel copyWith({
    int? idConversacion,
    int? idCliente,
    int? idEmpresaAuditora,
    String? asunto,
    DateTime? creadoEn,
    bool? activo,
  }) {
    return ConversationModel(
      idConversacion: idConversacion ?? this.idConversacion,
      idCliente: idCliente ?? this.idCliente,
      idEmpresaAuditora: idEmpresaAuditora ?? this.idEmpresaAuditora,
      asunto: asunto ?? this.asunto,
      creadoEn: creadoEn ?? this.creadoEn,
      activo: activo ?? this.activo,
    );
  }

  @override
  String toString() {
    return 'ConversationModel(idConversacion: $idConversacion, asunto: $asunto, '
        'idCliente: $idCliente, idEmpresaAuditora: $idEmpresaAuditora)';
  }
}
