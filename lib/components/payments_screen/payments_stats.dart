import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';

class PaymentsStats extends StatelessWidget {
  const PaymentsStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        final totalSolicitudes = supervisorProvider.totalSolicitudesPago;
        final pendientes = supervisorProvider.solicitudesPagoPendientes;
        final aprobadas = totalSolicitudes - pendientes;

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
              Row(
                children: [
                  Icon(
                    Icons.payments,
                    color: Color(AppColors.primaryBlue),
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Resumen de Pagos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.receipt_long,
                    label: 'Total',
                    value: totalSolicitudes.toString(),
                    color: AppColors.primaryBlue,
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: Color(AppColors.borderLight),
                  ),
                  _buildStatItem(
                    icon: Icons.pending_actions,
                    label: 'Pendientes',
                    value: pendientes.toString(),
                    color: AppColors.statusPending,
                  ),
                  Container(
                    height: 50,
                    width: 1,
                    color: Color(AppColors.borderLight),
                  ),
                  _buildStatItem(
                    icon: Icons.check_circle_outline,
                    label: 'Aprobadas',
                    value: aprobadas.toString(),
                    color: AppColors.statusCompleted,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required int color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Color(color), size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
