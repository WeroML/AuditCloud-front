import '../../core/utils/safe_parser.dart';

/// Modelo de empresa basado en empresas.json del backend
class CompanyModel {
  final int? idEmpresa;
  final int idTipoEmpresa; // 1=AUDITORA, 2=CLIENTE
  final String nombre;
  final String? rfc;
  final String? giro;
  final String? direccion;
  final String? ciudad;
  final String? estado;
  final String pais;
  final String contactoNombre;
  final String contactoCorreo;
  final String? contactoTelefono;
  final bool activo;

  CompanyModel({
    this.idEmpresa,
    required this.idTipoEmpresa,
    required this.nombre,
    this.rfc,
    this.giro,
    this.direccion,
    this.ciudad,
    this.estado,
    this.pais = 'México',
    required this.contactoNombre,
    required this.contactoCorreo,
    this.contactoTelefono,
    this.activo = true,
  });

  /// Convierte el modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'id_empresa': idEmpresa,
      'id_tipo_empresa': idTipoEmpresa,
      'nombre': nombre,
      'rfc': rfc,
      'giro': giro,
      'direccion': direccion,
      'ciudad': ciudad,
      'estado': estado,
      'pais': pais,
      'contacto_nombre': contactoNombre,
      'contacto_correo': contactoCorreo,
      'contacto_telefono': contactoTelefono,
      'activo': activo,
    };
  }

  /// Crea una instancia desde JSON del backend
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      idEmpresa: SafeParser.parseIntNullable(json, 'id_empresa'),
      idTipoEmpresa: SafeParser.parseInt(json, 'id_tipo_empresa'),
      nombre: SafeParser.parseString(json, 'nombre'),
      rfc: SafeParser.parseStringNullable(json, 'rfc'),
      giro: SafeParser.parseStringNullable(json, 'giro'),
      direccion: SafeParser.parseStringNullable(json, 'direccion'),
      ciudad: SafeParser.parseStringNullable(json, 'ciudad'),
      estado: SafeParser.parseStringNullable(json, 'estado'),
      pais: SafeParser.parseString(json, 'pais', defaultValue: 'México'),
      contactoNombre: SafeParser.parseString(json, 'contacto_nombre'),
      contactoCorreo: SafeParser.parseString(json, 'contacto_correo'),
      contactoTelefono: SafeParser.parseStringNullable(json, 'contacto_telefono'),
      activo: SafeParser.parseBool(json, 'activo', defaultValue: true),
    );
  }

  /// Crea una copia del modelo con campos actualizados
  CompanyModel copyWith({
    int? idEmpresa,
    int? idTipoEmpresa,
    String? nombre,
    String? rfc,
    String? giro,
    String? direccion,
    String? ciudad,
    String? estado,
    String? pais,
    String? contactoNombre,
    String? contactoCorreo,
    String? contactoTelefono,
    bool? activo,
  }) {
    return CompanyModel(
      idEmpresa: idEmpresa ?? this.idEmpresa,
      idTipoEmpresa: idTipoEmpresa ?? this.idTipoEmpresa,
      nombre: nombre ?? this.nombre,
      rfc: rfc ?? this.rfc,
      giro: giro ?? this.giro,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      estado: estado ?? this.estado,
      pais: pais ?? this.pais,
      contactoNombre: contactoNombre ?? this.contactoNombre,
      contactoCorreo: contactoCorreo ?? this.contactoCorreo,
      contactoTelefono: contactoTelefono ?? this.contactoTelefono,
      activo: activo ?? this.activo,
    );
  }

  @override
  String toString() {
    return 'CompanyModel(idEmpresa: $idEmpresa, nombre: $nombre, '
        'idTipoEmpresa: $idTipoEmpresa, activo: $activo)';
  }
}
