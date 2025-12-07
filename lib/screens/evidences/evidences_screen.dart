import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:audit_cloud_app/components/evidences_screen/evidences_appbar.dart';
import 'package:audit_cloud_app/components/evidences_screen/evidences_stats_card.dart';
import 'package:audit_cloud_app/components/evidences_screen/evidences_list.dart';

class EvidencesScreen extends StatefulWidget {
  const EvidencesScreen({super.key});

  @override
  State<EvidencesScreen> createState() => _EvidencesScreenState();
}

class _EvidencesScreenState extends State<EvidencesScreen> {
  @override
  void initState() {
    super.initState();
    print('[EvidencesScreen] 📸 initState ejecutado');

    // Cargar evidencias al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('[EvidencesScreen] 📌 PostFrameCallback ejecutándose...');

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final user = authProvider.currentUser;

        if (user != null && user.idRol == 2) {
          print('[EvidencesScreen] 👤 Usuario Auditor, cargando evidencias...');
          final auditorProvider = Provider.of<AuditorProvider>(
            context,
            listen: false,
          );
          // Cargar todas las evidencias del auditor (idAuditoria = 0)
          auditorProvider.cargarEvidencias(idAuditoria: 0);
        }
      } catch (e, stackTrace) {
        print('[EvidencesScreen] ❌ ERROR en PostFrameCallback: $e');
        print('[EvidencesScreen] 📍 Stack trace: $stackTrace');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        final userRole = user?.idRol;

        return Scaffold(
          backgroundColor: Color(AppColors.backgroundColor),
          appBar: const EvidencesAppBar(),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Sección de estadísticas rápidas (dinámicas según rol)
              EvidencesStatsCard(userRole: userRole),
              const SizedBox(height: 24),

              // Lista de evidencias (dinámica según rol)
              EvidencesList(userRole: userRole),
            ],
          ),
        );
      },
    );
  }
}
