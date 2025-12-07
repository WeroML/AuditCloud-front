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
        print("Empresas cliente: $empresas");

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
    // Extraer datos de la empresa desde el backend
    final idEmpresa = empresa['id_empresa'];
    final nombreEmpresa = empresa['nombre'] ?? 'Empresa sin nombre';
    final ciudad = empresa['ciudad'] ?? '';
    final pais = empresa['pais'] ?? '';
    final contacto = empresa['contacto'] ?? '';
    final totalAuditorias = empresa['total_auditorias'] ?? 0;
    final activo = empresa['activo'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icono de empresa (fijo, centrado)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(AppColors.primaryBlue).withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                Icons.business,
                color: Color(AppColors.primaryBlue),
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Información de la empresa
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombreEmpresa,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(AppColors.textPrimary),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Color(AppColors.textSecondary),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$ciudad, $pais',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Color(AppColors.textSecondary),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        contacto,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(AppColors.textSecondary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'ID: $idEmpresa',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(AppColors.textSecondary).withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Columna derecha: Badge de estado + Badge de auditorías
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Badge de auditorías
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Color(AppColors.primaryGreen).withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment,
                      color: Color(AppColors.primaryGreen),
                      size: 18,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$totalAuditorias',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.primaryGreen),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              // Badge de estado activo
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: activo
                      ? Color(AppColors.statusCompleted).withOpacity(0.12)
                      : Color(AppColors.statusError).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  activo ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: activo
                        ? Color(AppColors.statusCompleted)
                        : Color(AppColors.statusError),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
