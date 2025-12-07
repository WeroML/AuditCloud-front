import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';
import 'package:audit_cloud_app/data/providers/client_provider.dart';

class PaymentsList extends StatelessWidget {
  const PaymentsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final userRole = authProvider.currentUser?.idRol;

        if (userRole == 1) {
          return _buildSupervisorList(context);
        } else if (userRole == 3) {
          return _buildClienteList(context);
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildSupervisorList(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        if (supervisorProvider.isLoadingSolicitudes) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final solicitudes = supervisorProvider.solicitudesPago;

        if (solicitudes.isEmpty) {
          return _buildEmptyState();
        }

        return _buildListContainer(solicitudes);
      },
    );
  }

  Widget _buildClienteList(BuildContext context) {
    return Consumer<ClienteProvider>(
      builder: (context, clienteProvider, child) {
        if (clienteProvider.isLoadingSolicitudes) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final solicitudes = clienteProvider.solicitudesPago;

        if (solicitudes.isEmpty) {
          return _buildEmptyState();
        }

        return _buildListContainer(solicitudes);
      },
    );
  }

  Widget _buildListContainer(List<Map<String, dynamic>> solicitudes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Solicitudes de Pago (${solicitudes.length})',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(AppColors.textPrimary),
          ),
        ),
        const SizedBox(height: 12),
        ...solicitudes.map((solicitud) => _buildPaymentCard(solicitud)),
      ],
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
              Icons.payments_outlined,
              size: 64,
              color: Color(AppColors.textSecondary).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay solicitudes de pago',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aún no hay solicitudes de pago registradas',
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

  Widget _buildPaymentCard(Map<String, dynamic> solicitud) {
    print("Solicitud de pago: $solicitud");
    // Extraer datos de la solicitud
    final idSolicitud = solicitud['id_solicitud'] ?? 0;
    final monto = solicitud['monto'] ?? 0.0;
    final concepto = solicitud['concepto'] ?? 'Sin concepto';
    final idEstado = solicitud['id_estado'] ?? 1;
    final creadoEn = solicitud['creado_en'] ?? '';
    final pagadaEn = solicitud['pagada_en'];
    final paypalOrderId = solicitud['paypal_order_id'] ?? '';
    final idEmpresaCliente = solicitud['id_empresa_cliente'] ?? 0;

    // Determinar color del estado
    final statusColor = _getStatusColorByEstado(idEstado);
    final statusText = _getStatusTextByEstado(idEstado);

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
          // Header: ID y Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt,
                    color: Color(AppColors.primaryBlue),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Solicitud #$idSolicitud',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Color(statusColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(statusColor),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Información de la solicitud
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.attach_money,
                  label: 'Monto',
                  value: '\$${monto.toStringAsFixed(2)}',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.business,
                  label: 'Cliente',
                  value: 'ID: $idEmpresaCliente',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.description,
                  label: 'Concepto',
                  value: concepto,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: 'Creado',
                  value: _formatFecha(creadoEn),
                ),
              ),
            ],
          ),
          if (pagadaEn != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildInfoRow(
                    icon: Icons.payment,
                    label: 'Pagado',
                    value: _formatFecha(pagadaEn),
                  ),
                ),
                if (paypalOrderId.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoRow(
                      icon: Icons.confirmation_number,
                      label: 'PayPal Order',
                      value: paypalOrderId,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Color(AppColors.textSecondary)),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Color(AppColors.textSecondary),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(AppColors.textPrimary),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _getStatusColorByEstado(int idEstado) {
    switch (idEstado) {
      case 1: // Pendiente
        return AppColors.statusPending;
      case 2: // Aprobada/Pagada
        return AppColors.statusCompleted;
      case 3: // Rechazada
        return AppColors.statusError;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusTextByEstado(int idEstado) {
    switch (idEstado) {
      case 1:
        return 'Pendiente';
      case 2:
        return 'Pagada';
      case 3:
        return 'Rechazada';
      default:
        return 'Desconocido';
    }
  }

  String _formatFecha(String fecha) {
    if (fecha.isEmpty) return 'Sin fecha';

    try {
      final dateTime = DateTime.parse(fecha);
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
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    } catch (e) {
      return fecha;
    }
  }
}
