import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';

class PaymentsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PaymentsAppBar({super.key});

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
        'Solicitudes de Pago',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(AppColors.textPrimary),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
