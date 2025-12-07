import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/payments_screen/payments_appbar.dart';
import 'package:audit_cloud_app/components/payments_screen/payments_stats.dart';
import 'package:audit_cloud_app/components/payments_screen/payments_list.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  @override
  void initState() {
    super.initState();
    // Recargar solicitudes de pago al entrar a la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;

      if (user != null && user.idEmpresa != null) {
        final supervisorProvider = Provider.of<SupervisorProvider>(
          context,
          listen: false,
        );
        supervisorProvider.refrescarSolicitudesPago(user.idEmpresa!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.backgroundColor),
      appBar: const PaymentsAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // Sección de estadísticas
          PaymentsStats(),
          SizedBox(height: 24),

          // Lista de solicitudes de pago
          PaymentsList(),
        ],
      ),
    );
  }
}
