import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LanguageConstants {
  static const kLocalizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const kSupportedLocales = [
    Locale('pt', 'BR'),
  ];
}
