import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audit_cloud_app/core/colors.dart';
import 'package:audit_cloud_app/data/providers/auth_provider.dart';

class HomeScreenAppbar extends StatefulWidget implements PreferredSizeWidget {
  const HomeScreenAppbar({super.key});

  @override
  State<HomeScreenAppbar> createState() => _HomeScreenAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeScreenAppbarState extends State<HomeScreenAppbar> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return AppBar(
      elevation: 0,
      backgroundColor: Color(AppColors.cardBackground),
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF9C85EF), // Morado claro
                  Color(0xFF5E35B1), // Morado oscuro
                ],
              ),
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Audit Cloud',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(AppColors.textPrimary),
            ),
          ),
        ],
      ),
      actions: [
        /*
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: Color(AppColors.textSecondary),
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),*/
        GestureDetector(
          onTap: () {
            Scaffold.of(context).openEndDrawer();
          },
          child: CircleAvatar(
            backgroundColor: Color(AppColors.primaryBlue).withOpacity(0.1),
            backgroundImage: user?.photoUrl != null
                ? NetworkImage(user!.photoUrl!)
                : null,
            child: user?.photoUrl == null
                ? Icon(Icons.person, color: Color(AppColors.primaryBlue))
                : null,
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
