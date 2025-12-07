import 'package:audit_cloud_app/components/home_screen/home_screen_appbar.dart';
import 'package:audit_cloud_app/components/home_screen/role_statistics_cards.dart';
import 'package:audit_cloud_app/components/home_screen/audit_status_chart.dart';
import 'package:audit_cloud_app/components/home_screen/monthly_chart.dart';
import 'package:audit_cloud_app/components/home_screen/recent_audits_section.dart';
import 'package:audit_cloud_app/components/home_screen/bottom_navigation_bar.dart';
import 'package:audit_cloud_app/components/home_screen/profile_drawer.dart';
import 'package:audit_cloud_app/screens/all_audits/all_audits_screen.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    print('[HomeScreen] 🏠 initState ejecutado');

    // Cargar datos específicos según el rol del usuario
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('[HomeScreen] 📌 PostFrameCallback ejecutándose...');

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final user = authProvider.currentUser;
        print(
          '[HomeScreen] 👤 Usuario actual: ${user?.nombre} (id_rol: ${user?.idRol})',
        );

        if (user != null && user.idUsuario != null) {
          print('[HomeScreen] ✅ Usuario válido con id: ${user.idUsuario}');

          // Si el usuario es Auditor (id_rol=2), cargar auditorías asignadas
          if (user.idRol == 2) {
            print(
              '[HomeScreen] 🔍 Usuario es AUDITOR, obteniendo AuditorProvider...',
            );
            final auditorProvider = Provider.of<AuditorProvider>(
              context,
              listen: false,
            );
            print(
              '[HomeScreen] 📞 Llamando a cargarAuditoriasAsignadas(${user.idUsuario})...',
            );
            auditorProvider.cargarAuditoriasAsignadas(user.idUsuario!);
          }
          // TODO: Agregar carga de datos para Supervisor (id_rol=1)
          // TODO: Agregar carga de datos para Cliente (id_rol=3)
        } else {
          print('[HomeScreen] ⚠️ Usuario NULL o sin idUsuario');
        }
      } catch (e, stackTrace) {
        print('[HomeScreen] ❌ ERROR en PostFrameCallback: $e');
        print('[HomeScreen] 📍 Stack trace: $stackTrace');
      }
    });
  }

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
      endDrawer: const ProfileDrawer(),
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

            // Tarjetas de estadísticas dinámicas según el rol
            const RoleStatisticsCards(),
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
