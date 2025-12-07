import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';

class EvidenceCard extends StatelessWidget {
  final String tipo;
  final String descripcion;
  final String fecha;
  final String ubicacion;
  final int tipoColor;
  final IconData tipoIcon;
  final String? auditoriaEmpresa;
  final String? auditoriaCliente;
  final int? auditoriaEstado;

  const EvidenceCard({
    super.key,
    required this.tipo,
    required this.descripcion,
    required this.fecha,
    required this.ubicacion,
    required this.tipoColor,
    required this.tipoIcon,
    this.auditoriaEmpresa,
    this.auditoriaCliente,
    this.auditoriaEstado,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icono del tipo de evidencia
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(tipoColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(tipoIcon, color: Color(tipoColor), size: 24),
              ),
              const SizedBox(width: 12),
              // Descripción y tipo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      descripcion,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.textPrimary),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(tipoColor).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tipo.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(tipoColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Información de auditoría (empresa y cliente)
          if (auditoriaEmpresa != null || auditoriaCliente != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(AppColors.primaryGreen).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(AppColors.primaryGreen).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.business,
                    size: 16,
                    color: Color(AppColors.primaryGreen),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (auditoriaEmpresa != null)
                          Text(
                            auditoriaEmpresa!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(AppColors.textPrimary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (auditoriaCliente != null)
                          Text(
                            'Cliente: $auditoriaCliente',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(AppColors.textSecondary),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (auditoriaEstado != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(
                          _getEstadoColor(auditoriaEstado!),
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getEstadoNombre(auditoriaEstado!),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(_getEstadoColor(auditoriaEstado!)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
          // Fecha y ubicación
          SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: Color(AppColors.textSecondary),
              ),
              const SizedBox(width: 4),
              Text(
                fecha,
                style: TextStyle(
                  fontSize: 13,
                  color: Color(AppColors.textSecondary),
                ),
              ),
              if (ubicacion.isNotEmpty && ubicacion != 'Sin ubicación') ...[
                const SizedBox(width: 16),
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: Color(AppColors.textSecondary),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ubicacion,
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(AppColors.textSecondary),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  int _getEstadoColor(int estado) {
    switch (estado) {
      case 1:
        return AppColors.statusPending;
      case 2:
        return AppColors.statusInProgress;
      case 3:
        return AppColors.statusCompleted;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getEstadoNombre(int estado) {
    switch (estado) {
      case 1:
        return 'CREADA';
      case 2:
        return 'EN PROCESO';
      case 3:
        return 'FINALIZADA';
      default:
        return 'DESCONOCIDO';
    }
  }
}
