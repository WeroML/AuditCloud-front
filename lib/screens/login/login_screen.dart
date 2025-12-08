import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/screens/home/home_screen.dart';
import 'package:audit_cloud_app/screens/signup/signup_screen.dart';
import 'package:audit_cloud_app/screens/signup/google_profile_completion_screen.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Maneja el login tradicional (usuario y contraseña)
  Future<void> _handleLogin() async {
    print('[LoginScreen] Botón de login tradicional presionado');

    // Validar que los campos no estén vacíos
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor completa todos los campos'),
          backgroundColor: Color(AppColors.statusError),
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Llamar al provider para hacer login con credenciales
    final bool success = await authProvider.loginWithCredentials(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      // Login exitoso, navegar a HomeScreen
      print('[LoginScreen] Navegando a HomeScreen...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (!success && mounted) {
      // Mostrar mensaje de error
      print('[LoginScreen] Mostrando SnackBar de error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Credenciales incorrectas'),
          backgroundColor: Color(AppColors.statusError),
        ),
      );
    }
  }

  /// Maneja el login con Google usando el AuthProvider
  Future<void> _handleGoogleLogin() async {
    print('[LoginScreen] Botón de Google presionado');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    print('[LoginScreen] Llamando a authProvider.loginWithGoogle()');
    // Llamar al provider para hacer login con Google
    final bool? result = await authProvider.loginWithGoogle();

    print('[LoginScreen] Resultado del login: $result');
    if (result == true && mounted) {
      // Login exitoso, navegar a HomeScreen
      print('[LoginScreen] Navegando a HomeScreen...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (result == null && mounted) {
      // Requiere completar información de empresa
      print('[LoginScreen] Navegando a GoogleProfileCompletionScreen...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GoogleProfileCompletionScreen(),
        ),
      );
    } else if (result == false && mounted) {
      // Mostrar mensaje de error o que se canceló
      print('[LoginScreen] Mostrando SnackBar de error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login cancelado o falló'),
          backgroundColor: Color(AppColors.statusError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.backgroundColor),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo y título
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 109, 174, 216), // Morado claro
                            Color.fromARGB(255, 57, 53, 177), // Morado oscuro
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Audit Cloud',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Control de Auditorías Ambientales',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Formulario de login
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Color(AppColors.cardBackground),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(AppColors.shadowColor),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(AppColors.textPrimary),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Campo de correo electrónico
                          Text(
                            'Correo Electrónico',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _usernameController,
                            enabled: !authProvider.isLoading,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'correo@ejemplo.com',
                              hintStyle: TextStyle(
                                color: Color(AppColors.textLight),
                              ),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Color(AppColors.primaryGreen),
                              ),
                              filled: true,
                              fillColor: Color(AppColors.backgroundColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Color(AppColors.borderLight),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Color(AppColors.primaryGreen),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Campo de contraseña
                          Text(
                            'Contraseña',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            enabled: !authProvider.isLoading,
                            decoration: InputDecoration(
                              hintText: 'Ingresa tu contraseña',
                              hintStyle: TextStyle(
                                color: Color(AppColors.textLight),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Color(AppColors.primaryGreen),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Color(AppColors.textSecondary),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Color(AppColors.backgroundColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Color(AppColors.borderLight),
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Color(AppColors.primaryGreen),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Olvidé mi contraseña
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () {
                                      // TODO: Implementar recuperación de contraseña
                                    },
                              child: Text(
                                '¿Olvidaste tu contraseña?',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(AppColors.primaryBlue),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Botón de login tradicional
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(AppColors.primaryGreen),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authProvider.isLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : const Text(
                                      'Iniciar Sesión',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Divider con texto
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Color(AppColors.borderLight),
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'o continúa con',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(AppColors.textSecondary),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Color(AppColors.borderLight),
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Botón de Google Sign-In
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _handleGoogleLogin,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Color(AppColors.textPrimary),
                                side: BorderSide(
                                  color: Color(AppColors.borderLight),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: authProvider.isLoading
                                  ? SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Color(AppColors.primaryGreen),
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          'https://www.google.com/favicon.ico',
                                          height: 24,
                                          width: 24,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.g_mobiledata,
                                                  size: 28,
                                                  color: Color(
                                                    AppColors.textPrimary,
                                                  ),
                                                );
                                              },
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Continuar con Google',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(AppColors.textSecondary),
                          ),
                        ),
                        TextButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },
                          child: Text(
                            'Regístrate',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(AppColors.primaryBlue),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
