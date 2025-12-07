import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';
import 'package:audit_cloud_app/data/providers/client_provider.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';

class MonthlyChart extends StatelessWidget {
  const MonthlyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final userRole = authProvider.currentUser?.idRol;

        // Mostrar chart según el rol
        if (userRole == 2) {
          return _buildAuditorChart();
        } else if (userRole == 1) {
          return _buildSupervisorChart();
        } else if (userRole == 3) {
          return _buildClienteChart();
        } else {
          return _buildEmptyChart();
        }
      },
    );
  }

  Widget _buildAuditorChart() {
    return Consumer<AuditorProvider>(
      builder: (context, auditorProvider, child) {
        return _buildChartContainer(
          auditorias: auditorProvider.auditoriasAsignadas,
        );
      },
    );
  }

  Widget _buildSupervisorChart() {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        return _buildChartContainer(auditorias: supervisorProvider.auditorias);
      },
    );
  }

  Widget _buildClienteChart() {
    return Consumer<ClienteProvider>(
      builder: (context, clienteProvider, child) {
        return _buildChartContainer(auditorias: clienteProvider.auditorias);
      },
    );
  }

  Widget _buildEmptyChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(AppColors.cardBackground),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          'No hay datos disponibles',
          style: TextStyle(fontSize: 14, color: Color(AppColors.textSecondary)),
        ),
      ),
    );
  }

  Widget _buildChartContainer({required List auditorias}) {
    // Agrupar auditorías por mes de los últimos 6 meses
    final now = DateTime.now();
    final monthsData = <int, int>{};

    // Inicializar los últimos 6 meses con 0 auditorías
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      monthsData[month.month] = 0;
    }

    // Contar auditorías por mes (usar fecha_inicio o creada_en)
    for (final auditoria in auditorias) {
      final fecha = auditoria.fechaInicio ?? auditoria.creadaEn;
      if (fecha != null) {
        final month = fecha.month;
        if (monthsData.containsKey(month)) {
          monthsData[month] = monthsData[month]! + 1;
        }
      }
    }

    // Obtener los valores de los últimos 6 meses en orden
    final monthValues = <double>[];
    final monthLabels = <String>[];
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      monthValues.add(monthsData[month.month]?.toDouble() ?? 0);
      monthLabels.add(_getMonthLabel(month.month));
    }

    final maxY = monthValues.reduce((a, b) => a > b ? a : b);
    final chartMaxY = (maxY > 0 ? maxY + 5 : 10).toDouble();

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
            'Auditorías Mensuales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: chartMaxY,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < monthLabels.length) {
                          return Text(
                            monthLabels[value.toInt()],
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(AppColors.textSecondary),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(AppColors.textSecondary),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 5,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Color(AppColors.borderLight),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  monthValues.length,
                  (index) => _buildBarGroup(
                    index,
                    monthValues[index],
                    _getBarColor(index),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthLabel(int month) {
    const months = [
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
    return months[month - 1];
  }

  int _getBarColor(int index) {
    final colors = [
      AppColors.chartGreen,
      AppColors.chartBlue,
      AppColors.chartMint,
      AppColors.chartGreen,
      AppColors.chartBlue,
      AppColors.chartMint,
    ];
    return colors[index % colors.length];
  }

  BarChartGroupData _buildBarGroup(int x, double y, int color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Color(color),
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }
}
