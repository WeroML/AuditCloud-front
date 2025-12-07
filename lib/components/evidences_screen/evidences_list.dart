import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';
import 'package:audit_cloud_app/components/evidences_screen/evidence_card.dart';

class EvidencesList extends StatelessWidget {
  final int? userRole;

  const EvidencesList({super.key, this.userRole});

  @override
  Widget build(BuildContext context) {
    // Renderizar según el rol del usuario
    switch (userRole) {
      case 2: // AUDITOR
        return _buildAuditorEvidencesList(context);
      case 1: // SUPERVISOR
        return _buildSupervisorEvidencesList(context);
      case 3: // CLIENTE
        return _buildClienteEvidencesList(context);
      default:
        return _buildEmptyList();
    }
  }

  // Lista de evidencias para Auditor
  Widget _buildAuditorEvidencesList(BuildContext context) {
    return Consumer<AuditorProvider>(
      builder: (context, auditorProvider, child) {
        if (auditorProvider.isLoadingEvidencias) {
          return _buildLoadingState();
        }

        final evidencias = auditorProvider.getEvidenciasOrdenadas();

        if (evidencias.isEmpty) {
          return _buildEmptyState('No tienes evidencias subidas');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ordenadas por fecha (${evidencias.length} evidencias)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
            ...evidencias.map((evidencia) {
              final tipoColor = _getTipoColor(evidencia.tipo);
              final tipoIcon = _getTipoIcon(evidencia.tipo);
              final fecha = evidencia.creadoEn;
              final dateStr = fecha != null ? _formatDate(fecha) : 'Sin fecha';

              return EvidenceCard(
                tipo: evidencia.tipo,
                descripcion: evidencia.descripcion,
                fecha: dateStr,
                ubicacion: evidencia.ubicacion ?? 'Sin ubicación',
                tipoColor: tipoColor,
                tipoIcon: tipoIcon,
                auditoriaEmpresa: evidencia.auditoriaEmpresaNombre,
                auditoriaCliente: evidencia.auditoriaClienteNombre,
                auditoriaEstado: evidencia.auditoriaEstado,
              );
            }),
          ],
        );
      },
    );
  }

  // Lista de evidencias para Supervisor
  Widget _buildSupervisorEvidencesList(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        if (supervisorProvider.isLoadingEvidencias) {
          return _buildLoadingState();
        }

        final evidencias = supervisorProvider.getEvidenciasOrdenadas();

        if (evidencias.isEmpty) {
          return _buildEmptyState('No hay evidencias en las auditorías');
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ordenadas por fecha (${evidencias.length} evidencias)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
            ...evidencias.map((evidenciaMap) {
              final tipo = evidenciaMap['tipo'] as String? ?? 'DOC';
              final descripcion =
                  evidenciaMap['descripcion'] as String? ?? 'Sin descripción';
              final ubicacion =
                  evidenciaMap['ubicacion'] as String? ?? 'Sin ubicación';
              final creadoEn = evidenciaMap['creado_en'] as String?;
              final nombreAuditor = evidenciaMap['nombre_auditor'] as String?;
              final nombreModulo = evidenciaMap['nombre_modulo'] as String?;

              final tipoColor = _getTipoColor(tipo);
              final tipoIcon = _getTipoIcon(tipo);

              String dateStr = 'Sin fecha';
              if (creadoEn != null) {
                try {
                  final fecha = DateTime.parse(creadoEn);
                  dateStr = _formatDate(fecha);
                } catch (e) {
                  dateStr = 'Fecha inválida';
                }
              }

              return EvidenceCard(
                tipo: tipo,
                descripcion: descripcion,
                fecha: dateStr,
                ubicacion: ubicacion,
                tipoColor: tipoColor,
                tipoIcon: tipoIcon,
                auditoriaEmpresa: nombreAuditor ?? 'Auditor desconocido',
                auditoriaCliente: nombreModulo ?? 'Módulo general',
                auditoriaEstado:
                    null, // Las evidencias del supervisor no tienen estado directo
              );
            }),
          ],
        );
      },
    );
  }

  // Lista de evidencias para Cliente (TODO: implementar con ClienteProvider)
  Widget _buildClienteEvidencesList(BuildContext context) {
    // TODO: Consumir ClienteProvider cuando esté creado
    return _buildEmptyState('Funcionalidad de Cliente en desarrollo');
  }

  // Estado vacío
  Widget _buildEmptyList() {
    return _buildEmptyState('No hay evidencias disponibles');
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidencias',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(32),
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
            child: CircularProgressIndicator(
              color: Color(AppColors.primaryGreen),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidencias',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(32),
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
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Color(AppColors.textSecondary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int _getTipoColor(String tipo) {
    switch (tipo.toUpperCase()) {
      case 'FOTO':
        return AppColors.primaryGreen;
      case 'VIDEO':
        return AppColors.statusInProgress;
      case 'DOC':
        return AppColors.statusPending;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getTipoIcon(String tipo) {
    switch (tipo.toUpperCase()) {
      case 'FOTO':
        return Icons.photo_camera;
      case 'VIDEO':
        return Icons.videocam;
      case 'DOC':
        return Icons.description;
      default:
        return Icons.attachment;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
