import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _preferences;

  static const String _themeModeKey = 'app_theme_mode';

  const SharedPreferencesService(this._preferences);

  Future<bool> saveThemeMode(ThemeMode themeMode) async {
    return _preferences.setString(_themeModeKey, themeMode.name);
  }

  ThemeMode getSavedThemeMode() {
    final savedMode = _preferences.getString(_themeModeKey);
    switch (savedMode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  String? getString(String key) => _preferences.getString(key);

  Future<bool> setString(String key, String value) =>
      _preferences.setString(key, value);

  bool? getBool(String key) => _preferences.getBool(key);

  Future<bool> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  int? getInt(String key) => _preferences.getInt(key);

  Future<bool> setInt(String key, int value) => _preferences.setInt(key, value);

  Future<bool> remove(String key) => _preferences.remove(key);

  Future<bool> clear() => _preferences.clear();
}
