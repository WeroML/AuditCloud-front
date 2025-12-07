import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/client_provider.dart';
import 'package:audit_cloud_app/components/audit_companies_screen/audit_companies_appbar.dart';
import 'package:audit_cloud_app/components/audit_companies_screen/audit_companies_stats.dart';
import 'package:audit_cloud_app/components/audit_companies_screen/audit_companies_list.dart';

class AuditCompaniesScreen extends StatefulWidget {
  const AuditCompaniesScreen({super.key});

  @override
  State<AuditCompaniesScreen> createState() => _AuditCompaniesScreenState();
}

class _AuditCompaniesScreenState extends State<AuditCompaniesScreen> {
  @override
  void initState() {
    super.initState();
    print('[AuditCompaniesScreen] 🏢 initState ejecutado');

    // Cargar empresas auditoras al entrar a la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('[AuditCompaniesScreen] 📌 PostFrameCallback ejecutándose...');

      try {
        final clienteProvider = Provider.of<ClienteProvider>(
          context,
          listen: false,
        );
        print(
          '[AuditCompaniesScreen] 📞 Llamando a cargarEmpresasAuditoras()...',
        );
        clienteProvider.cargarEmpresasAuditoras();
      } catch (e, stackTrace) {
        print('[AuditCompaniesScreen] ❌ ERROR en PostFrameCallback: $e');
        print('[AuditCompaniesScreen] 📍 Stack trace: $stackTrace');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuditCompaniesAppbar(),
      backgroundColor: Color(AppColors.backgroundColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección
            Text(
              'Empresas Auditoras',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Explora las empresas auditoras disponibles',
              style: TextStyle(
                fontSize: 14,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 16),

            // Estadísticas
            const AuditCompaniesStats(),
            const SizedBox(height: 16),

            // Lista de empresas auditoras
            const AuditCompaniesList(),
          ],
        ),
      ),
    );
  }
}
