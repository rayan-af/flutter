import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  ThemeData get currentTheme => _isDark ? AppTheme.darkTheme : AppTheme.freshTheme;

  String get currentThemeName => _isDark ? "Standard Dark" : "Bistro Peach";

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
