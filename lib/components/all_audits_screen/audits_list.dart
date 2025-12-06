import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/home_screen/audit_card.dart';

class AuditsList extends StatelessWidget {
  const AuditsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ordenadas por fecha',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 12),

        // Auditorías más recientes primero
        AuditCard(
          auditName: 'Auditoría de Residuos',
          company: 'NatureCorp',
          status: 'Pendiente',
          date: '20 Nov 2025',
          progress: 0.0,
          statusColor: AppColors.statusPending,
        ),
        AuditCard(
          auditName: 'Auditoría Ambiental - Planta Norte',
          company: 'EcoTech Industries',
          status: 'En Progreso',
          date: '15 Nov 2025',
          progress: 0.65,
          statusColor: AppColors.statusInProgress,
        ),
        AuditCard(
          auditName: 'Certificación ISO 14001',
          company: 'Sustainable Ltd.',
          status: 'En Progreso',
          date: '12 Nov 2025',
          progress: 0.45,
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
          auditName: 'Auditoría de Agua Residual',
          company: 'AquaClean Inc.',
          status: 'Completada',
          date: '08 Nov 2025',
          progress: 1.0,
          statusColor: AppColors.statusCompleted,
        ),
        AuditCard(
          auditName: 'Control de Calidad Ambiental',
          company: 'EcoTech Industries',
          status: 'Completada',
          date: '05 Nov 2025',
          progress: 1.0,
          statusColor: AppColors.statusCompleted,
        ),
        AuditCard(
          auditName: 'Evaluación de Impacto Ambiental',
          company: 'GreenBuilders Co.',
          status: 'En Progreso',
          date: '03 Nov 2025',
          progress: 0.75,
          statusColor: AppColors.statusInProgress,
        ),
        AuditCard(
          auditName: 'Auditoría Energética',
          company: 'PowerGreen Ltd.',
          status: 'Completada',
          date: '01 Nov 2025',
          progress: 1.0,
          statusColor: AppColors.statusCompleted,
        ),
        AuditCard(
          auditName: 'Gestión de Residuos Peligrosos',
          company: 'SafeWaste Corp.',
          status: 'En Progreso',
          date: '28 Oct 2025',
          progress: 0.30,
          statusColor: AppColors.statusInProgress,
        ),
        AuditCard(
          auditName: 'Certificación Carbono Neutro',
          company: 'EcoTech Industries',
          status: 'Completada',
          date: '25 Oct 2025',
          progress: 1.0,
          statusColor: AppColors.statusCompleted,
        ),
        AuditCard(
          auditName: 'Auditoría de Biodiversidad',
          company: 'NatureCorp',
          status: 'Pendiente',
          date: '22 Oct 2025',
          progress: 0.0,
          statusColor: AppColors.statusPending,
        ),
        AuditCard(
          auditName: 'Evaluación de Ruido Ambiental',
          company: 'SoundControl Inc.',
          status: 'Completada',
          date: '20 Oct 2025',
          progress: 1.0,
          statusColor: AppColors.statusCompleted,
        ),
      ],
    );
  }
}
