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
      idEmpresa: json['id_empresa'] as int?,
      idTipoEmpresa: json['id_tipo_empresa'] as int,
      nombre: json['nombre'] as String,
      rfc: json['rfc'] as String?,
      giro: json['giro'] as String?,
      direccion: json['direccion'] as String?,
      ciudad: json['ciudad'] as String?,
      estado: json['estado'] as String?,
      pais: json['pais'] as String? ?? 'México',
      contactoNombre: json['contacto_nombre'] as String,
      contactoCorreo: json['contacto_correo'] as String,
      contactoTelefono: json['contacto_telefono'] as String?,
      activo: json['activo'] as bool? ?? true,
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
