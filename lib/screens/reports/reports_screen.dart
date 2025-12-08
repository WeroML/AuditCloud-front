import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/components/reports_screen/reports_appbar.dart';
import 'package:audit_cloud_app/components/reports_screen/reports_stats.dart';
import 'package:audit_cloud_app/components/reports_screen/reports_list.dart';

/// Pantalla de Reportes para el Supervisor
/// Muestra todos los reportes finales de las auditorías
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  @override
  void initState() {
    super.initState();

    // Cargar reportes después de que el frame se haya renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final supervisorProvider = Provider.of<SupervisorProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final idRol = authProvider.currentUser?.idRol;

      if (idRol == 1) {
        // Supervisor
        print('[ReportsScreen] Cargando reportes para Supervisor...');
        supervisorProvider.refrescarReportes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.backgroundColor),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar personalizado
            const ReportsAppbar(),

            // Contenido principal con scroll
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final supervisorProvider = Provider.of<SupervisorProvider>(
                    context,
                    listen: false,
                  );
                  await supervisorProvider.refrescarReportes();
                },
                child: const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estadísticas de reportes
                        ReportsStats(),
                        SizedBox(height: 20),

                        // Lista de reportes
                        ReportsList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
