import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/shared_preferences_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPreferencesService _prefsService;

  ThemeCubit(this._prefsService)
      : super(ThemeState(themeMode: _prefsService.getSavedThemeMode()));

  void toggleTheme() {
    final newMode = state.isDark ? ThemeMode.light : ThemeMode.dark;
    _prefsService.saveThemeMode(newMode);
    emit(ThemeState(themeMode: newMode));
  }

  void setTheme(ThemeMode mode) {
    _prefsService.saveThemeMode(mode);
    emit(ThemeState(themeMode: mode));
  }
}
