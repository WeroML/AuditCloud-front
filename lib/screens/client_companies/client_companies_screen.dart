import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/client_companies_screen/client_companies_appbar.dart';
import 'package:audit_cloud_app/components/client_companies_screen/client_companies_stats.dart';
import 'package:audit_cloud_app/components/client_companies_screen/client_companies_list.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';

class ClientCompaniesScreen extends StatefulWidget {
  const ClientCompaniesScreen({super.key});

  @override
  State<ClientCompaniesScreen> createState() => _ClientCompaniesScreenState();
}

class _ClientCompaniesScreenState extends State<ClientCompaniesScreen> {
  @override
  void initState() {
    super.initState();
    // Recargar empresas clientes al entrar a la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final supervisorProvider = Provider.of<SupervisorProvider>(
        context,
        listen: false,
      );
      supervisorProvider.refrescarEmpresasClientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.backgroundColor),
      appBar: const ClientCompaniesAppBar(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // Sección de estadísticas
          ClientCompaniesStats(),
          SizedBox(height: 24),

          // Lista de empresas cliente
          ClientCompaniesList(),
        ],
      ),
    );
  }
}
