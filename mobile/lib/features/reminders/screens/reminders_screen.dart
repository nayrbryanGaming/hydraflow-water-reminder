import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/notification_service.dart';

class RemindersScreen extends ConsumerStatefulWidget {
  const RemindersScreen({super.key});

  @override
  ConsumerState<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends ConsumerState<RemindersScreen> {
  bool _remindersEnabled = true;
  int _interval = 60;
  var _startTime = const TimeOfDay(hour: 8, minute: 0);
  var _endTime = const TimeOfDay(hour: 22, minute: 0);

  Future<void> _saveSettings() async {
    if (_remindersEnabled) {
      await NotificationService.instance.scheduleRecurringHydrationReminders(
        intervalMinutes: _interval,
        startHour: _startTime.hour,
        endHour: _endTime.hour,
      );
    } else {
      await NotificationService.instance.cancelAllReminders();
    }
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reminder settings saved')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminders')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          SwitchListTile(
            title: const Text('Enable Smart Reminders'),
            subtitle: const Text('Get notified to stay hydrated'),
            value: _remindersEnabled,
            onChanged: (val) => setState(() => _remindersEnabled = val),
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          if (_remindersEnabled) ...[
            const Divider(),
            ListTile(
              title: const Text('Reminder Interval'),
              subtitle: Text('Every $_interval minutes'),
              trailing: DropdownButton<int>(
                value: _interval,
                items: AppConstants.reminderIntervals
                    .map((e) => DropdownMenuItem(value: e, child: Text('$e mins')))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _interval = val);
                },
              ),
            ),
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(_startTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                 final time = await showTimePicker(context: context, initialTime: _startTime);
                 if (time != null) setState(() => _startTime = time);
              },
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text(_endTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                 final time = await showTimePicker(context: context, initialTime: _endTime);
                 if (time != null) setState(() => _endTime = time);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Apply Settings'),
            ),
          ]
        ],
      ),
    );
  }
}
