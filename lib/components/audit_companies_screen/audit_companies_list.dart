import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/client_provider.dart';

class AuditCompaniesList extends StatelessWidget {
  const AuditCompaniesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ClienteProvider>(
      builder: (context, clienteProvider, child) {
        if (clienteProvider.isLoadingEmpresas) {
          return const SizedBox.shrink();
        }

        final empresas = clienteProvider.getEmpresasAuditorasOrdenadas();

        if (empresas.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Empresas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: empresas.length,
              itemBuilder: (context, index) {
                return _buildCompanyCard(empresas[index]);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.business_outlined,
              size: 64,
              color: Color(AppColors.textSecondary).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay empresas auditoras disponibles',
              style: TextStyle(
                fontSize: 16,
                color: Color(AppColors.textSecondary),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> empresa) {
    final idEmpresa = empresa['id_empresa'];
    final nombre = empresa['nombre'] ?? 'Sin nombre';
    final pais = empresa['pais'] ?? '';
    final estado = empresa['estado'] ?? '';
    final ciudad = empresa['ciudad'] ?? '';
    final modulosDetalle = empresa['modulos_detalle'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Color(AppColors.cardBackground),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(AppColors.primaryGreen).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.business,
              color: Color(AppColors.primaryGreen),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Información principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nombre,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(AppColors.textPrimary),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (ciudad.isNotEmpty || pais.isNotEmpty)
                  Text(
                    [
                      ciudad,
                      estado,
                      pais,
                    ].where((e) => e.isNotEmpty).join(', '),
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(AppColors.textSecondary),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Text(
                  'ID: $idEmpresa',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(AppColors.textSecondary),
                  ),
                ),
                if (modulosDetalle.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: modulosDetalle.map((modulo) {
                      final nombreModulo =
                          modulo['clave'] ?? modulo['nombre'] ?? 'N/A';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Color(AppColors.primaryGreen).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          nombreModulo,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(AppColors.primaryGreen),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
