// import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:unnati_app/services/language_service.dart';

class LanguageNotifier extends StateNotifier<Locale> {
  LanguageNotifier() : super(const Locale('en')) {
    _loadSavedLanguage();
  }
  final _service = LanguagePreferenceService();
  Future<void> _loadSavedLanguage() async {
    final savedLocale = await _service.getSavedLocale();

    if (savedLocale != null) {
      state = savedLocale;
    }
  }

  Future<void> toggleLanguage() async {
    final nextLocale = state.languageCode == 'en'
        ? const Locale('hi')
        : const Locale('en');

    await _service.saveLocale(nextLocale);

    state = nextLocale;
  }

  void setLanguage(Locale locale) async {
    await _service.saveLocale(locale);
    state = locale;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});
