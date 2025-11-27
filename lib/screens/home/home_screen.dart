import 'package:audit_cloud_app/components/home_screen/home_screen_appbar.dart';
import 'package:audit_cloud_app/components/home_screen/statistics_overview_card.dart';
import 'package:audit_cloud_app/components/home_screen/audit_status_chart.dart';
import 'package:audit_cloud_app/components/home_screen/monthly_chart.dart';
import 'package:audit_cloud_app/components/home_screen/recent_audits_section.dart';
import 'package:audit_cloud_app/components/home_screen/bottom_navigation_bar.dart';
import 'package:audit_cloud_app/screens/all_audits/all_audits_screen.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    // TODO: Navegar a diferentes pantallas según el índice
    switch (index) {
      case 0:
        // Ya estamos en Home
        break;
      case 1:
        // TODO: Navegar a crear auditoría
        break;
      case 2:
        // Navegar a total de auditorías
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllAuditsScreen()),
        ).then((_) {
          // Restaurar el índice a Home cuando regrese
          setState(() {
            _currentIndex = 0;
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeScreenAppbar(),
      backgroundColor: Color(AppColors.backgroundColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de bienvenida
            Text(
              '¡Bienvenido de vuelta!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Aquí está el resumen de tus auditorías',
              style: TextStyle(
                fontSize: 14,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),

            // Tarjetas de estadísticas generales
            Row(
              children: [
                Expanded(
                  child: StatisticsOverviewCard(
                    title: 'Total Auditorías',
                    value: '24',
                    icon: Icons.assignment,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatisticsOverviewCard(
                    title: 'Completadas',
                    value: '18',
                    icon: Icons.check_circle,
                    color: AppColors.statusCompleted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatisticsOverviewCard(
                    title: 'En Progreso',
                    value: '4',
                    icon: Icons.pending_actions,
                    color: AppColors.statusInProgress,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatisticsOverviewCard(
                    title: 'Pendientes',
                    value: '2',
                    icon: Icons.schedule,
                    color: AppColors.statusPending,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Gráficos
            const AuditStatusChart(),
            const SizedBox(height: 16),
            const MonthlyChart(),
            const SizedBox(height: 16),

            // Auditorías recientes
            const RecentAuditsSection(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
