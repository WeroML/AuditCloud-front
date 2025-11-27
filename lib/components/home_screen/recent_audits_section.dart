import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/home_screen/audit_card.dart';
import 'package:audit_cloud_app/screens/all_audits/all_audits_screen.dart';

class RecentAuditsSection extends StatelessWidget {
  const RecentAuditsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Auditorías Recientes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.textPrimary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AllAuditsScreen(),
                  ),
                );
              },
              child: Text(
                'Ver todas',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(AppColors.primaryBlue),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        AuditCard(
          auditName: 'Auditoría Ambiental - Planta Norte',
          company: 'EcoTech Industries',
          status: 'En Progreso',
          date: '15 Nov 2025',
          progress: 0.65,
          statusColor: AppColors.statusInProgress,
        ),
        AuditCard(
          auditName: 'Evaluación de Emisiones',
          company: 'GreenPower S.A.',
          status: 'Completada',
          date: '10 Nov 2025',
          progress: 1.0,
          statusColor: AppColors.statusCompleted,
        ),
        AuditCard(
          auditName: 'Auditoría de Residuos',
          company: 'NatureCorp',
          status: 'Pendiente',
          date: '20 Nov 2025',
          progress: 0.0,
          statusColor: AppColors.statusPending,
        ),
        AuditCard(
          auditName: 'Certificación ISO 14001',
          company: 'Sustainable Ltd.',
          status: 'En Progreso',
          date: '12 Nov 2025',
          progress: 0.45,
          statusColor: AppColors.statusInProgress,
        ),
      ],
    );
  }
}
