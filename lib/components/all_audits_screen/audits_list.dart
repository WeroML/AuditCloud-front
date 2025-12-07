import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/home_screen/audit_card.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';

class AuditsList extends StatelessWidget {
  final int? userRole;

  const AuditsList({super.key, this.userRole});

  @override
  Widget build(BuildContext context) {
    // Renderizar según el rol del usuario
    switch (userRole) {
      case 2: // AUDITOR
        return _buildAuditorAuditsList(context);
      case 1: // SUPERVISOR
        return _buildSupervisorAuditsList(context);
      case 3: // CLIENTE
        return _buildClienteAuditsList(context);
      default:
        return _buildEmptyList();
    }
  }

  // Lista de auditorías para Auditor
  Widget _buildAuditorAuditsList(BuildContext context) {
    return Consumer<AuditorProvider>(
      builder: (context, auditorProvider, child) {
        final auditorias = auditorProvider.getAuditoriasOrdenadas();

        if (auditorias.isEmpty) {
          return _buildEmptyState('No tienes auditorías asignadas');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ordenadas por fecha (${auditorias.length} auditorías)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
            ...auditorias.map((auditoria) {
              final statusColor = _getStatusColor(auditoria.idEstado);
              final statusName = auditorProvider.getNombreEstado(
                auditoria.idEstado,
              );
              final fecha = auditoria.fechaInicio ?? auditoria.creadaEn;
              final dateStr = fecha != null ? _formatDate(fecha) : 'Sin fecha';
              final progress = _getProgress(auditoria.idEstado);
              final companyName = auditoria.clienteEmpresa ?? 'Empresa Cliente';

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

  // Lista de auditorías para Supervisor (usa SupervisorProvider)
  Widget _buildSupervisorAuditsList(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        final auditorias = supervisorProvider.getAuditoriasOrdenadas();

        if (auditorias.isEmpty) {
          return _buildEmptyState('No hay auditorías registradas');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ordenadas por fecha (${auditorias.length} auditorías)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
            ...auditorias.map((auditoria) {
              final statusColor = _getStatusColor(auditoria.idEstado);
              final statusName = supervisorProvider.getNombreEstado(
                auditoria.idEstado,
              );
              final fecha = auditoria.fechaInicio ?? auditoria.creadaEn;
              final dateStr = fecha != null ? _formatDate(fecha) : 'Sin fecha';
              final progress = _getProgress(auditoria.idEstado);
              final companyName = auditoria.clienteEmpresa ?? 'Empresa Cliente';

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

  // Lista de auditorías para Cliente (TODO: implementar con ClienteProvider)
  Widget _buildClienteAuditsList(BuildContext context) {
    // TODO: Consumir ClienteProvider cuando esté creado
    return _buildEmptyState('Funcionalidad de Cliente en desarrollo');
  }

  // Estado vacío
  Widget _buildEmptyList() {
    return _buildEmptyState('No hay auditorías disponibles');
  }

  Widget _buildEmptyState(String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Auditorías',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(32),
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
              message,
              style: TextStyle(
                fontSize: 14,
                color: Color(AppColors.textSecondary),
              ),
            ),
          ),
        ),
      ],
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
