/// Modelo de rol de usuario basado en roles.json del backend
class RoleModel {
  final int idRol;
  final String clave; // SUPERVISOR, AUDITOR, CLIENTE
  final String nombre;

  RoleModel({required this.idRol, required this.clave, required this.nombre});

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {'id_rol': idRol, 'clave': clave, 'nombre': nombre};
  }

  /// Crea una instancia desde JSON del backend
  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      idRol: json['id_rol'] as int,
      clave: json['clave'] as String,
      nombre: json['nombre'] as String,
    );
  }

  @override
  String toString() {
    return 'RoleModel(idRol: $idRol, clave: $clave, nombre: $nombre)';
  }
}
