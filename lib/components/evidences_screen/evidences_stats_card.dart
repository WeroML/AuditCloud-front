import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';

class EvidencesStatsCard extends StatelessWidget {
  final int? userRole;

  const EvidencesStatsCard({super.key, this.userRole});

  @override
  Widget build(BuildContext context) {
    // Renderizar según el rol del usuario
    switch (userRole) {
      case 2: // AUDITOR
        return _buildAuditorStats(context);
      case 1: // SUPERVISOR
        return _buildSupervisorStats(context);
      case 3: // CLIENTE
        return _buildClienteStats(context);
      default:
        return _buildEmptyStats();
    }
  }

  // Estadísticas para Auditor (usa AuditorProvider)
  Widget _buildAuditorStats(BuildContext context) {
    return Consumer<AuditorProvider>(
      builder: (context, auditorProvider, child) {
        final total = auditorProvider.totalEvidencias;
        final fotos = auditorProvider.evidenciasFoto;
        final videos = auditorProvider.evidenciasVideo;
        final documentos = auditorProvider.evidenciasDocumento;

        return _buildStatsContainer(
          totalValue: total.toString(),
          fotosValue: fotos.toString(),
          videosValue: videos.toString(),
          documentosValue: documentos.toString(),
        );
      },
    );
  }

  // Estadísticas para Supervisor (TODO: usar SupervisorProvider)
  Widget _buildSupervisorStats(BuildContext context) {
    // TODO: Consumir SupervisorProvider cuando esté creado
    return _buildStatsContainer(
      totalValue: '0',
      fotosValue: '0',
      videosValue: '0',
      documentosValue: '0',
    );
  }

  // Estadísticas para Cliente (TODO: usar ClienteProvider)
  Widget _buildClienteStats(BuildContext context) {
    // TODO: Consumir ClienteProvider cuando esté creado
    return _buildStatsContainer(
      totalValue: '0',
      fotosValue: '0',
      videosValue: '0',
      documentosValue: '0',
    );
  }

  // Estado vacío (sin rol o rol desconocido)
  Widget _buildEmptyStats() {
    return _buildStatsContainer(
      totalValue: '-',
      fotosValue: '-',
      videosValue: '-',
      documentosValue: '-',
    );
  }

  // Widget contenedor de estadísticas (reutilizable)
  Widget _buildStatsContainer({
    required String totalValue,
    required String fotosValue,
    required String videosValue,
    required String documentosValue,
  }) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickStat('Total', totalValue, AppColors.primaryBlue),
          _buildDivider(),
          _buildQuickStat('Fotos', fotosValue, AppColors.primaryGreen),
          _buildDivider(),
          _buildQuickStat('Videos', videosValue, AppColors.statusInProgress),
          _buildDivider(),
          _buildQuickStat(
            'Documentos',
            documentosValue,
            AppColors.statusPending,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, int color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Color(AppColors.textSecondary)),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Color(AppColors.borderLight));
  }
}
