import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';

class QuickStatsCard extends StatelessWidget {
  final String totalValue;
  final String completedValue;
  final String inProgressValue;
  final String pendingValue;

  const QuickStatsCard({
    super.key,
    required this.totalValue,
    required this.completedValue,
    required this.inProgressValue,
    required this.pendingValue,
  });

  @override
  Widget build(BuildContext context) {
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
