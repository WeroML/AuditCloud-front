import 'package:flutter/material.dart';
import 'package:audit_cloud_app/core/colors.dart';

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
    return AppBar(
      elevation: 0,
      backgroundColor: Color(AppColors.cardBackground),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(AppColors.primaryGreen).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.eco,
              color: Color(AppColors.primaryGreen),
              size: 24,
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
        CircleAvatar(
          backgroundColor: Color(AppColors.primaryBlue).withOpacity(0.1),
          child: Icon(Icons.person, color: Color(AppColors.primaryBlue)),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
