import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/all_audits_screen/all_audits_appbar.dart';
import 'package:audit_cloud_app/components/all_audits_screen/quick_stats_card.dart';
import 'package:audit_cloud_app/components/all_audits_screen/audits_list.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';

class AllAuditsScreen extends StatefulWidget {
  const AllAuditsScreen({super.key});

  @override
  State<AllAuditsScreen> createState() => _AllAuditsScreenState();
}

class _AllAuditsScreenState extends State<AllAuditsScreen> {
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
