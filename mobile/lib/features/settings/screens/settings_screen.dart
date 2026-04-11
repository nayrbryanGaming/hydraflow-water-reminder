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
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) context.go(routeLogin);
            },
          ),
        ],
      ),
    );
  }
}
