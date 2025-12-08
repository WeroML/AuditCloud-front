import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/screens/login/login_screen.dart';
import 'package:audit_cloud_app/screens/all_audits/all_audits_screen.dart';
import 'package:audit_cloud_app/screens/evidences/evidences_screen.dart';
import 'package:audit_cloud_app/screens/client_companies/client_companies_screen.dart';
import 'package:audit_cloud_app/screens/payments/payments_screen.dart';
import 'package:audit_cloud_app/screens/internal_users/internal_users_screen.dart';
import 'package:audit_cloud_app/screens/audit_companies/audit_companies_screen.dart';
import 'package:audit_cloud_app/screens/reports/reports_screen.dart';

/// Modelo para definir un item del drawer
class DrawerMenuItem {
  final IconData icon;
  final IconData activeIcon;
  final String title;
  final String route;
  final VoidCallback? onTap;

  DrawerMenuItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.route,
    this.onTap,
  });
}

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  String _getRoleName(int idRol) {
    switch (idRol) {
      case 1:
        return 'Supervisor';
      case 2:
        return 'Auditor';
      case 3:
        return 'Cliente';
      default:
        return 'Usuario';
    }
  }

  /// Retorna las opciones del menú según el rol del usuario
  List<DrawerMenuItem> _getMenuItemsForRole(int? idRol) {
    switch (idRol) {
      case 1: // SUPERVISOR
        return [
          DrawerMenuItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            title: 'Dashboard',
            route: '/dashboard',
          ),
          DrawerMenuItem(
            icon: Icons.business_outlined,
            activeIcon: Icons.business,
            title: 'Empresas Cliente',
            route: '/empresas-cliente',
          ),
          DrawerMenuItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            title: 'Auditorías',
            route: '/auditorias',
          ),
          DrawerMenuItem(
            icon: Icons.payments_outlined,
            activeIcon: Icons.payments,
            title: 'Pagos',
            route: '/pagos',
          ),
          DrawerMenuItem(
            icon: Icons.photo_library_outlined,
            activeIcon: Icons.photo_library,
            title: 'Evidencias',
            route: '/evidencias',
          ),
          DrawerMenuItem(
            icon: Icons.description_outlined,
            activeIcon: Icons.description,
            title: 'Reportes',
            route: '/reportes',
          ),
          DrawerMenuItem(
            icon: Icons.people_outlined,
            activeIcon: Icons.people,
            title: 'Usuarios Internos',
            route: '/usuarios-internos',
          ),
        ];

      case 2: // AUDITOR
        return [
          DrawerMenuItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            title: 'Dashboard',
            route: '/dashboard',
          ),
          DrawerMenuItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            title: 'Mis Auditorías',
            route: '/mis-auditorias',
          ),
          DrawerMenuItem(
            icon: Icons.photo_library_outlined,
            activeIcon: Icons.photo_library,
            title: 'Evidencias',
            route: '/evidencias',
          ),
        ];

      case 3: // CLIENTE
        return [
          DrawerMenuItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            title: 'Dashboard',
            route: '/dashboard',
          ),
          DrawerMenuItem(
            icon: Icons.store_outlined,
            activeIcon: Icons.store,
            title: 'Empresas Auditoras',
            route: '/empresas-auditoras',
          ),
          DrawerMenuItem(
            icon: Icons.payment_outlined,
            activeIcon: Icons.payment,
            title: 'Pagos',
            route: '/pagos',
          ),
          DrawerMenuItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            title: 'Mis Auditorías',
            route: '/mis-auditorias',
          ),
        ];

      default:
        // Fallback: opciones básicas si no hay rol definido
        return [
          DrawerMenuItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            title: 'Dashboard',
            route: '/dashboard',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        final menuItems = _getMenuItemsForRole(user?.idRol);

        return Drawer(
          backgroundColor: Color(AppColors.backgroundColor),
          child: SafeArea(
            child: Column(
              children: [
                // Header del drawer con info del usuario
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(AppColors.primaryGreen).withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(AppColors.primaryGreen),
                        backgroundImage: user?.photoUrl != null
                            ? NetworkImage(user!.photoUrl!)
                            : null,
                        child: user?.photoUrl == null
                            ? Icon(Icons.person, size: 40, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user?.nombre ?? 'Usuario',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(AppColors.textPrimary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.correo ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(AppColors.textSecondary),
                        ),
                      ),
                      if (user?.idRol != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(
                              AppColors.primaryBlue,
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getRoleName(user!.idRol!),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.primaryBlue),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Opciones de menú dinámicas según rol
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ...menuItems.map(
                        (item) => _buildDrawerItem(
                          context: context,
                          icon: item.icon,
                          activeIcon: item.activeIcon,
                          title: item.title,
                          onTap: () {
                            Navigator.pop(context);

                            // Navegación especial para Auditor
                            if (user?.idRol == 2) {
                              if (item.route == '/mis-auditorias') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllAuditsScreen(),
                                  ),
                                );
                              } else if (item.route == '/evidencias') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EvidencesScreen(),
                                  ),
                                );
                              } else {
                                // TODO: Implementar navegación para otras opciones
                                print(
                                  '[ProfileDrawer] Navegar a: ${item.route}',
                                );
                              }
                            } else if (user?.idRol == 1) {
                              // Navegación especial para Supervisor
                              if (item.route == '/empresas-cliente') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ClientCompaniesScreen(),
                                  ),
                                );
                              } else if (item.route == '/auditorias') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllAuditsScreen(),
                                  ),
                                );
                              } else if (item.route == '/pagos') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentsScreen(),
                                  ),
                                );
                              } else if (item.route == '/evidencias') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EvidencesScreen(),
                                  ),
                                );
                              } else if (item.route == '/usuarios-internos') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const InternalUsersScreen(),
                                  ),
                                );
                              } else if (item.route == '/reportes') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ReportsScreen(),
                                  ),
                                );
                              } else {
                                // TODO: Implementar navegación para otras opciones
                                print(
                                  '[ProfileDrawer] Navegar a: ${item.route}',
                                );
                              }
                            } else if (user?.idRol == 3) {
                              // Navegación especial para Cliente
                              if (item.route == '/empresas-auditoras') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AuditCompaniesScreen(),
                                  ),
                                );
                              } else if (item.route == '/pagos') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const PaymentsScreen(),
                                  ),
                                );
                              } else if (item.route == '/mis-auditorias') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllAuditsScreen(),
                                  ),
                                );
                              } else {
                                // TODO: Implementar navegación para otras opciones
                                print(
                                  '[ProfileDrawer] Navegar a: ${item.route}',
                                );
                              }
                            } else {
                              // TODO: Implementar navegación a item.route para otros roles
                              print('[ProfileDrawer] Navegar a: ${item.route}');
                            }
                          },
                        ),
                      ),
                      //const Divider(height: 32),
                      /*
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings,
                        title: 'Configuración',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navegar a configuración
                        },
                      ),
                      _buildDrawerItem(
                        context: context,
                        icon: Icons.help_outline,
                        activeIcon: Icons.help,
                        title: 'Ayuda',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Navegar a ayuda
                        },
                      ),*/
                    ],
                  ),
                ),

                // Cerrar sesión al final
                Container(
                  padding: const EdgeInsets.all(16),
                  child: _buildDrawerItem(
                    context: context,
                    icon: Icons.logout,
                    activeIcon: Icons.logout,
                    title: 'Cerrar Sesión',
                    isDestructive: true,
                    onTap: () async {
                      print('[ProfileDrawer] Cerrando sesión...');
                      await authProvider.logout();

                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? Color(AppColors.statusError)
        : Color(AppColors.textPrimary);

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
