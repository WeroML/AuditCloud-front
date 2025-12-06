import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/screens/all_audits/all_audits_screen.dart';
import 'package:audit_cloud_app/screens/login/login_screen.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

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
                  if (user?.rol != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(AppColors.primaryBlue).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user!.rol!,
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

            // Opciones de menú
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    title: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.add_circle_outline,
                    activeIcon: Icons.add_circle,
                    title: 'Nueva Auditoría',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navegar a crear auditoría
                    },
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.assignment_outlined,
                    activeIcon: Icons.assignment,
                    title: 'Todas las Auditorías',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllAuditsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 32),
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
                  ),
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
