import 'package:flutter/foundation.dart';
import 'package:audit_cloud_app/data/models/user_model.dart';
import 'package:audit_cloud_app/data/repositories/auth_repository.dart';

/// Provider que maneja el estado de autenticación
/// Notifica a la UI sobre cambios en el estado del usuario
/// Delega toda la lógica de autenticación al AuthRepository
class AuthProvider extends ChangeNotifier {
  // Repository que maneja la lógica de autenticación
  final AuthRepository _authRepository = AuthRepository();

  // Estado del usuario actual
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Indica si el usuario está autenticado
  bool get isAuthenticated => _currentUser != null;

  /// Constructor que verifica si hay una sesión activa al iniciar
  AuthProvider() {
    _checkCurrentUser();
  }

  /// Verifica si hay un usuario con sesión activa
  /// Se ejecuta al iniciar la aplicación
  Future<void> _checkCurrentUser() async {
    print('[AuthProvider] Verificando usuario actual...');
    _setLoading(true);
    try {
      _currentUser = await _authRepository.getCurrentUser();
      if (_currentUser != null) {
        print(
          '[AuthProvider] Usuario existente encontrado: ${_currentUser!.correo}',
        );
      } else {
        print('[AuthProvider] No hay sesión activa');
      }
      notifyListeners();
    } catch (error) {
      print('[AuthProvider] ❌ Error al verificar usuario actual: $error');
    } finally {
      _setLoading(false);
    }
  }

  /// Realiza el login con Google Sign-In
  /// Retorna true si el login fue exitoso, false en caso contrario
  Future<bool> loginWithGoogle() async {
    print('[AuthProvider] Iniciando loginWithGoogle...');
    _setLoading(true);
    try {
      // Delegar autenticación al repository
      final UserModel? user = await _authRepository.signInWithGoogle();

      if (user != null) {
        print('[AuthProvider] ✅ Login exitoso para: ${user.correo}');
        _currentUser = user;
        notifyListeners();
        return true;
      } else {
        // Login cancelado o falló
        print('[AuthProvider] Login cancelado o falló (user es null)');
        return false;
      }
    } catch (error) {
      print('[AuthProvider] ❌ Error en loginWithGoogle: $error');
      print('[AuthProvider] Stack trace: ${StackTrace.current}');
      return false;
    } finally {
      print('[AuthProvider] Finalizando login, isLoading = false');
      _setLoading(false);
    }
  }

  /// Cierra la sesión del usuario actual
  Future<void> logout() async {
    print('[AuthProvider] Cerrando sesión del usuario...');
    _setLoading(true);
    try {
      await _authRepository.signOut();
      _currentUser = null;
      print('[AuthProvider] Sesión cerrada, usuario = null');
      notifyListeners();
    } catch (error) {
      print('[AuthProvider] ❌ Error en logout: $error');
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza el estado de carga y notifica a los listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ============================================================================
  // MÉTODOS PREPARADOS PARA INTEGRACIÓN FUTURA CON BACKEND
  // ============================================================================

  /// Actualiza los datos del usuario desde el backend/NFS
  /// Útil para refrescar el perfil del usuario
  Future<void> refreshUserData() async {
    if (_currentUser == null) return;

    _setLoading(true);
    try {
      // TODO: Implementar cuando el backend esté listo
      // final UserModel? updatedUser = await _authRepository.loadUserDataFromNFS(
      //   _currentUser!.correo,
      // );
      //
      // if (updatedUser != null) {
      //   _currentUser = updatedUser;
      //   notifyListeners();
      // }
    } catch (error) {
      print('Error al refrescar datos del usuario: $error');
    } finally {
      _setLoading(false);
    }
  }

  /// Actualiza el perfil del usuario y sincroniza con backend
  Future<bool> updateUserProfile(UserModel updatedUser) async {
    _setLoading(true);
    try {
      // TODO: Implementar cuando el backend esté listo
      // final bool success = await _authRepository.syncUserData(updatedUser);
      //
      // if (success) {
      //   _currentUser = updatedUser;
      //   notifyListeners();
      //   return true;
      // }
      // return false;

      // Mock: actualizar localmente por ahora
      _currentUser = updatedUser;
      notifyListeners();
      return true;
    } catch (error) {
      print('Error al actualizar perfil: $error');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Intercambia el token de Google por un token del backend
  /// Se llamará después de un login exitoso cuando el backend esté listo
  Future<void> exchangeTokenWithBackend(String googleToken) async {
    try {
      // TODO: Implementar cuando el backend esté listo
      // final String? backendToken = await _authRepository.exchangeGoogleToken(googleToken);
      //
      // if (backendToken != null && _currentUser != null) {
      //   _currentUser = _currentUser!.copyWith(backendToken: backendToken);
      //   notifyListeners();
      // }
    } catch (error) {
      print('Error al intercambiar token: $error');
    }
  }
}
