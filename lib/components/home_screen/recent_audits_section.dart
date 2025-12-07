import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/home_screen/audit_card.dart';
import 'package:audit_cloud_app/screens/all_audits/all_audits_screen.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';

class RecentAuditsSection extends StatelessWidget {
  const RecentAuditsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuditorProvider>(
      builder: (context, auditorProvider, child) {
        // Obtener las auditorías más recientes (hasta 4)
        final auditorias = auditorProvider.getAuditoriasOrdenadas();
        final recentAudits = auditorias.take(4).toList();

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

            // Mostrar auditorías reales o mensaje de "sin datos"
            if (recentAudits.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(AppColors.cardBackground),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(AppColors.shadowColor),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'No hay auditorías asignadas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(AppColors.textSecondary),
                    ),
                  ),
                ),
              )
            else
              ...recentAudits.map((auditoria) {
                // Mapear estado a color y nombre
                final statusColor = _getStatusColor(auditoria.idEstado);
                final statusName = auditorProvider.getNombreEstado(
                  auditoria.idEstado,
                );

                // Formatear fecha (usar fecha_inicio o creada_en como fallback)
                final fecha = auditoria.fechaInicio ?? auditoria.creadaEn;
                final dateStr = fecha != null
                    ? _formatDate(fecha)
                    : 'Sin fecha';

                // Calcular progreso basado en estado
                final progress = _getProgress(auditoria.idEstado);

                // Obtener nombre de empresa (usar clienteEmpresa del backend o fallback)
                final companyName =
                    auditoria.clienteEmpresa ?? 'Empresa Cliente';

                return AuditCard(
                  auditName: 'Auditoría #${auditoria.idAuditoria}',
                  company: companyName,
                  status: statusName,
                  date: dateStr,
                  progress: progress,
                  statusColor: statusColor,
                );
              }),
          ],
        );
      },
    );
  }

  int _getStatusColor(int idEstado) {
    switch (idEstado) {
      case 1: // CREADA
        return AppColors.statusPending;
      case 2: // EN_PROCESO
        return AppColors.statusInProgress;
      case 3: // FINALIZADA
        return AppColors.statusCompleted;
      default:
        return AppColors.textSecondary;
    }
  }

  double _getProgress(int idEstado) {
    switch (idEstado) {
      case 1: // CREADA
        return 0.0;
      case 2: // EN_PROCESO
        return 0.5;
      case 3: // FINALIZADA
        return 1.0;
      default:
        return 0.0;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
