import '../../core/utils/safe_parser.dart';

/// Modelo de relación empresa-módulo basado en empresa_modulos.json del backend
class CompanyModuleModel {
  final int? idEmpresaModulo;
  final int idEmpresa;
  final int idModulo;
  final DateTime? registradoEn;

  CompanyModuleModel({
    this.idEmpresaModulo,
    required this.idEmpresa,
    required this.idModulo,
    this.registradoEn,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_empresa_modulo': idEmpresaModulo,
      'id_empresa': idEmpresa,
      'id_modulo': idModulo,
      'registrado_en': registradoEn?.toIso8601String(),
    };
  }

  /// Crea una instancia desde JSON del backend
  factory CompanyModuleModel.fromJson(Map<String, dynamic> json) {
    return CompanyModuleModel(
      idEmpresaModulo: SafeParser.parseIntNullable(json, 'id_empresa_modulo'),
      idEmpresa: SafeParser.parseInt(json, 'id_empresa'),
      idModulo: SafeParser.parseInt(json, 'id_modulo'),
      registradoEn: json['registrado_en'] != null
          ? DateTime.tryParse(json['registrado_en'].toString())
          : null,
    );
  }

  @override
  String toString() {
    return 'CompanyModuleModel(idEmpresaModulo: $idEmpresaModulo, '
        'idEmpresa: $idEmpresa, idModulo: $idModulo)';
  }
}
