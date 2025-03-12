import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart' show ThemeMode;

class ThemeService {
  static const String _themeModeKey = 'theme_mode';

  static const Map<ThemeMode, String> themeModeNames = {
    ThemeMode.light: '浅色模式',
    ThemeMode.dark: '深色模式',
    ThemeMode.system: '跟随系统',
  };

  static Future<ThemeMode> getCurrentThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.toString() == themeModeString,
      orElse: () => ThemeMode.system,
    );
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.toString());
  }

  static String getThemeModeName(ThemeMode mode) {
    return themeModeNames[mode]!;
  }
} 