import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/components/home_screen/audit_card.dart';

class AllAuditsScreen extends StatefulWidget {
  const AllAuditsScreen({super.key});

  @override
  State<AllAuditsScreen> createState() => _AllAuditsScreenState();
}

class _AllAuditsScreenState extends State<AllAuditsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.backgroundColor),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(AppColors.cardBackground),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(AppColors.textPrimary)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Todas las Auditorías',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(AppColors.textPrimary),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: Color(AppColors.textSecondary),
            ),
            onPressed: () {
              // TODO: Implementar filtros
            },
          ),
          IconButton(
            icon: Icon(Icons.search, color: Color(AppColors.textSecondary)),
            onPressed: () {
              // TODO: Implementar búsqueda
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Sección de estadísticas rápidas
          Container(
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
                _buildQuickStat('Total', '12', AppColors.primaryBlue),
                _buildDivider(),
                _buildQuickStat('Completadas', '6', AppColors.statusCompleted),
                _buildDivider(),
                _buildQuickStat('En Progreso', '4', AppColors.statusInProgress),
                _buildDivider(),
                _buildQuickStat('Pendientes', '2', AppColors.statusPending),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Lista de auditorías
          Text(
            'Ordenadas por fecha',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 12),

          // Auditorías más recientes primero
          AuditCard(
            auditName: 'Auditoría de Residuos',
            company: 'NatureCorp',
            status: 'Pendiente',
            date: '20 Nov 2025',
            progress: 0.0,
            statusColor: AppColors.statusPending,
          ),
          AuditCard(
            auditName: 'Auditoría Ambiental - Planta Norte',
            company: 'EcoTech Industries',
            status: 'En Progreso',
            date: '15 Nov 2025',
            progress: 0.65,
            statusColor: AppColors.statusInProgress,
          ),
          AuditCard(
            auditName: 'Certificación ISO 14001',
            company: 'Sustainable Ltd.',
            status: 'En Progreso',
            date: '12 Nov 2025',
            progress: 0.45,
            statusColor: AppColors.statusInProgress,
          ),
          AuditCard(
            auditName: 'Evaluación de Emisiones',
            company: 'GreenPower S.A.',
            status: 'Completada',
            date: '10 Nov 2025',
            progress: 1.0,
            statusColor: AppColors.statusCompleted,
          ),
          AuditCard(
            auditName: 'Auditoría de Agua Residual',
            company: 'AquaClean Inc.',
            status: 'Completada',
            date: '08 Nov 2025',
            progress: 1.0,
            statusColor: AppColors.statusCompleted,
          ),
          AuditCard(
            auditName: 'Control de Calidad Ambiental',
            company: 'EcoTech Industries',
            status: 'Completada',
            date: '05 Nov 2025',
            progress: 1.0,
            statusColor: AppColors.statusCompleted,
          ),
          AuditCard(
            auditName: 'Evaluación de Impacto Ambiental',
            company: 'GreenBuilders Co.',
            status: 'En Progreso',
            date: '03 Nov 2025',
            progress: 0.75,
            statusColor: AppColors.statusInProgress,
          ),
          AuditCard(
            auditName: 'Auditoría Energética',
            company: 'PowerGreen Ltd.',
            status: 'Completada',
            date: '01 Nov 2025',
            progress: 1.0,
            statusColor: AppColors.statusCompleted,
          ),
          AuditCard(
            auditName: 'Gestión de Residuos Peligrosos',
            company: 'SafeWaste Corp.',
            status: 'En Progreso',
            date: '28 Oct 2025',
            progress: 0.30,
            statusColor: AppColors.statusInProgress,
          ),
          AuditCard(
            auditName: 'Certificación Carbono Neutro',
            company: 'EcoTech Industries',
            status: 'Completada',
            date: '25 Oct 2025',
            progress: 1.0,
            statusColor: AppColors.statusCompleted,
          ),
          AuditCard(
            auditName: 'Auditoría de Biodiversidad',
            company: 'NatureCorp',
            status: 'Pendiente',
            date: '22 Oct 2025',
            progress: 0.0,
            statusColor: AppColors.statusPending,
          ),
          AuditCard(
            auditName: 'Evaluación de Ruido Ambiental',
            company: 'SoundControl Inc.',
            status: 'Completada',
            date: '20 Oct 2025',
            progress: 1.0,
            statusColor: AppColors.statusCompleted,
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
