import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/supervisor_provider.dart';

class InternalUsersList extends StatelessWidget {
  const InternalUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SupervisorProvider>(
      builder: (context, supervisorProvider, child) {
        if (supervisorProvider.isLoadingUsuarios) {
          return _buildLoadingState();
        }

        final usuarios = supervisorProvider.getUsuariosOrdenados();

        if (usuarios.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Auditores (${usuarios.length})',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(AppColors.textSecondary),
              ),
            ),
            const SizedBox(height: 12),
            ...usuarios.map((usuario) => _buildUserCard(usuario)),
          ],
        );
      },
    );
  }

  Widget _buildUserCard(Map<String, dynamic> usuario) {
    final nombre = usuario['nombre'] as String? ?? 'Sin nombre';
    final correo = usuario['correo'] as String? ?? 'Sin correo';
    final activo = usuario['activo'] as bool? ?? false;
    final idUsuario = usuario['id_usuario'] as int?;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Color(AppColors.cardBackground),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(AppColors.shadowColor),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: activo
                ? Color(AppColors.primaryGreen).withOpacity(0.15)
                : Color(AppColors.textSecondary).withOpacity(0.15),
            child: Icon(
              Icons.person,
              color: activo
                  ? Color(AppColors.primaryGreen)
                  : Color(AppColors.textSecondary),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),

          // Información del usuario
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  nombre,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(AppColors.textPrimary),
                    height: 1.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.email_outlined,
                      size: 13,
                      color: Color(AppColors.textSecondary),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        correo,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(AppColors.textSecondary),
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (idUsuario != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    'ID: $idUsuario',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(AppColors.textLight),
                      height: 1.2,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Columna derecha: Badge de estado e ícono de rol
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Badge de estado
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: activo
                      ? Color(AppColors.statusCompleted).withOpacity(0.15)
                      : Color(AppColors.statusError).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
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
              const SizedBox(height: 6),
              // Ícono de rol
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(AppColors.primaryBlue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.badge,
                  color: Color(AppColors.primaryBlue),
                  size: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
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
        child: Column(
          children: [
            CircularProgressIndicator(color: Color(AppColors.primaryGreen)),
            const SizedBox(height: 16),
            Text(
              'Cargando usuarios internos...',
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

  Widget _buildEmptyState() {
    return Container(
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
        child: Column(
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Color(AppColors.textLight),
            ),
            const SizedBox(height: 16),
            Text(
              'No hay usuarios internos registrados',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
