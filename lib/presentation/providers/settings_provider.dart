import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// ── Settings State ─────────────────────────────────────────
class AppSettings {
  final bool darkMode;
  final bool pushNotifications;
  final bool examReminders;
  final bool deadlineAlerts;
  final String languageCode;

  const AppSettings({
    this.darkMode = true,
    this.pushNotifications = true,
    this.examReminders = true,
    this.deadlineAlerts = true,
    this.languageCode = 'en',
  });

  AppSettings copyWith({
    bool? darkMode,
    bool? pushNotifications,
    bool? examReminders,
    bool? deadlineAlerts,
    String? languageCode,
  }) {
    return AppSettings(
      darkMode: darkMode ?? this.darkMode,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      examReminders: examReminders ?? this.examReminders,
      deadlineAlerts: deadlineAlerts ?? this.deadlineAlerts,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

// ── Settings Notifier ──────────────────────────────────────
class SettingsNotifier extends StateNotifier<AppSettings> {
  static const _boxName = 'appSettings';
  late Box _box;

  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _box = await Hive.openBox(_boxName);
    state = AppSettings(
      darkMode: _box.get('darkMode', defaultValue: true),
      pushNotifications: _box.get('pushNotifications', defaultValue: true),
      examReminders: _box.get('examReminders', defaultValue: true),
      deadlineAlerts: _box.get('deadlineAlerts', defaultValue: true),
      languageCode: _box.get('languageCode', defaultValue: 'en'),
    );
  }

  void setDarkMode(bool val) {
    state = state.copyWith(darkMode: val);
    _box.put('darkMode', val);
  }

  void setPushNotifications(bool val) {
    state = state.copyWith(pushNotifications: val);
    _box.put('pushNotifications', val);
  }

  void setExamReminders(bool val) {
    state = state.copyWith(examReminders: val);
    _box.put('examReminders', val);
  }

  void setDeadlineAlerts(bool val) {
    state = state.copyWith(deadlineAlerts: val);
    _box.put('deadlineAlerts', val);
  }

  void setLanguageCode(String code) {
    state = state.copyWith(languageCode: code);
    _box.put('languageCode', code);
  }
}

// ── Provider ──────────────────────────────────────────────
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>(
        (ref) => SettingsNotifier());

// ThemeMode provider derived from settings
final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.darkMode ? ThemeMode.dark : ThemeMode.light;
});

final appLocaleProvider = Provider<Locale>((ref) {
  final settings = ref.watch(settingsProvider);
  return Locale(settings.languageCode);
});
