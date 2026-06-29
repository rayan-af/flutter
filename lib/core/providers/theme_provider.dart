import 'package:flutter/material.dart';
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

part 'theme_provider.g.dart';

const String _kThemePrefsKey = 'themeMode';

/// 3 possible theme modes:
///   'light'  → fresh / light theme
///   'dark'   → modern dark theme
///   'black'  → AMOLED "boîte noire" theme
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  FutureOr<String> build() async {
    return _loadPreference();
  }

  Future<String> _loadPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Migrate old bool key → new string key
      final legacy = prefs.getBool('isDark');
      if (legacy != null && !prefs.containsKey(_kThemePrefsKey)) {
        final mode = legacy ? 'dark' : 'light';
        await prefs.setString(_kThemePrefsKey, mode);
        await prefs.remove('isDark');
        return mode;
      }
      return prefs.getString(_kThemePrefsKey) ?? 'dark';
    } catch (e) {
      return 'dark';
    }
  }

  Future<void> toggleTheme() async {
    final current = state.value ?? 'dark';
    // Cycle: light → dark → black → light
    final next = current == 'light'
        ? 'dark'
        : current == 'dark'
            ? 'black'
            : 'light';
    await setThemeMode(next);
  }

  Future<void> setThemeMode(String mode) async {
    final previousState = state;
    state = AsyncData(mode);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kThemePrefsKey, mode);
    } catch (e) {
      state = previousState;
    }
  }
}

@riverpod
ThemeData currentTheme(Ref ref) {
  final modeAsync = ref.watch(themeProvider);
  final mode = modeAsync.value ?? 'dark';
  switch (mode) {
    case 'black':
      return AppTheme.blackTheme;
    case 'light':
      return AppTheme.freshTheme;
    case 'dark':
    default:
      return AppTheme.darkTheme;
  }
}

@riverpod
String currentThemeName(Ref ref) {
  final modeAsync = ref.watch(themeProvider);
  return modeAsync.value ?? 'dark';
}

/// Convenience: is the current mode one of the dark variants?
@riverpod
bool isDarkMode(Ref ref) {
  final name = ref.watch(currentThemeNameProvider);
  return name == 'dark' || name == 'black';
}
