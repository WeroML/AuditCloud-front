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
      idEmpresaModulo: json['id_empresa_modulo'] as int?,
      idEmpresa: json['id_empresa'] as int,
      idModulo: json['id_modulo'] as int,
      registradoEn: json['registrado_en'] != null
          ? DateTime.parse(json['registrado_en'] as String)
          : null,
    );
  }

  @override
  String toString() {
    return 'CompanyModuleModel(idEmpresaModulo: $idEmpresaModulo, '
        'idEmpresa: $idEmpresa, idModulo: $idModulo)';
  }
}
