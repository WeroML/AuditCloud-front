/// Modelo de estado de auditoría basado en estados_auditoria.json del backend
class AuditStatusModel {
  final int idEstado;
  final String clave; // CREADA, EN_PROCESO, FINALIZADA
  final String nombre;

  AuditStatusModel({
    required this.idEstado,
    required this.clave,
    required this.nombre,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {'id_estado': idEstado, 'clave': clave, 'nombre': nombre};
  }

  /// Crea una instancia desde JSON del backend
  factory AuditStatusModel.fromJson(Map<String, dynamic> json) {
    return AuditStatusModel(
      idEstado: json['id_estado'] as int,
      clave: json['clave'] as String,
      nombre: json['nombre'] as String,
    );
  }

  @override
  String toString() {
    return 'AuditStatusModel(idEstado: $idEstado, clave: $clave, nombre: $nombre)';
  }
}
