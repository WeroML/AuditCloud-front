import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';

/// Lista de reportes finales
class ReportsList extends StatelessWidget {
  const ReportsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        if (supervisorProvider.isLoadingReportes) {
          return const SizedBox.shrink();
        }

        final reportes = supervisorProvider.getReportesOrdenados();

        if (reportes.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Text(
              'Todos los Reportes (${reportes.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 12),

            // Lista de reportes
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reportes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final reporte = reportes[index];
                return _buildReportCard(context, supervisorProvider, reporte);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    SupervisorProvider supervisorProvider,
    Map<String, dynamic> reporte,
  ) {
    final idAuditoria = reporte['id_auditoria'];
    final nombreReporte = reporte['nombre'] ?? 'Reporte Final';
    final nombreArchivo = reporte['nombre_archivo'] ?? 'Sin archivo';
    final tipo = reporte['tipo'] ?? 'FINAL';
    final urlArchivo = reporte['url'] as String?;
    final fechaCreacion = reporte['fecha_creacion'] as String?;

    // Buscar información de la auditoría en el caché del provider
    final auditoria = supervisorProvider.auditorias.firstWhere(
      (a) => a.idAuditoria == idAuditoria,
      orElse: () => supervisorProvider.auditorias.first,
    );

    final empresaCliente = auditoria.clienteEmpresa ?? 'Empresa desconocida';
    final clienteNombre = auditoria.clienteNombre ?? 'Cliente desconocido';

    // Formatear fecha
    String fechaTexto = 'Sin fecha';
    if (fechaCreacion != null) {
      try {
        fechaTexto = _formatearFecha(fechaCreacion);
      } catch (e) {
        fechaTexto = 'Fecha inválida';
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(AppColors.shadowColor),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado: Nombre del reporte
          Row(
            children: [
              Icon(
                Icons.description,
                size: 20,
                color: Color(AppColors.primaryBlue),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  nombreReporte,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(AppColors.textPrimary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Información de la empresa cliente
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(AppColors.primaryBlue).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(AppColors.primaryBlue).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.business,
                      size: 16,
                      color: Color(AppColors.primaryBlue),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        empresaCliente,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(AppColors.textPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Color(AppColors.textSecondary),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      clienteNombre,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Fecha de creación
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Color(AppColors.textSecondary),
              ),
              const SizedBox(width: 6),
              Text(
                fechaTexto,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(AppColors.textSecondary),
                ),
              ),
            ],
          ),

          // Nombre del archivo
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.insert_drive_file,
                size: 16,
                color: Color(AppColors.textSecondary),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  nombreArchivo,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(AppColors.textSecondary),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Badges: Auditoría y tipo
          Row(
            children: [
              // ID Auditoría
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Color(AppColors.primaryBlue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.assignment,
                      size: 14,
                      color: Color(AppColors.primaryBlue),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Auditoría #$idAuditoria',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(AppColors.primaryBlue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Tipo de reporte
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(AppColors.statusCompleted).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tipo,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(AppColors.statusCompleted),
                  ),
                ),
              ),
            ],
          ),

          // URL del archivo (si existe)
          /*
          if (urlArchivo != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(AppColors.primaryGreen).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(AppColors.primaryGreen).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.link,
                    size: 16,
                    color: Color(AppColors.primaryGreen),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      urlArchivo,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(AppColors.primaryGreen),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],*/
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.description_outlined,
              size: 64,
              color: Color(AppColors.textLight),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay reportes disponibles',
              style: TextStyle(
                fontSize: 16,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Los reportes finales aparecerán aquí',
              style: TextStyle(fontSize: 14, color: Color(AppColors.textLight)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(String fecha) {
    try {
      final dt = DateTime.parse(fecha);
      final dia = dt.day.toString().padLeft(2, '0');
      final mes = dt.month.toString().padLeft(2, '0');
      final anio = dt.year;
      final hora = dt.hour.toString().padLeft(2, '0');
      final minuto = dt.minute.toString().padLeft(2, '0');
      return '$dia/$mes/$anio $hora:$minuto';
    } catch (e) {
      return fecha;
    }
  }
}
