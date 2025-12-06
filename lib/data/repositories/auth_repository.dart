import 'package:google_sign_in/google_sign_in.dart';
import 'package:audit_cloud_app/data/models/user_model.dart';
import 'package:audit_cloud_app/services/api_service.dart';

/// Repository que maneja toda la lógica de autenticación
/// No depende de Provider ni de la capa de UI
/// Preparado para integración futura con backend y NFS/HDFS
class AuthRepository {
  //Inicio de sesión local al backend y google sign in

  /// Login tradicional con correo y contraseña
  /// Llama al endpoint POST /api/auth/login del backend
  Future<UserModel?> signInWithCredentials(
    String email,
    String password,
  ) async {
    print('[AuthRepository] Iniciando login con credenciales...');
    print('[AuthRepository] Email: $email');

    try {
      // Llamar al endpoint de login del backend
      final responseData = await ApiService.login(email, password);

      if (responseData == null) {
        print('[AuthRepository] ❌ Login falló - respuesta null');
        return null;
      }

      print('[AuthRepository] ✅ Login exitoso');
      print('[AuthRepository] Token guardado en ApiService');

      // Extraer datos del usuario de la respuesta
      final usuarioData = responseData['usuario'] as Map<String, dynamic>;

      // Crear el UserModel desde la respuesta del backend
      final user = UserModel(
        idUsuario: usuarioData['id_usuario'] as int,
        idEmpresa: usuarioData['id_empresa'] as int?,
        nombre: usuarioData['nombre'] as String,
        correo: usuarioData['correo'] as String,
        idRol: usuarioData['id_rol'] as int?,
        authProvider: 'local',
        activo: true,
      );

      print('[AuthRepository] UserModel creado: ${user.nombre}');
      return user;
    } catch (e) {
      print('[AuthRepository] ❌ Error en login: $e');
      return null;
    }
  }

  // Instancia de Google Sign-In
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  /// Realiza el login con Google Sign-In
  /// Retorna un UserModel si tiene éxito, null si falla o se cancela
  Future<UserModel?> signInWithGoogle() async {
    print('[AuthRepository] Iniciando Google Sign-In...');
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló el login
        print('[AuthRepository] Login cancelado por el usuario');
        return null;
      }

      print('[AuthRepository] Usuario de Google obtenido: ${googleUser.email}');

      // Obtener datos del usuario de Google
      final String displayName = googleUser.displayName ?? 'Usuario';
      final String email = googleUser.email;
      final String? photoUrl = googleUser.photoUrl;
      final String googleUserId = googleUser.id;

      // TODO: En el futuro, intercambiar el token de Google por un token del backend
      // final String? backendToken = await exchangeGoogleToken(googleUser.authentication.accessToken);
      // De ahí, se van a recibir los datos completos del usuario desde el backend/NFS/HDFS

      // Crear el modelo de usuario
      // Por ahora, sin idUsuario del backend ni rol asignado
      final UserModel user = UserModel(
        idUsuario: null, // Se asignará cuando se sincronice con backend
        nombre: displayName,
        correo: email,
        idRol: null, // Se asignará desde backend o NFS
        authProvider: 'google',
        activo: true,
        photoUrl: photoUrl,
        googleUserId: googleUserId,
      );

      // TODO: Cargar datos adicionales del usuario desde NFS/HDFS
      // final UserModel? completeUser = await loadUserDataFromNFS(email);
      // if (completeUser != null) return completeUser;

      print('[AuthRepository] UserModel creado exitosamente para: $email');
      return user;
    } catch (error) {
      // Manejar errores de autenticación
      print('[AuthRepository] ❌ Error en Google Sign-In: $error');
      print('[AuthRepository] Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// Cierra la sesión del usuario
  Future<void> signOut() async {
    print('[AuthRepository] Cerrando sesión...');
    try {
      // Cerrar sesión de Google si está autenticado con Google
      await _googleSignIn.signOut();

      // Eliminar el token JWT del almacenamiento local
      await ApiService.logout();

      print('[AuthRepository] Sesión cerrada exitosamente');
    } catch (error) {
      print('[AuthRepository] ❌ Error al cerrar sesión: $error');
    }
  }

  /// Verifica si hay un usuario actualmente autenticado
  /// Útil para verificar sesión al iniciar la app
  Future<UserModel?> getCurrentUser() async {
    print('[AuthRepository] Verificando usuario actual...');

    try {
      // Verificar si hay un token JWT guardado (login tradicional)
      final token = await ApiService.getToken();
      if (token != null) {
        print('[AuthRepository] Token JWT encontrado');
        // TODO: Validar el token con el backend y obtener los datos del usuario
        // Por ahora, retornamos null hasta implementar un endpoint /api/auth/me
        // que retorne los datos del usuario basado en el token
        print(
          '[AuthRepository] TODO: Implementar validación de token con backend',
        );
      }

      // Intentar obtener el usuario autenticado con Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signInSilently();

      if (googleUser == null) {
        print('[AuthRepository] No hay usuario autenticado');
        return null;
      }

      print(
        '[AuthRepository] Usuario de Google encontrado: ${googleUser.email}',
      );
      // Reconstruir el UserModel desde la sesión activa de Google
      return UserModel(
        nombre: googleUser.displayName ?? 'Usuario',
        correo: googleUser.email,
        authProvider: 'google',
        activo: true,
        photoUrl: googleUser.photoUrl,
        googleUserId: googleUser.id,
      );
    } catch (error) {
      print('[AuthRepository] Error al obtener usuario actual: $error');
      return null;
    }
  }

  // ============================================================================
  // MÉTODOS PREPARADOS PARA INTEGRACIÓN FUTURA CON BACKEND Y NFS/HDFS
  // ============================================================================

  /// Intercambia el token de Google por un token del backend
  Future<String?> exchangeGoogleToken(String googleToken) async {
    // Mock: retornar null por ahora
    return null;
  }

  /// Carga los datos completos del usuario desde NFS/HDFS
  Future<UserModel?> loadUserDataFromNFS(String userId) async {
    // Mock: retornar null por ahora
    return null;
  }

  /// Sincroniza los datos del usuario local con el backend/NFS
  Future<bool> syncUserData(UserModel user) async {
    // Mock: retornar true por ahora
    return true;
  }
}
