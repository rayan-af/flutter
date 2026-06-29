import 'package:flutter/material.dart';
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'language_provider.g.dart';

const String _kLanguagePrefsKey = 'languageCode';

@riverpod
class LanguageNotifier extends _$LanguageNotifier {
  @override
  FutureOr<Locale> build() async {
    return _loadPreference();
  }

  Future<Locale> _loadPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? languageCode = prefs.getString(_kLanguagePrefsKey);
      if (languageCode != null) {
        return Locale(languageCode);
      }
      return const Locale('en');
    } catch (e) {
      return const Locale('en');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    final previousState = state;
    state = AsyncData(Locale(languageCode));
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLanguagePrefsKey, languageCode);
    } catch (e) {
      state = previousState;
    }
  }
}

@riverpod
Locale currentLocale(Ref ref) {
  return ref.watch(languageProvider).value ?? const Locale('en');
}
