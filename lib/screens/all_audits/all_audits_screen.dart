import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/all_audits_screen/all_audits_appbar.dart';
import 'package:audit_cloud_app/components/all_audits_screen/quick_stats_card.dart';
import 'package:audit_cloud_app/components/all_audits_screen/audits_list.dart';

class AllAuditsScreen extends StatefulWidget {
  const AllAuditsScreen({super.key});

  @override
  State<AllAuditsScreen> createState() => _AllAuditsScreenState();
}

class _AllAuditsScreenState extends State<AllAuditsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.backgroundColor),
      appBar: const AllAuditsAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // Sección de estadísticas rápidas
          QuickStatsCard(
            totalValue: '12',
            completedValue: '6',
            inProgressValue: '4',
            pendingValue: '2',
          ),
          SizedBox(height: 24),

          // Lista de auditorías
          AuditsList(),
        ],
      ),
    );
  }
}
