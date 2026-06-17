import '../../core/utils/safe_parser.dart';

/// Modelo de módulo ambiental basado en modulos_ambientales.json del backend
class EnvironmentalModuleModel {
  final int idModulo;
  final String clave; // AGUA, RESIDUOS, ENERGIA
  final String nombre;

  EnvironmentalModuleModel({
    required this.idModulo,
    required this.clave,
    required this.nombre,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {'id_modulo': idModulo, 'clave': clave, 'nombre': nombre};
  }

  /// Crea una instancia desde JSON del backend
  factory EnvironmentalModuleModel.fromJson(Map<String, dynamic> json) {
    return EnvironmentalModuleModel(
      idModulo: SafeParser.parseInt(json, 'id_modulo'),
      clave: SafeParser.parseString(json, 'clave'),
      nombre: SafeParser.parseString(json, 'nombre'),
    );
  }

  @override
  String toString() {
    return 'EnvironmentalModuleModel(idModulo: $idModulo, clave: $clave, nombre: $nombre)';
  }
}
