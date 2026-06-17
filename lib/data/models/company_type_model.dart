import '../../core/utils/safe_parser.dart';

/// Modelo de tipo de empresa basado en tipos_empresa.json del backend
class CompanyTypeModel {
  final int idTipoEmpresa;
  final String clave; // AUDITORA, CLIENTE
  final String nombre;

  CompanyTypeModel({
    required this.idTipoEmpresa,
    required this.clave,
    required this.nombre,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {'id_tipo_empresa': idTipoEmpresa, 'clave': clave, 'nombre': nombre};
  }

  /// Crea una instancia desde JSON del backend
  factory CompanyTypeModel.fromJson(Map<String, dynamic> json) {
    return CompanyTypeModel(
      idTipoEmpresa: SafeParser.parseInt(json, 'id_tipo_empresa'),
      clave: SafeParser.parseString(json, 'clave'),
      nombre: SafeParser.parseString(json, 'nombre'),
    );
  }

  @override
  String toString() {
    return 'CompanyTypeModel(idTipoEmpresa: $idTipoEmpresa, clave: $clave, nombre: $nombre)';
  }
}
