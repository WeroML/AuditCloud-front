import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/data/providers/auditor_provider.dart';
import 'package:audit_cloud_app/components/home_screen/statistics_overview_card.dart';
import 'package:audit_cloud_app/core/colors.dart';

/// Componente que muestra tarjetas de estadísticas dinámicas según el rol del usuario
/// - Supervisor (id_rol=1): 3 tarjetas (Empresas cliente, Solicitudes de pago, Auditorías activas)
/// - Auditor (id_rol=2): 3 tarjetas (Total auditorías, En proceso, Finalizadas)
/// - Cliente (id_rol=3): 2 tarjetas (Auditorías activas, Pagos pendientes)
class RoleStatisticsCards extends StatelessWidget {
  const RoleStatisticsCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        if (user == null) {
          return const SizedBox.shrink();
        }

        // Renderizar según el rol del usuario
        switch (user.idRol) {
          case 1: // SUPERVISOR
            return _buildSupervisorCards(context);
          case 2: // AUDITOR
            return _buildAuditorCards(context);
          case 3: // CLIENTE
            return _buildClienteCards(context);
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  // ============================================================================
  // SUPERVISOR CARDS
  // ============================================================================
  Widget _buildSupervisorCards(BuildContext context) {
    // TODO: Integrar con SupervisorProvider cuando esté creado
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatisticsOverviewCard(
                title: 'Empresas Cliente',
                value: '12', // TODO: Obtener de SupervisorProvider
                icon: Icons.business,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StatisticsOverviewCard(
                title: 'Solicitudes Pago',
                value: '5', // TODO: Obtener de SupervisorProvider
                icon: Icons.payment,
                color: AppColors.statusPending,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatisticsOverviewCard(
                title: 'Auditorías Activas',
                value: '8', // TODO: Obtener de SupervisorProvider
                icon: Icons.assignment,
                color: AppColors.statusInProgress,
              ),
            ),
            const SizedBox(width: 12),
            // Espacio vacío para mantener simetría (3 tarjetas)
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  // ============================================================================
  // AUDITOR CARDS
  // ============================================================================
  Widget _buildAuditorCards(BuildContext context) {
    return Consumer<AuditorProvider>(
      builder: (context, auditorProvider, child) {
        // Mostrar datos del provider o valores por defecto si está cargando
        final totalAuditorias = auditorProvider.totalAuditorias;
        final enProceso = auditorProvider.auditoriasEnProceso;
        final finalizadas = auditorProvider.auditoriasFinalizadas;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: StatisticsOverviewCard(
                    title: 'Total Auditorías',
                    value: totalAuditorias.toString(),
                    icon: Icons.assignment,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatisticsOverviewCard(
                    title: 'En Proceso',
                    value: enProceso.toString(),
                    icon: Icons.pending_actions,
                    color: AppColors.statusInProgress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatisticsOverviewCard(
                    title: 'Finalizadas',
                    value: finalizadas.toString(),
                    icon: Icons.check_circle,
                    color: AppColors.statusCompleted,
                  ),
                ),
                const SizedBox(width: 12),
                // Espacio vacío para mantener simetría (3 tarjetas)
                const Expanded(child: SizedBox.shrink()),
              ],
            ),
          ],
        );
      },
    );
  }

  // ============================================================================
  // CLIENTE CARDS
  // ============================================================================
  Widget _buildClienteCards(BuildContext context) {
    // TODO: Integrar con ClienteProvider cuando esté creado
    return Row(
      children: [
        Expanded(
          child: StatisticsOverviewCard(
            title: 'Auditorías Activas',
            value: '3', // TODO: Obtener de ClienteProvider
            icon: Icons.assignment_turned_in,
            color: AppColors.statusInProgress,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatisticsOverviewCard(
            title: 'Pagos Pendientes',
            value: '2', // TODO: Obtener de ClienteProvider
            icon: Icons.pending,
            color: AppColors.statusPending,
          ),
        ),
      ],
    );
  }
}
