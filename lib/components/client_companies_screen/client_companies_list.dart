import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';

class ClientCompaniesList extends StatelessWidget {
  const ClientCompaniesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        final empresas = supervisorProvider.empresasClientes;

        if (supervisorProvider.isLoadingEmpresas) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (empresas.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Empresas Cliente',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 12),
            ...empresas.map((empresa) => _buildCompanyCard(empresa)),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Color(AppColors.cardBackground),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(AppColors.shadowColor),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.business_outlined,
              size: 64,
              color: Color(AppColors.textSecondary).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay empresas cliente',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aún no tienes empresas cliente registradas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> empresa) {
    // Extraer datos de la empresa
    final idEmpresa = empresa['id_empresa_cliente'];
    final nombreEmpresa = empresa['nombre_empresa'] ?? 'Empresa sin nombre';
    final totalAuditorias = empresa['total_auditorias'] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(AppColors.cardBackground),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(AppColors.shadowColor),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono de empresa
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(AppColors.primaryBlue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.business,
              color: Color(AppColors.primaryBlue),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Información de la empresa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreEmpresa,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: $idEmpresa',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),

          // Badge de auditorías
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(AppColors.primaryGreen).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.assignment,
                  color: Color(AppColors.primaryGreen),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '$totalAuditorias',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(AppColors.primaryGreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
