/// Modelo de usuario basado en la tabla SQL 'usuarios'
/// y datos adicionales de Google Sign-In
class UserModel {
  // Campos de la tabla SQL
  final int? idUsuario; // Nullable hasta que se sincronice con backend
  final String nombre;
  final String correo;
  final String? rol; // Nullable porque puede no estar asignado al inicio
  final String authProvider; // 'google', 'local', etc.
  final bool activo;

  // Campos adicionales de Google
  final String? photoUrl;
  final String? googleUserId;

  // Token para futuras comunicaciones con backend
  final String? backendToken;

  UserModel({
    this.idUsuario,
    required this.nombre,
    required this.correo,
    this.rol,
    required this.authProvider,
    this.activo = true,
    this.photoUrl,
    this.googleUserId,
    this.backendToken,
  });

  /// Convierte el modelo a JSON para almacenamiento o envío al backend
  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      'auth_provider': authProvider,
      'activo': activo,
      'photo_url': photoUrl,
      'google_user_id': googleUserId,
      'backend_token': backendToken,
    };
  }

  /// Crea una instancia desde JSON (backend, NFS/HDFS, o caché local)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idUsuario: json['id_usuario'] as int?,
      nombre: json['nombre'] as String,
      correo: json['correo'] as String,
      rol: json['rol'] as String?,
      authProvider: json['auth_provider'] as String,
      activo: json['activo'] as bool? ?? true,
      photoUrl: json['photo_url'] as String?,
      googleUserId: json['google_user_id'] as String?,
      backendToken: json['backend_token'] as String?,
    );
  }

  /// Crea una copia del usuario con campos actualizados
  UserModel copyWith({
    int? idUsuario,
    String? nombre,
    String? correo,
    String? rol,
    String? authProvider,
    bool? activo,
    String? photoUrl,
    String? googleUserId,
    String? backendToken,
  }) {
    return UserModel(
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      rol: rol ?? this.rol,
      authProvider: authProvider ?? this.authProvider,
      activo: activo ?? this.activo,
      photoUrl: photoUrl ?? this.photoUrl,
      googleUserId: googleUserId ?? this.googleUserId,
      backendToken: backendToken ?? this.backendToken,
    );
  }

  @override
  String toString() {
    return 'UserModel(idUsuario: $idUsuario, nombre: $nombre, correo: $correo, '
        'rol: $rol, authProvider: $authProvider, activo: $activo)';
  }
}
