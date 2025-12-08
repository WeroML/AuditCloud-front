import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/screens/all_audits/all_audits_screen.dart';
import 'package:audit_cloud_app/screens/evidences/evidences_screen.dart';
import 'package:audit_cloud_app/screens/client_companies/client_companies_screen.dart';
import 'package:audit_cloud_app/screens/payments/payments_screen.dart';
import 'package:audit_cloud_app/screens/audit_companies/audit_companies_screen.dart';

/// Modelo para definir un item del navigation bar
class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route; // Para navegación futura

  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  /// Retorna las opciones del navigation bar según el rol del usuario
  List<NavItem> _getNavItemsForRole(int? idRol) {
    switch (idRol) {
      case 1: // SUPERVISOR
        return [
          NavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Dashboard',
            route: '/dashboard',
          ),
          NavItem(
            icon: Icons.business_outlined,
            activeIcon: Icons.business,
            label: 'Empresas',
            route: '/empresas-cliente',
          ),
          NavItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            label: 'Auditorías',
            route: '/auditorias',
          ),
          NavItem(
            icon: Icons.payments_outlined,
            activeIcon: Icons.payments,
            label: 'Pagos',
            route: '/pagos',
          ),
        ];

      case 2: // AUDITOR
        return [
          NavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Dashboard',
            route: '/dashboard',
          ),
          NavItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            label: 'Mis Auditorías',
            route: '/mis-auditorias',
          ),
          NavItem(
            icon: Icons.photo_library_outlined,
            activeIcon: Icons.photo_library,
            label: 'Evidencias',
            route: '/evidencias',
          ),
        ];

      case 3: // CLIENTE
        return [
          NavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Dashboard',
            route: '/dashboard',
          ),
          NavItem(
            icon: Icons.store_outlined,
            activeIcon: Icons.store,
            label: 'Empresas',
            route: '/empresas-auditoras',
          ),
          NavItem(
            icon: Icons.payment_outlined,
            activeIcon: Icons.payment,
            label: 'Pagos',
            route: '/pagos',
          ),
          NavItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            label: 'Auditorías',
            route: '/mis-auditorias',
          ),
        ];

      default:
        // Fallback: opciones básicas si no hay rol definido
        return [
          NavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            label: 'Dashboard',
            route: '/dashboard',
          ),
          NavItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            label: 'Auditorías',
            route: '/auditorias',
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        final navItems = _getNavItemsForRole(user?.idRol);

        return Container(
          decoration: BoxDecoration(
            color: Color(AppColors.cardBackground),
            boxShadow: [
              BoxShadow(
                color: Color(AppColors.shadowColor),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  navItems.length,
                  (index) => _buildNavItem(
                    context: context,
                    navItem: navItems[index],
                    index: index,
                    totalItems: navItems.length,
                    userRole: user?.idRol,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required NavItem navItem,
    required int index,
    required int totalItems,
    int? userRole,
  }) {
    final isSelected = currentIndex == index;

    // Ajustar tamaño de fuente según cantidad de items
    final fontSize = totalItems > 3 ? 10.0 : 12.0;
    final iconSize = totalItems > 3 ? 24.0 : 26.0;

    return Expanded(
      child: InkWell(
        onTap: () {
          // Navegación especial para Auditor
          if (userRole == 2) {
            if (navItem.route == '/mis-auditorias') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllAuditsScreen(),
                ),
              );
            } else if (navItem.route == '/evidencias') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EvidencesScreen(),
                ),
              );
            } else {
              // Para otros casos, usar el callback original
              onTap(index);
            }
          } else if (userRole == 1) {
            // Navegación especial para Supervisor
            if (navItem.route == '/empresas-cliente') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClientCompaniesScreen(),
                ),
              );
            } else if (navItem.route == '/auditorias') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllAuditsScreen(),
                ),
              );
            } else if (navItem.route == '/pagos') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentsScreen()),
              );
            } else {
              // Para otros casos, usar el callback original
              onTap(index);
            }
          } else if (userRole == 3) {
            // Navegación especial para Cliente
            if (navItem.route == '/empresas-auditoras') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuditCompaniesScreen(),
                ),
              );
            } else if (navItem.route == '/pagos') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PaymentsScreen()),
              );
            } else if (navItem.route == '/mis-auditorias') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllAuditsScreen(),
                ),
              );
            } else {
              // Para otros casos, usar el callback original
              onTap(index);
            }
          } else {
            // Para otros roles, usar el callback original
            onTap(index);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Color(AppColors.primaryGreen).withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? navItem.activeIcon : navItem.icon,
                color: isSelected
                    ? Color(AppColors.primaryGreen)
                    : Color(AppColors.textSecondary),
                size: iconSize,
              ),
              const SizedBox(height: 4),
              Text(
                navItem.label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Color(AppColors.primaryGreen)
                      : Color(AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
