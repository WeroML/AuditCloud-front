import '../../core/utils/safe_parser.dart';

/// Modelo de solicitud de pago basado en solicitudes_pago.json del backend
class PaymentRequestModel {
  final int? idSolicitud;
  final int idEmpresa; // id_empresa_auditora (compatibilidad)
  final int idEmpresaAuditora;
  final int idCliente; // id_usuario del cliente
  final double monto;
  final String concepto;
  final int idEstado; // 1=PENDIENTE, 2=PAGADA
  final DateTime? creadoEn;
  final DateTime? pagadaEn;

  PaymentRequestModel({
    this.idSolicitud,
    required this.idEmpresa,
    required this.idEmpresaAuditora,
    required this.idCliente,
    required this.monto,
    required this.concepto,
    this.idEstado = 1, // Por defecto: PENDIENTE
    this.creadoEn,
    this.pagadaEn,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_solicitud': idSolicitud,
      'id_empresa': idEmpresa,
      'id_empresa_auditora': idEmpresaAuditora,
      'id_cliente': idCliente,
      'monto': monto,
      'concepto': concepto,
      'id_estado': idEstado,
      'creado_en': creadoEn?.toIso8601String(),
      'pagada_en': pagadaEn?.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON del backend
  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestModel(
      idSolicitud: SafeParser.parseIntNullable(json, 'id_solicitud'),
      idEmpresa: SafeParser.parseIntFromMultiplePaths(json, ['id_empresa', 'empresa.id_empresa', 'id_empresa_auditora']),
      idEmpresaAuditora: SafeParser.parseIntFromMultiplePaths(json, ['id_empresa_auditora', 'empresa_auditora.id_empresa', 'empresa.id_empresa']),
      idCliente: SafeParser.parseIntFromMultiplePaths(json, ['id_cliente', 'cliente.id_usuario', 'cliente.id_empresa']),
      monto: SafeParser.parseDouble(json, 'monto'),
      concepto: SafeParser.parseString(json, 'concepto'),
      idEstado: SafeParser.parseInt(json, 'id_estado', defaultValue: 1),
      creadoEn: json['creado_en'] != null
          ? DateTime.tryParse(json['creado_en'].toString())
          : null,
      pagadaEn: json['pagada_en'] != null
          ? DateTime.tryParse(json['pagada_en'].toString())
          : null,
    );
  }

  /// Crea una copia del modelo con campos actualizados
  PaymentRequestModel copyWith({
    int? idSolicitud,
    int? idEmpresa,
    int? idEmpresaAuditora,
    int? idCliente,
    double? monto,
    String? concepto,
    int? idEstado,
    DateTime? creadoEn,
    DateTime? pagadaEn,
  }) {
    return PaymentRequestModel(
      idSolicitud: idSolicitud ?? this.idSolicitud,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idEmpresaAuditora: idEmpresaAuditora ?? this.idEmpresaAuditora,
      idCliente: idCliente ?? this.idCliente,
      monto: monto ?? this.monto,
      concepto: concepto ?? this.concepto,
      idEstado: idEstado ?? this.idEstado,
      creadoEn: creadoEn ?? this.creadoEn,
      pagadaEn: pagadaEn ?? this.pagadaEn,
    );
  }

  @override
  String toString() {
    return 'PaymentRequestModel(idSolicitud: $idSolicitud, monto: $monto, '
        'concepto: $concepto, idEstado: $idEstado)';
  }
}
