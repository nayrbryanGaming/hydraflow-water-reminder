import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../services/auth_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Reminders'),
            onTap: () => context.push(routeReminders),
          ),
          ListTile(
            leading: const Icon(Icons.tune),
            title: const Text('Hydration Goal'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Upgrade to Premium'),
            onTap: () {},
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Danger Zone', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.person_remove_outlined, color: Colors.red),
            title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () => _showDeleteConfirmation(context, ref),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.grey),
            title: const Text('Logout'),
            onTap: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.go(routeLogin);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text('This action is permanent and will erase all your hydration data. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(authServiceProvider).deleteUserAccount();
                if (context.mounted) context.go(routeLogin);
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting account: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Delete Permanently', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
