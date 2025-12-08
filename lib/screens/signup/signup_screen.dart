import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/screens/home/home_screen.dart';
import 'package:audit_cloud_app/screens/signup/google_profile_completion_screen.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nombreEmpresaController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _estadoController = TextEditingController();
  final _rfcController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nombreEmpresaController.dispose();
    _ciudadController.dispose();
    _estadoController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  /// Maneja el registro tradicional (nombre, correo y contraseña)
  Future<void> _handleSignup() async {
    print('[SignupScreen] Botón de registro tradicional presionado');

    // Validar que los campos obligatorios no estén vacíos
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty ||
        _nombreEmpresaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Por favor completa todos los campos obligatorios',
          ),
          backgroundColor: Color(AppColors.statusError),
        ),
      );
      return;
    }

    // Validar que las contraseñas coincidan
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Las contraseñas no coinciden'),
          backgroundColor: Color(AppColors.statusError),
        ),
      );
      return;
    }

    // Validar longitud mínima de contraseña
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('La contraseña debe tener al menos 6 caracteres'),
          backgroundColor: Color(AppColors.statusError),
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Llamar al provider para hacer registro con credenciales
    final result = await authProvider.signupWithCredentials(
      nombre: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      nombreEmpresa: _nombreEmpresaController.text.trim(),
      ciudad: _ciudadController.text.trim().isEmpty
          ? null
          : _ciudadController.text.trim(),
      estado: _estadoController.text.trim().isEmpty
          ? null
          : _estadoController.text.trim(),
      rfc: _rfcController.text.trim().isEmpty
          ? null
          : _rfcController.text.trim(),
    );

    if (result.success && mounted) {
      // Registro exitoso, navegar a HomeScreen
      print('[SignupScreen] Navegando a HomeScreen...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (!result.success && mounted) {
      // Mostrar mensaje de error
      print('[SignupScreen] Mostrando SnackBar de error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Error en el registro'),
          backgroundColor: Color(AppColors.statusError),
        ),
      );
    }
  }

  /// Maneja el registro con Google
  Future<void> _handleGoogleSignup() async {
    print('[SignupScreen] Botón de Google Sign-up presionado');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    print('[SignupScreen] Llamando a authProvider.signupWithGoogle()');
    final result = await authProvider.signupWithGoogle();

    print('[SignupScreen] Resultado del registro: ${result.success}');
    if (result.success && result.requireCompanyInfo && mounted) {
      // Requiere completar información de empresa
      print('[SignupScreen] Navegando a GoogleProfileCompletionScreen...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GoogleProfileCompletionScreen(),
        ),
      );
    } else if (result.success && !result.requireCompanyInfo && mounted) {
      // Registro exitoso y completo, navegar a HomeScreen
      print('[SignupScreen] Navegando a HomeScreen...');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (!result.success && mounted) {
      // Mostrar mensaje de error
      print('[SignupScreen] Mostrando SnackBar de error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message ?? 'Registro cancelado o falló'),
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
                      'Crea tu cuenta',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Formulario de registro
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
                            'Registro',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(AppColors.textPrimary),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Campo de nombre completo
                          Text(
                            'Nombre Completo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            enabled: !authProvider.isLoading,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: 'Juan Pérez',
                              hintStyle: TextStyle(
                                color: Color(AppColors.textLight),
                              ),
                              prefixIcon: Icon(
                                Icons.person_outline,
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
                            controller: _emailController,
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
                              hintText: 'Mínimo 6 caracteres',
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
                          const SizedBox(height: 20),

                          // Campo de confirmar contraseña
                          Text(
                            'Confirmar Contraseña',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            enabled: !authProvider.isLoading,
                            decoration: InputDecoration(
                              hintText: 'Repite tu contraseña',
                              hintStyle: TextStyle(
                                color: Color(AppColors.textLight),
                              ),
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Color(AppColors.primaryGreen),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Color(AppColors.textSecondary),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
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
                          const SizedBox(height: 24),

                          // Divider - Datos de Empresa
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
                                  'Datos de tu Empresa',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
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

                          // Campo de Nombre de Empresa
                          Text(
                            'Nombre de la Empresa *',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nombreEmpresaController,
                            enabled: !authProvider.isLoading,
                            decoration: InputDecoration(
                              hintText: 'Ej: Mi Empresa S.A. de C.V.',
                              hintStyle: TextStyle(
                                color: Color(AppColors.textLight),
                              ),
                              prefixIcon: Icon(
                                Icons.business,
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

                          // Campo de Ciudad (Opcional)
                          Text(
                            'Ciudad',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _ciudadController,
                            enabled: !authProvider.isLoading,
                            decoration: InputDecoration(
                              hintText: 'Ej: Ciudad de México',
                              hintStyle: TextStyle(
                                color: Color(AppColors.textLight),
                              ),
                              prefixIcon: Icon(
                                Icons.location_city,
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

                          // Campo de Estado (Opcional)
                          Text(
                            'Estado',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _estadoController,
                            enabled: !authProvider.isLoading,
                            decoration: InputDecoration(
                              hintText: 'Ej: CDMX',
                              hintStyle: TextStyle(
                                color: Color(AppColors.textLight),
                              ),
                              prefixIcon: Icon(
                                Icons.map,
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

                          // Campo de RFC (Opcional)
                          Text(
                            'RFC (Opcional)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.textSecondary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _rfcController,
                            enabled: !authProvider.isLoading,
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 13,
                            decoration: InputDecoration(
                              hintText: 'Ej: ABC123456XYZ',
                              hintStyle: TextStyle(
                                color: Color(AppColors.textLight),
                              ),
                              prefixIcon: Icon(
                                Icons.badge,
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
                              counterText: '',
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Botón de registro tradicional
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _handleSignup,
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
                                      'Crear Cuenta',
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
                                  : _handleGoogleSignup,
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
                                          'Registrarse con Google',
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

                    // Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Ya tienes cuenta? ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(AppColors.textSecondary),
                          ),
                        ),
                        TextButton(
                          onPressed: authProvider.isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          child: Text(
                            'Inicia Sesión',
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
