import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';

class ClientCompaniesAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ClientCompaniesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(AppColors.backgroundColor),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(AppColors.textPrimary)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Empresas Cliente',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: Color(AppColors.primaryGreen)),
          onPressed: () {
            // TODO: Implementar refresh de empresas
            print('[ClientCompaniesAppBar] Refrescar empresas cliente');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
