import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/screens/home/home_screen.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';

class GoogleProfileCompletionScreen extends StatefulWidget {
  const GoogleProfileCompletionScreen({super.key});

  @override
  State<GoogleProfileCompletionScreen> createState() =>
      _GoogleProfileCompletionScreenState();
}

class _GoogleProfileCompletionScreenState
    extends State<GoogleProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreEmpresaController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _estadoController = TextEditingController();
  final _rfcController = TextEditingController();

  @override
  void dispose() {
    _nombreEmpresaController.dispose();
    _ciudadController.dispose();
    _estadoController.dispose();
    _rfcController.dispose();
    super.dispose();
  }

  Future<void> _handleCompleteProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.completeGoogleProfile(
      nombreEmpresa: _nombreEmpresaController.text.trim(),
      ciudad: _ciudadController.text.trim(),
      estado: _estadoController.text.trim(),
      rfc: _rfcController.text.trim().isEmpty
          ? null
          : _rfcController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al completar el perfil'),
          backgroundColor: Color(AppColors.statusError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Color(AppColors.backgroundColor),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 109, 174, 216),
                          Color.fromARGB(255, 57, 53, 177),
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
                    'Completa tu Perfil',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Necesitamos algunos datos de tu empresa',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(AppColors.textSecondary),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Formulario
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
                        // Nombre de la Empresa
                        Text(
                          'Nombre de la Empresa *',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
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
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre de la empresa es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Ciudad
                        Text(
                          'Ciudad *',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
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
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La ciudad es obligatoria';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Estado
                        Text(
                          'Estado *',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
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
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El estado es obligatorio';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // RFC (Opcional)
                        Text(
                          'RFC (Opcional)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(AppColors.textSecondary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
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
                            counterText: '',
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Botón Completar Perfil
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : _handleCompleteProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(AppColors.primaryBlue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Completar Perfil',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
