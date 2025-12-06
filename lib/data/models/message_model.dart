/// Modelo de mensaje basado en mensajes.json del backend
class MessageModel {
  final int? idMensaje;
  final int idConversacion;
  final String emisorTipo; // "CLIENTE", "SUPERVISOR", "AUDITOR"
  final int emisorId; // id_usuario del emisor
  final String contenido;
  final DateTime? creadoEn;

  MessageModel({
    this.idMensaje,
    required this.idConversacion,
    required this.emisorTipo,
    required this.emisorId,
    required this.contenido,
    this.creadoEn,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_mensaje': idMensaje,
      'id_conversacion': idConversacion,
      'emisor_tipo': emisorTipo,
      'emisor_id': emisorId,
      'contenido': contenido,
      'creado_en': creadoEn?.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON del backend
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      idMensaje: json['id_mensaje'] as int?,
      idConversacion: json['id_conversacion'] as int,
      emisorTipo: json['emisor_tipo'] as String,
      emisorId: json['emisor_id'] as int,
      contenido: json['contenido'] as String,
      creadoEn: json['creado_en'] != null
          ? DateTime.parse(json['creado_en'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'MessageModel(idMensaje: $idMensaje, emisorTipo: $emisorTipo, '
        'emisorId: $emisorId, contenido: ${contenido.substring(0, contenido.length > 30 ? 30 : contenido.length)}...)';
  }
}
