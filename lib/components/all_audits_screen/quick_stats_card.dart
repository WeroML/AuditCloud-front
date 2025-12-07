import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';
import 'package:audit_cloud_app/data/providers/client_provider.dart';

class QuickStatsCard extends StatelessWidget {
  final int? userRole;

  const QuickStatsCard({super.key, this.userRole});

  @override
  Widget build(BuildContext context) {
    // Renderizar según el rol del usuario
    switch (userRole) {
      case 2: // AUDITOR
        return _buildAuditorStats(context);
      case 1: // SUPERVISOR
        return _buildSupervisorStats(context);
      case 3: // CLIENTE
        return _buildClienteStats(context);
      default:
        return _buildEmptyStats();
    }
  }

  // Estadísticas para Auditor (usa AuditorProvider)
  Widget _buildAuditorStats(BuildContext context) {
    return Consumer<AuditorProvider>(
      builder: (context, auditorProvider, child) {
        final total = auditorProvider.totalAuditorias;
        final finalizadas = auditorProvider.auditoriasFinalizadas;
        final enProceso = auditorProvider.auditoriasEnProceso;
        final creadas = auditorProvider.auditoriasCreadas;

        return _buildStatsContainer(
          totalValue: total.toString(),
          completedValue: finalizadas.toString(),
          inProgressValue: enProceso.toString(),
          pendingValue: creadas.toString(),
        );
      },
    );
  }

  // Estadísticas para Supervisor (usa SupervisorProvider)
  Widget _buildSupervisorStats(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        final total = supervisorProvider.totalAuditorias;
        final finalizadas = supervisorProvider.auditoriasFinalizadas;
        final enProceso = supervisorProvider.auditoriasEnProceso;
        final creadas = supervisorProvider.auditoriasCreadas;

        return _buildStatsContainer(
          totalValue: total.toString(),
          completedValue: finalizadas.toString(),
          inProgressValue: enProceso.toString(),
          pendingValue: creadas.toString(),
        );
      },
    );
  }

  // Estadísticas para Cliente (usa ClienteProvider)
  Widget _buildClienteStats(BuildContext context) {
    return Consumer<ClienteProvider>(
      builder: (context, clienteProvider, child) {
        final total = clienteProvider.totalAuditorias;
        final finalizadas = clienteProvider.auditoriasFinalizadas;
        final enProceso = clienteProvider.auditoriasEnProceso;
        final creadas = clienteProvider.auditoriasCreadas;

        return _buildStatsContainer(
          totalValue: total.toString(),
          completedValue: finalizadas.toString(),
          inProgressValue: enProceso.toString(),
          pendingValue: creadas.toString(),
        );
      },
    );
  }

  // Estado vacío (sin rol o rol desconocido)
  Widget _buildEmptyStats() {
    return _buildStatsContainer(
      totalValue: '-',
      completedValue: '-',
      inProgressValue: '-',
      pendingValue: '-',
    );
  }

  // Widget contenedor de estadísticas (reutilizable)
  Widget _buildStatsContainer({
    required String totalValue,
    required String completedValue,
    required String inProgressValue,
    required String pendingValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStat('Total', totalValue, AppColors.primaryBlue),
          _buildDivider(),
          _buildQuickStat(
            'Completadas',
            completedValue,
            AppColors.statusCompleted,
          ),
          _buildDivider(),
          _buildQuickStat(
            'En Progreso',
            inProgressValue,
            AppColors.statusInProgress,
          ),
          _buildDivider(),
          _buildQuickStat('Pendientes', pendingValue, AppColors.statusPending),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, int color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Color(AppColors.textSecondary)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Color(AppColors.borderLight));
  }
}
