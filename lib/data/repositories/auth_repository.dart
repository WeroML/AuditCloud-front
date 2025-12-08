import 'package:google_sign_in/google_sign_in.dart';
import 'package:audit_cloud_app/data/models/user_model.dart';
import 'package:audit_cloud_app/services/api_service.dart';

/// Resultado de una operación de autenticación
class AuthResult {
  final bool success;
  final UserModel? user;
  final String? message;
  final bool requireCompanyInfo;

  AuthResult({
    required this.success,
    this.user,
    this.message,
    this.requireCompanyInfo = false,
  });
}

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
        activo: true,
        photoUrl: usuarioData['foto_url'] as String?,
      );

      print('[AuthRepository] UserModel creado: ${user.nombre}');
      return user;
    } catch (e) {
      print('[AuthRepository] ❌ Error en login: $e');
      return null;
    }
  }

  /// Registro tradicional con nombre, correo y contraseña
  /// Llama al endpoint POST /api/cliente/registro del backend
  Future<AuthResult> signUpWithCredentials({
    required String nombre,
    required String email,
    required String password,
    required String nombreEmpresa,
    String? ciudad,
    String? estado,
    String? rfc,
  }) async {
    print('[AuthRepository] Iniciando registro con credenciales...');
    print('[AuthRepository] Email: $email');
    print('[AuthRepository] Nombre: $nombre');
    print('[AuthRepository] Empresa: $nombreEmpresa');

    try {
      // Llamar al endpoint de registro del backend
      final responseData = await ApiService.signup(
        nombre: nombre,
        correo: email,
        password: password,
        nombreEmpresa: nombreEmpresa,
        ciudad: ciudad,
        estado: estado,
        rfc: rfc,
      );

      if (responseData == null) {
        print('[AuthRepository] ❌ Registro falló - respuesta null');
        return AuthResult(
          success: false,
          message: 'Error en el registro. Intenta nuevamente.',
        );
      }

      print('[AuthRepository] ✅ Registro exitoso');
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
        activo: true,
        photoUrl: usuarioData['foto_url'] as String?,
      );

      print('[AuthRepository] UserModel creado: ${user.nombre}');
      return AuthResult(success: true, user: user);
    } catch (e) {
      print('[AuthRepository] ❌ Error en registro: $e');
      return AuthResult(
        success: false,
        message: 'Error de conexión. Verifica tu internet.',
      );
    }
  }

  // Instancia de Google Sign-In
  // Web Client ID obtenido de google-services.json (client_type: 3)
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
        '417831327586-01dvdhj92iao6kgcfpkp20dkiseiv4bq.apps.googleusercontent.com',
  );

  /// Realiza el login con Google Sign-In y autentica con el backend
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
      print('[AuthRepository] Display Name: ${googleUser.displayName}');
      print('[AuthRepository] ID: ${googleUser.id}');
      print('[AuthRepository] Photo URL: ${googleUser.photoUrl}');

      // Obtener la autenticación de Google para obtener el idToken
      print('[AuthRepository] Obteniendo GoogleSignInAuthentication...');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('[AuthRepository] GoogleSignInAuthentication obtenido');
      print(
        '[AuthRepository] accessToken presente: ${googleAuth.accessToken != null}',
      );
      print('[AuthRepository] idToken presente: ${googleAuth.idToken != null}');

      if (googleAuth.accessToken != null) {
        print(
          '[AuthRepository] accessToken (primeros 20 chars): ${googleAuth.accessToken!.substring(0, 20)}...',
        );
      }
      if (googleAuth.idToken != null) {
        print(
          '[AuthRepository] idToken (primeros 20 chars): ${googleAuth.idToken!.substring(0, 20)}...',
        );
      }

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print('[AuthRepository] ❌ No se pudo obtener el idToken de Google');
        print('[AuthRepository] Esto puede deberse a:');
        print(
          '[AuthRepository] 1. Falta configurar serverClientId en GoogleSignIn',
        );
        print(
          '[AuthRepository] 2. google-services.json no está configurado correctamente',
        );
        print(
          '[AuthRepository] 3. El proyecto de Firebase no tiene OAuth configurado',
        );
        return null;
      }

      print(
        '[AuthRepository] idToken obtenido exitosamente, autenticando con backend...',
      );

      // Autenticar con el backend enviando el idToken
      final responseData = await ApiService.loginWithGoogle(idToken);

      if (responseData == null) {
        print('[AuthRepository] ❌ Login con Google falló en el backend');
        return null;
      }

      // Verificar si se requiere completar información de empresa
      if (responseData['require_company_info'] == true) {
        print(
          '[AuthRepository] ⚠️ Se requiere completar información de empresa',
        );
        // Retornar null para que el provider sepa que debe mostrar el formulario
        // El token ya está guardado, pero el usuario no está completo
        return null;
      }

      print('[AuthRepository] ✅ Login con Google exitoso');
      print('[AuthRepository] Token guardado en ApiService');

      // Extraer datos del usuario de la respuesta
      final usuarioData = responseData['usuario'] as Map<String, dynamic>;

      // Crear el UserModel desde la respuesta del backend
      final user = UserModel.fromJson(usuarioData);

      print('[AuthRepository] UserModel creado: ${user.nombre}');
      return user;
    } catch (error) {
      // Manejar errores de autenticación
      print('[AuthRepository] ❌ Error en Google Sign-In: $error');
      print('[AuthRepository] Stack trace: ${StackTrace.current}');
      return null;
    }
  }

  /// Realiza el registro con Google Sign-In
  /// Similar a signInWithGoogle pero para propósitos de registro
  /// El backend creará automáticamente el usuario si no existe
  Future<AuthResult> signUpWithGoogle() async {
    print('[AuthRepository] Iniciando Google Sign-Up...');
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // El usuario canceló el registro
        print('[AuthRepository] Registro cancelado por el usuario');
        return AuthResult(success: false, message: 'Registro cancelado');
      }

      print('[AuthRepository] Usuario de Google obtenido: ${googleUser.email}');

      // Obtener la autenticación de Google para obtener el idToken
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print('[AuthRepository] ❌ No se pudo obtener el idToken de Google');
        return AuthResult(
          success: false,
          message: 'Error en la autenticación con Google',
        );
      }

      print(
        '[AuthRepository] idToken obtenido exitosamente, registrando en backend...',
      );

      // Registrar en el backend enviando el idToken
      // El backend creará el usuario automáticamente si no existe
      final responseData = await ApiService.loginWithGoogle(idToken);

      if (responseData == null) {
        print('[AuthRepository] ❌ Registro con Google falló en el backend');
        return AuthResult(
          success: false,
          message: 'Error en el registro. Intenta nuevamente.',
        );
      }

      // Verificar si se requiere completar información de empresa
      if (responseData['require_company_info'] == true) {
        print(
          '[AuthRepository] ⚠️ Usuario creado, requiere completar información de empresa',
        );
        return AuthResult(
          success: true,
          requireCompanyInfo: true,
          message: 'Completa la información de tu empresa',
        );
      }

      print('[AuthRepository] ✅ Registro con Google exitoso');

      // Extraer datos del usuario de la respuesta
      final usuarioData = responseData['usuario'] as Map<String, dynamic>;
      final user = UserModel.fromJson(usuarioData);

      print('[AuthRepository] UserModel creado: ${user.nombre}');
      return AuthResult(success: true, user: user);
    } catch (error) {
      print('[AuthRepository] ❌ Error en Google Sign-Up: $error');
      return AuthResult(
        success: false,
        message: 'Error de conexión. Verifica tu internet.',
      );
    }
  }

  /// Completa el perfil de un usuario autenticado con Google
  /// Envía la información de la empresa al backend
  Future<bool> completeGoogleProfile({
    required String nombreEmpresa,
    required String ciudad,
    required String estado,
    String? rfc,
  }) async {
    print('[AuthRepository] Completando perfil de Google...');
    try {
      final responseData = await ApiService.completeProfile(
        nombreEmpresa: nombreEmpresa,
        ciudad: ciudad,
        estado: estado,
        rfc: rfc,
      );

      if (responseData != null) {
        print('[AuthRepository] ✅ Perfil completado exitosamente');
        return true;
      } else {
        print('[AuthRepository] ❌ Error al completar perfil');
        return false;
      }
    } catch (e) {
      print('[AuthRepository] ❌ Error en completeGoogleProfile: $e');
      return false;
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
      // Verificar si hay un token JWT guardado
      final token = await ApiService.getToken();
      if (token != null) {
        print('[AuthRepository] Token JWT encontrado');
        // TODO: Implementar endpoint /api/auth/me en el backend
        // para validar el token y obtener los datos actualizados del usuario
        // Por ahora, si hay token, intentamos reautenticar con Google silenciosamente
      }

      // Intentar obtener el usuario autenticado con Google Sign-In silenciosamente
      final GoogleSignInAccount? googleUser = await _googleSignIn
          .signInSilently();

      if (googleUser == null) {
        print('[AuthRepository] No hay usuario autenticado con Google');

        // Si hay token pero no sesión de Google, el usuario se autenticó con credenciales
        if (token != null) {
          print(
            '[AuthRepository] Usuario autenticado con credenciales (token JWT presente)',
          );
          // TODO: Obtener datos del usuario desde el backend con el token
          // Por ahora retornamos null hasta implementar /api/auth/me
        }

        return null;
      }

      print(
        '[AuthRepository] Usuario de Google encontrado: ${googleUser.email}',
      );

      // Obtener el idToken para reautenticar con el backend
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print(
          '[AuthRepository] No se pudo obtener idToken de la sesión activa',
        );
        return null;
      }

      // Reautenticar con el backend para obtener datos actualizados
      final responseData = await ApiService.loginWithGoogle(idToken);

      if (responseData != null && responseData['usuario'] != null) {
        final usuarioData = responseData['usuario'] as Map<String, dynamic>;
        return UserModel.fromJson(usuarioData);
      }

      // Si falla la reautenticación, retornar null
      return null;
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
