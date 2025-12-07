import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';
import 'package:audit_cloud_app/data/providers/client_provider.dart';

class AuditStatusChart extends StatelessWidget {
  const AuditStatusChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userRole = authProvider.currentUser?.idRol;

        // Renderizar según el rol
        if (userRole == 2) {
          return _buildAuditorChart(context);
        } else if (userRole == 1) {
          return _buildSupervisorChart(context);
        } else if (userRole == 3) {
          return _buildClienteChart(context);
        } else {
          return _buildEmptyChart();
        }
      },
    );
  }

  Widget _buildAuditorChart(BuildContext context) {
    return Consumer<AuditorProvider>(
      builder: (context, auditorProvider, child) {
        // Obtener estadísticas del provider
        final creadas = auditorProvider.auditoriasCreadas;
        final enProceso = auditorProvider.auditoriasEnProceso;
        final finalizadas = auditorProvider.auditoriasFinalizadas;
        final total = auditorProvider.totalAuditorias;

        return _buildChartContainer(
          creadas: creadas,
          enProceso: enProceso,
          finalizadas: finalizadas,
          total: total,
        );
      },
    );
  }

  Widget _buildSupervisorChart(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        // Obtener estadísticas del provider
        final creadas = supervisorProvider.auditoriasCreadas;
        final enProceso = supervisorProvider.auditoriasEnProceso;
        final finalizadas = supervisorProvider.auditoriasFinalizadas;
        final total = supervisorProvider.totalAuditorias;

        return _buildChartContainer(
          creadas: creadas,
          enProceso: enProceso,
          finalizadas: finalizadas,
          total: total,
        );
      },
    );
  }

  Widget _buildClienteChart(BuildContext context) {
    return Consumer<ClienteProvider>(
      builder: (context, clienteProvider, child) {
        // Obtener estadísticas del provider
        final creadas = clienteProvider.auditoriasCreadas;
        final enProceso = clienteProvider.auditoriasEnProceso;
        final finalizadas = clienteProvider.auditoriasFinalizadas;
        final total = clienteProvider.totalAuditorias;

        return _buildChartContainer(
          creadas: creadas,
          enProceso: enProceso,
          finalizadas: finalizadas,
          total: total,
        );
      },
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de Auditorías',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Sin datos disponibles',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartContainer({
    required int creadas,
    required int enProceso,
    required int finalizadas,
    required int total,
  }) {
    // Calcular porcentajes
    final porcentajeCreadas = total > 0 ? (creadas / total) * 100 : 0.0;
    final porcentajeEnProceso = total > 0 ? (enProceso / total) * 100 : 0.0;
    final porcentajeFinalizadas = total > 0 ? (finalizadas / total) * 100 : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estado de Auditorías',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: total > 0
                ? PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 60,
                      sections: [
                        if (finalizadas > 0)
                          PieChartSectionData(
                            color: Color(AppColors.statusCompleted),
                            value: finalizadas.toDouble(),
                            title:
                                '${porcentajeFinalizadas.toStringAsFixed(0)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        if (enProceso > 0)
                          PieChartSectionData(
                            color: Color(AppColors.statusInProgress),
                            value: enProceso.toDouble(),
                            title: '${porcentajeEnProceso.toStringAsFixed(0)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        if (creadas > 0)
                          PieChartSectionData(
                            color: Color(AppColors.statusPending),
                            value: creadas.toDouble(),
                            title: '${porcentajeCreadas.toStringAsFixed(0)}%',
                            radius: 50,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'Sin datos de auditorías',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem(
                'Finalizadas ($finalizadas)',
                AppColors.statusCompleted,
              ),
              _buildLegendItem(
                'En Progreso ($enProceso)',
                AppColors.statusInProgress,
              ),
              _buildLegendItem('Creadas ($creadas)', AppColors.statusPending),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, int color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Color(color),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Color(AppColors.textSecondary)),
        ),
      ],
    );
  }
}
