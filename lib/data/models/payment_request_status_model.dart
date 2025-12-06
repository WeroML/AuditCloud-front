/// Modelo de estado de solicitud de pago basado en estados_solicitud_pago.json del backend
class PaymentRequestStatusModel {
  final int idEstado;
  final String clave; // PENDIENTE, PAGADA
  final String nombre;

  PaymentRequestStatusModel({
    required this.idEstado,
    required this.clave,
    required this.nombre,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {'id_estado': idEstado, 'clave': clave, 'nombre': nombre};
  }

  /// Crea una instancia desde JSON del backend
  factory PaymentRequestStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestStatusModel(
      idEstado: json['id_estado'] as int,
      clave: json['clave'] as String,
      nombre: json['nombre'] as String,
    );
  }

  @override
  String toString() {
    return 'PaymentRequestStatusModel(idEstado: $idEstado, clave: $clave, nombre: $nombre)';
  }
}
