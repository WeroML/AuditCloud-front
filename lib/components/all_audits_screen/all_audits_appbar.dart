import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';

class AllAuditsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AllAuditsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(AppColors.cardBackground),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(AppColors.textPrimary)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Todas las Auditorías',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
      ),
    );
  }
}
