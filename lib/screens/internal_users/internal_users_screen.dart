import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/internal_users_screen/internal_users_appbar.dart';
import 'package:audit_cloud_app/components/internal_users_screen/internal_users_stats.dart';
import 'package:audit_cloud_app/components/internal_users_screen/internal_users_list.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';

class InternalUsersScreen extends StatefulWidget {
  const InternalUsersScreen({super.key});

  @override
  State<InternalUsersScreen> createState() => _InternalUsersScreenState();
}

class _InternalUsersScreenState extends State<InternalUsersScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar usuarios internos al entrar a la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;

      if (user != null && user.idEmpresa != null) {
        final supervisorProvider = Provider.of<SupervisorProvider>(
          context,
          listen: false,
        );
        supervisorProvider.cargarUsuariosInternos(user.idEmpresa!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.backgroundColor),
      appBar: const InternalUsersAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // Sección de estadísticas rápidas
          InternalUsersStats(),
          SizedBox(height: 24),

          // Lista de usuarios internos
          InternalUsersList(),
        ],
      ),
    );
  }
}
