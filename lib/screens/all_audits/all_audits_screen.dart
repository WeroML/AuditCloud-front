import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/all_audits_screen/all_audits_appbar.dart';
import 'package:audit_cloud_app/components/all_audits_screen/quick_stats_card.dart';
import 'package:audit_cloud_app/components/all_audits_screen/audits_list.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';
import 'package:audit_cloud_app/data/providers/client_provider.dart';

class AllAuditsScreen extends StatefulWidget {
  const AllAuditsScreen({super.key});

  @override
  State<AllAuditsScreen> createState() => _AllAuditsScreenState();
}

class _AllAuditsScreenState extends State<AllAuditsScreen> {
  @override
  void initState() {
    super.initState();
    // Recargar auditorías al entrar a la pantalla según el rol
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;

      if (user != null) {
        if (user.idRol == 2 && user.idUsuario != null) {
          // Auditor: recargar auditorías asignadas
          final auditorProvider = Provider.of<AuditorProvider>(
            context,
            listen: false,
          );
          auditorProvider.refrescarAuditorias(user.idUsuario!);
        } else if (user.idRol == 1 && user.idEmpresa != null) {
          // Supervisor: recargar auditorías de la empresa
          final supervisorProvider = Provider.of<SupervisorProvider>(
            context,
            listen: false,
          );
          supervisorProvider.refrescarAuditorias(user.idEmpresa!);
        } else if (user.idRol == 3 && user.idUsuario != null) {
          // Cliente: recargar auditorías del cliente
          final clienteProvider = Provider.of<ClienteProvider>(
            context,
            listen: false,
          );
          clienteProvider.refrescarAuditorias(user.idUsuario!);
        }
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
          appBar: const AllAuditsAppBar(),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Sección de estadísticas rápidas (dinámicas según rol)
              QuickStatsCard(userRole: userRole),
              const SizedBox(height: 24),

              // Lista de auditorías (dinámica según rol)
              AuditsList(userRole: userRole),
            ],
          ),
        );
      },
    );
  }
}
