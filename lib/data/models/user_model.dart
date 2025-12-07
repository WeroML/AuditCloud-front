/// Modelo de usuario basado en usuarios.json del backend
class UserModel {
  final int? idUsuario;
  final int? idEmpresa;
  final String nombre;
  final String correo;
  final String? passwordHash;
  final int? idRol;
  final bool activo;
  final DateTime? creadoEn;

  // Campos de Google Sign-In
  final String? photoUrl;
  final String? googleId; // ID único de Google
  final bool? loginGoogle; // Indica si se registró con Google

  UserModel({
    this.idUsuario,
    this.idEmpresa,
    required this.nombre,
    required this.correo,
    this.passwordHash,
    this.idRol,
    this.activo = true,
    this.creadoEn,
    this.photoUrl,
    this.googleId,
    this.loginGoogle,
  });

  /// Convierte el modelo a JSON para almacenamiento o envío al backend
  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'id_empresa': idEmpresa,
      'nombre': nombre,
      'correo': correo,
      'password_hash': passwordHash,
      'id_rol': idRol,
      'activo': activo,
      'creado_en': creadoEn?.toIso8601String(),
      'foto_url': photoUrl,
      'google_id': googleId,
      'login_google': loginGoogle,
    };
  }

  /// Crea una instancia desde JSON del backend
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUsuario: json['id_usuario'] as int?,
      idEmpresa: json['id_empresa'] as int?,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      passwordHash: json['password_hash'] as String?,
      idRol: json['id_rol'] as int?,
      activo: json['activo'] as bool? ?? true,
      creadoEn: json['creado_en'] != null
          ? DateTime.parse(json['creado_en'] as String)
          : null,
      photoUrl: json['foto_url'] as String?,
      googleId: json['google_id'] as String?,
      loginGoogle: json['login_google'] as bool?,
    );
  }

  /// Crea una copia del usuario con campos actualizados
  UserModel copyWith({
    int? idUsuario,
    int? idEmpresa,
    String? nombre,
    String? correo,
    String? passwordHash,
    int? idRol,
    bool? activo,
    DateTime? creadoEn,
    String? photoUrl,
    String? googleId,
    bool? loginGoogle,
  }) {
    return UserModel(
      idUsuario: idUsuario ?? this.idUsuario,
      idEmpresa: idEmpresa ?? this.idEmpresa,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      passwordHash: passwordHash ?? this.passwordHash,
      idRol: idRol ?? this.idRol,
      activo: activo ?? this.activo,
      creadoEn: creadoEn ?? this.creadoEn,
      photoUrl: photoUrl ?? this.photoUrl,
      googleId: googleId ?? this.googleId,
      loginGoogle: loginGoogle ?? this.loginGoogle,
    );
  }

  @override
  String toString() {
    return 'UserModel(idUsuario: $idUsuario, nombre: $nombre, correo: $correo, '
        'idRol: $idRol, idEmpresa: $idEmpresa, activo: $activo)';
  }
}
