import 'dart:ui';
import 'package:flutter/material.dart';
import '../shared/extensions/colors_app_extension.dart';

class MyThemeData {
  static ThemeData themeData = ThemeData(
      scaffoldBackgroundColor: ColorsApp.i.scaffoldBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: ColorsApp.i.primary,
        primary: ColorsApp.i.primary,
        secondary: ColorsApp.i.secondary,
      ),
      dividerTheme: const DividerThemeData(space: 0, thickness: 1),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      ),
      textTheme: _fixBlurryTextIssue(const TextTheme()),
      cardTheme: CardTheme(
        margin: EdgeInsets.zero,
        elevation: 12,
        shadowColor: ColorsApp.i.primaryLight,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        visualDensity: VisualDensity.compact,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
      ));

  static TextTheme _fixBlurryTextIssue(TextTheme theme) {
    const style = TextStyle(fontFeatures: [FontFeature.proportionalFigures()]);
    return theme.merge(const TextTheme(
      displayLarge: style,
      displayMedium: style,
      displaySmall: style,
      headlineLarge: style,
      headlineMedium: style,
      headlineSmall: style,
      titleLarge: style,
      titleMedium: style,
      titleSmall: style,
      bodyLarge: style,
      bodyMedium: style,
      bodySmall: style,
      labelLarge: style,
      labelMedium: style,
      labelSmall: style,
    ));
  }
}
