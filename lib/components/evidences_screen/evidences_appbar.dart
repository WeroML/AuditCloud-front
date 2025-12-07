import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';

class EvidencesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EvidencesAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(AppColors.cardBackground),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Color(AppColors.textPrimary)),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Evidencias',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
      ),
    );
  }
}
