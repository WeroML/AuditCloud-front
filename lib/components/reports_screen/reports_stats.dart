import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';

/// Tarjeta de estadísticas de reportes
class ReportsStats extends StatelessWidget {
  const ReportsStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        if (supervisorProvider.isLoadingReportes) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return _buildStatsContainer(
          totalReportes: supervisorProvider.totalReportes,
          reportesFinales: supervisorProvider.reportesFinales,
          reportesConArchivo: supervisorProvider.reportesConArchivo,
        );
      },
    );
  }

  Widget _buildStatsContainer({
    required int totalReportes,
    required int reportesFinales,
    required int reportesConArchivo,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // Título
          Text(
            'Resumen de Reportes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 16),

          // Estadísticas en fila
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  label: 'Total',
                  value: totalReportes.toString(),
                  color: Color(AppColors.primaryBlue),
                  icon: Icons.description,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  label: 'Finales',
                  value: reportesFinales.toString(),
                  color: Color(AppColors.statusCompleted),
                  icon: Icons.check_circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  label: 'Con Archivo',
                  value: reportesConArchivo.toString(),
                  color: Color(AppColors.primaryGreen),
                  icon: Icons.attach_file,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Color(AppColors.textSecondary),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
