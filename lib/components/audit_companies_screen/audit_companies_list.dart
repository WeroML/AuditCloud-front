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
              'Lista de Empresas Auditoras',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 16),
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Color(AppColors.textSecondary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Color(AppColors.textSecondary),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> empresa) {
    final idEmpresa = empresa['id_empresa'];
    final nombre = empresa['nombre'] ?? 'Sin nombre';
    final pais = empresa['pais'] ?? '';
    final estado = empresa['estado'] ?? '';
    final ciudad = empresa['ciudad'] ?? '';
    final direccion = empresa['direccion'] ?? '';
    final rfc = empresa['rfc'] ?? 'Sin RFC';
    final giro = empresa['giro'] ?? 'Servicios de Auditoría';
    final tipoAuditoria = empresa['tipo_auditoria'] ?? 'GENERAL';
    final contactoNombre = empresa['contacto_nombre'] ?? '';
    final contactoCorreo = empresa['contacto_correo'] ?? '';
    final contactoTelefono = empresa['contacto_telefono'] ?? '';
    // Usamos 'modulos' tal como lo devuelve el endpoint de lista
    final modulos = empresa['modulos'] as List<dynamic>? ?? [];

    final String ubicacionCompleta = [
      direccion,
      ciudad,
      estado,
      pais,
    ].where((e) => e.toString().trim().isNotEmpty).join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Color(AppColors.cardBackground),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Color(AppColors.textSecondary).withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Badge
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(AppColors.primaryGreen).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.business_center,
                    color: Color(AppColors.primaryGreen),
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              nombre,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(AppColors.textPrimary),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(
                                AppColors.primaryBlue,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              tipoAuditoria,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(AppColors.primaryBlue),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        giro,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: Color(AppColors.textSecondary).withOpacity(0.1),
          ),

          // Body: Details
          Padding(
            padding: const EdgeInsets.all(16).copyWith(top: 8),
            child: Column(
              children: [
                _buildInfoRow(
                  Icons.pin_drop_outlined,
                  ubicacionCompleta.isEmpty
                      ? 'Ubicación no especificada'
                      : ubicacionCompleta,
                ),
                if (contactoNombre.isNotEmpty || contactoCorreo.isNotEmpty)
                  _buildInfoRow(
                    Icons.contact_mail_outlined,
                    '$contactoNombre${contactoCorreo.isNotEmpty ? ' ($contactoCorreo)' : ''}',
                  ),
                if (contactoTelefono.isNotEmpty)
                  _buildInfoRow(Icons.phone_outlined, contactoTelefono),
                _buildInfoRow(
                  Icons.receipt_long_outlined,
                  'RFC: $rfc (ID: $idEmpresa)',
                ),
              ],
            ),
          ),

          // Footer: Modulos
          if (modulos.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Color(AppColors.backgroundColor),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MÓDULOS DISPONIBLES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.textSecondary).withOpacity(0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: modulos.map((modulo) {
                      final nombreModulo =
                          modulo['nombre'] ?? modulo['clave'] ?? 'Módulo';
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Color(AppColors.primaryGreen).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color(
                              AppColors.primaryGreen,
                            ).withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Color(AppColors.primaryGreen),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              nombreModulo,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(AppColors.primaryGreen),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
