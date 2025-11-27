import 'package:google_sign_in/google_sign_in.dart';
import 'package:audit_cloud_app/data/models/user_model.dart';

/// Repository que maneja toda la lógica de autenticación
/// No depende de Provider ni de la capa de UI
/// Preparado para integración futura con backend y NFS/HDFS
class AuthRepository {
  // Instancia de Google Sign-In
  // MODIFICACIÓN: Se agregó el clientId manual para corregir el error ApiException: 10
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

      // Crear el modelo de usuario
      // Por ahora, sin idUsuario del backend ni rol asignado
      final UserModel user = UserModel(
        idUsuario: null, // Se asignará cuando se sincronice con backend
        nombre: displayName,
        correo: email,
        rol: null, // Se asignará desde backend o NFS
        authProvider: 'google',
        activo: true,
        photoUrl: photoUrl,
        googleUserId: googleUserId,
        backendToken: null, // Se asignará tras intercambio con backend
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
      await _googleSignIn.signOut();
      print('[AuthRepository] Sesión cerrada exitosamente');
    } catch (error) {
      print('[AuthRepository] ❌ Error al cerrar sesión: $error');
    }
  }

  /// Verifica si hay un usuario actualmente autenticado
  /// Útil para verificar sesión al iniciar la app
  Future<UserModel?> getCurrentUser() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signInSilently();

      if (googleUser == null) {
        return null;
      }

      // Reconstruir el UserModel desde la sesión activa
      return UserModel(
        nombre: googleUser.displayName ?? 'Usuario',
        correo: googleUser.email,
        authProvider: 'google',
        activo: true,
        photoUrl: googleUser.photoUrl,
        googleUserId: googleUser.id,
      );
    } catch (error) {
      print('Error al obtener usuario actual: $error');
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
