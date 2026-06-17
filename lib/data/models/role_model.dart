import '../../core/utils/safe_parser.dart';

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
      idRol: SafeParser.parseInt(json, 'id_rol'),
      clave: SafeParser.parseString(json, 'clave'),
      nombre: SafeParser.parseString(json, 'nombre'),
    );
  }

  @override
  String toString() {
    return 'RoleModel(idRol: $idRol, clave: $clave, nombre: $nombre)';
  }
}
