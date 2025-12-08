import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';

/// AppBar personalizado para la pantalla de Reportes
class ReportsAppbar extends StatelessWidget {
  const ReportsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Color(AppColors.cardBackground)),
      child: Row(
        children: [
          // Botón de regresar
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(AppColors.textPrimary)),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),

          // Título
          Text(
            'Reportes Finales',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
