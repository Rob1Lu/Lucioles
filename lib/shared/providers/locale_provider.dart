import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gère la locale active et la persiste dans SharedPreferences.
///
/// Supporte : français (fr), anglais (en), espagnol (es).
/// Par défaut : français.
class LocaleProvider extends ChangeNotifier {
  static const _clePref = 'locale';

  static const supportedLocales = [
    Locale('fr'),
    Locale('en'),
    Locale('es'),
  ];

  /// Libellés affichés dans l'écran Profil
  static const Map<String, String> nomLangues = {
    'fr': 'Français',
    'en': 'English',
    'es': 'Español',
  };

  /// Drapeaux emoji associés à chaque locale
  static const Map<String, String> drapeaux = {
    'fr': '🇫🇷',
    'en': '🇬🇧',
    'es': '🇪🇸',
  };

  Locale _locale = const Locale('fr');
  Locale get locale => _locale;

  /// Charge la locale sauvegardée, ou garde le français par défaut.
  Future<void> charger() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_clePref);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  /// Change la locale active et la persiste.
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clePref, locale.languageCode);
  }
}
