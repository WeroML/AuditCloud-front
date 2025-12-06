/// Modelo de auditoría basado en auditorias.json del backend
class AuditModel {
  final int? idAuditoria;
  final int idEmpresaAuditora;
  final int idCliente; // id_usuario del cliente
  final int? idSolicitudPago;
  final int idEstado; // 1=CREADA, 2=EN_PROCESO, 3=FINALIZADA
  final double? monto;
  final DateTime? fechaInicio;
  final DateTime? creadaEn;
  final DateTime? estadoActualizadoEn;

  AuditModel({
    this.idAuditoria,
    required this.idEmpresaAuditora,
    required this.idCliente,
    this.idSolicitudPago,
    this.idEstado = 1, // Por defecto: CREADA
    this.monto,
    this.fechaInicio,
    this.creadaEn,
    this.estadoActualizadoEn,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_auditoria': idAuditoria,
      'id_empresa_auditora': idEmpresaAuditora,
      'id_cliente': idCliente,
      'id_solicitud_pago': idSolicitudPago,
      'id_estado': idEstado,
      'monto': monto,
      'fecha_inicio': fechaInicio?.toIso8601String(),
      'creada_en': creadaEn?.toIso8601String(),
      'estado_actualizado_en': estadoActualizadoEn?.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON del backend
  factory AuditModel.fromJson(Map<String, dynamic> json) {
    return AuditModel(
      idAuditoria: json['id_auditoria'] as int?,
      idEmpresaAuditora: json['id_empresa_auditora'] as int,
      idCliente: json['id_cliente'] as int,
      idSolicitudPago: json['id_solicitud_pago'] as int?,
      idEstado: json['id_estado'] as int? ?? 1,
      monto: json['monto'] != null ? (json['monto'] as num).toDouble() : null,
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.parse(json['fecha_inicio'] as String)
          : null,
      creadaEn: json['creada_en'] != null
          ? DateTime.parse(json['creada_en'] as String)
          : null,
      estadoActualizadoEn: json['estado_actualizado_en'] != null
          ? DateTime.parse(json['estado_actualizado_en'] as String)
          : null,
    );
  }

  /// Crea una copia del modelo con campos actualizados
  AuditModel copyWith({
    int? idAuditoria,
    int? idEmpresaAuditora,
    int? idCliente,
    int? idSolicitudPago,
    int? idEstado,
    double? monto,
    DateTime? fechaInicio,
    DateTime? creadaEn,
    DateTime? estadoActualizadoEn,
  }) {
    return AuditModel(
      idAuditoria: idAuditoria ?? this.idAuditoria,
      idEmpresaAuditora: idEmpresaAuditora ?? this.idEmpresaAuditora,
      idCliente: idCliente ?? this.idCliente,
      idSolicitudPago: idSolicitudPago ?? this.idSolicitudPago,
      idEstado: idEstado ?? this.idEstado,
      monto: monto ?? this.monto,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      creadaEn: creadaEn ?? this.creadaEn,
      estadoActualizadoEn: estadoActualizadoEn ?? this.estadoActualizadoEn,
    );
  }

  @override
  String toString() {
    return 'AuditModel(idAuditoria: $idAuditoria, idEmpresaAuditora: $idEmpresaAuditora, '
        'idCliente: $idCliente, idEstado: $idEstado, monto: $monto)';
  }
}
