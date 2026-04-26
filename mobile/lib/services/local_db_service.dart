import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/hydration_log.dart';
import '../models/user_model.dart';
import '../models/achievement_model.dart';

final localDbServiceProvider = Provider<LocalDbService>((ref) {
  return LocalDbService();
});

class LocalDbService {
  static const String _userBoxName = 'hydraflow_user';
  static const String _logsBoxName = 'hydraflow_logs';
  static const String _statsBoxName = 'hydraflow_stats';
  static const String _achievementsBoxName = 'hydraflow_achievements';

  Future<void> init() async {
    await Hive.openBox(_userBoxName);
    await Hive.openBox(_logsBoxName);
    await Hive.openBox(_statsBoxName);
    await Hive.openBox(_achievementsBoxName);
  }

  // --- User Profile ---

  Future<void> saveUserProfile(UserModel user) async {
    final box = Hive.box(_userBoxName);
    await box.put('profile', user.toMap());
  }

  Future<void> updateUserProfile(UserModel user) async {
    await saveUserProfile(user);
  }

  Stream<UserModel?> getUserProfile() {
    final box = Hive.box(_userBoxName);
    
    // Initial value
    UserModel? initialUser;
    final data = box.get('profile');
    if (data != null) {
      initialUser = UserModel.fromMap(Map<String, dynamic>.from(data));
    }

    // Yield initial and then watch for changes
    return Stream.value(initialUser).asyncExpand((user) async* {
      yield user;
      await for (final event in box.watch(key: 'profile')) {
        if (event.value != null) {
          yield UserModel.fromMap(Map<String, dynamic>.from(event.value));
        } else {
          yield null;
        }
      }
    });
  }

  // --- Hydration Logs ---

  Future<void> addHydrationLog(HydrationLog log) async {
    final box = Hive.box(_logsBoxName);
    final id = log.logId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final newLog = log.copyWith(logId: id);
    await box.put(id, newLog.toMap());
  }

  Stream<List<HydrationLog>> getTodaysHydrationLogs() {
    return getHydrationLogs().map((logs) {
      final now = DateTime.now();
      return logs.where((log) {
        return log.timestamp.year == now.year &&
               log.timestamp.month == now.month &&
               log.timestamp.day == now.day;
      }).toList();
    });
  }

  Stream<List<HydrationLog>> getHydrationLogs() {
    final box = Hive.box(_logsBoxName);
    
    List<HydrationLog> getLogs() {
      return box.values.map((data) {
        final map = Map<String, dynamic>.from(data);
        return HydrationLog.fromMap(map, map['logId'] ?? '');
      }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    return Stream.value(getLogs()).asyncExpand((logs) async* {
      yield logs;
      await for (final _ in box.watch()) {
        yield getLogs();
      }
    });
  }

  // --- Stats ---
  
  Stream<Map<String, dynamic>> getUserStats() {
    final box = Hive.box(_statsBoxName);
    
    Map<String, dynamic> getStats() {
      final data = box.get('stats', defaultValue: <String, dynamic>{});
      return Map<String, dynamic>.from(data);
    }

    return Stream.value(getStats()).asyncExpand((stats) async* {
      yield stats;
      await for (final event in box.watch(key: 'stats')) {
        yield Map<String, dynamic>.from(event.value ?? {});
      }
    });
  }

  // --- Reset ---
  
  Future<void> clearAllData() async {
    await Hive.box(_userBoxName).clear();
    await Hive.box(_logsBoxName).clear();
    await Hive.box(_statsBoxName).clear();
    await Hive.box(_achievementsBoxName).clear();
  }
}

final allLogsProvider = StreamProvider<List<HydrationLog>>((ref) {
  return ref.watch(localDbServiceProvider).getHydrationLogs();
});

final userProfileProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(localDbServiceProvider).getUserProfile();
});

final userStatsProvider = StreamProvider<Map<String, dynamic>>((ref) {
  return ref.watch(localDbServiceProvider).getUserStats();
});

