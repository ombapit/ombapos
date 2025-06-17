import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _drawerItem(
                    context,
                    Icons.point_of_sale,
                    'Point of Sale',
                    '/pos',
                  ),
                  _drawerItem(
                    context,
                    Icons.access_time,
                    'Activity',
                    '/pos/activity',
                  ),
                  _drawerItem(
                    context,
                    Icons.change_circle,
                    'shift',
                    '/pos/shift',
                  ),
                  _drawerItem(
                    context,
                    Icons.settings,
                    'Settings',
                    '/pos/settings',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String routePath,
  ) {
    final isSelected = GoRouterState.of(context).matchedLocation == routePath;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : null),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
      onTap: () {
        Navigator.of(context).pop(); // Tutup drawer
        if (!isSelected) {
          context.go(routePath); // Navigasi jika bukan halaman aktif
        }
      },
    );
  }
}
