import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme _textTheme;

  const MaterialTheme(this._textTheme);
  ThemeData _theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: _textTheme.apply(
          bodyColor: colorScheme.onSurfaceVariant,
          displayColor: colorScheme.onSurfaceVariant,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        visualDensity: VisualDensity.compact,
        iconTheme: IconThemeData(
          color: colorScheme.onSecondaryContainer,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
          ),
        ),
        datePickerTheme: const DatePickerThemeData(
          // backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
        ),
        timePickerTheme: const TimePickerThemeData(
          // backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
        ),
        cardTheme: CardTheme(
          margin: EdgeInsets.zero,
          color: colorScheme.surfaceContainerLowest,
          elevation: 3,
          shadowColor: colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
        ),
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
          // backgroundColor: Colors.white,
        ),
        popupMenuTheme: const PopupMenuThemeData(
          // color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(9)),
          ),
        ),
      );

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff1558c6),
      surfaceTint: Color(0xff1558c6),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff739dff),
      onPrimaryContainer: Color(0xff001135),
      secondary: Color(0xff4d5d88),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffc6d4ff),
      onSecondaryContainer: Color(0xff2d3e67),
      tertiary: Color(0xff90399c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd97ce3),
      onTertiaryContainer: Color(0xff27002e),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffaf8ff),
      onSurface: Color(0xff191b22),
      onSurfaceVariant: Color(0xff424653),
      outline: Color(0xff737785),
      outlineVariant: Color(0xffc3c6d5),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3037),
      inversePrimary: Color(0xffb1c6ff),
      primaryFixed: Color(0xffd9e2ff),
      onPrimaryFixed: Color(0xff001946),
      primaryFixedDim: Color(0xffb1c6ff),
      onPrimaryFixedVariant: Color(0xff00419d),
      secondaryFixed: Color(0xffd9e2ff),
      onSecondaryFixed: Color(0xff041941),
      secondaryFixedDim: Color(0xffb5c6f7),
      onSecondaryFixedVariant: Color(0xff35466f),
      tertiaryFixed: Color(0xffffd6fd),
      onTertiaryFixed: Color(0xff36003f),
      tertiaryFixedDim: Color(0xfffaabff),
      onTertiaryFixedVariant: Color(0xff741d82),
      surfaceDim: Color(0xffd9d9e3),
      surfaceBright: Color(0xfffaf8ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fd),
      surfaceContainer: Color(0xffededf7),
      surfaceContainerHigh: Color(0xffe7e7f1),
      surfaceContainerHighest: Color(0xffe1e2eb),
    );
  }

  // static ColorScheme lightScheme() {
  //   return const ColorScheme(
  //     brightness: Brightness.light,
  //     primary: Color(0xff3b608f),
  //     surfaceTint: Color(0xff3b608f),
  //     onPrimary: Color(0xffffffff),
  //     primaryContainer: Color(0xffd4e3ff),
  //     onPrimaryContainer: Color(0xff001c39),
  //     secondary: Color(0xff226a4c),
  //     onSecondary: Color(0xffffffff),
  //     secondaryContainer: Color(0xffaaf2cc),
  //     onSecondaryContainer: Color(0xff002114),
  //     tertiary: Color(0xff615690),
  //     onTertiary: Color(0xffffffff),
  //     tertiaryContainer: Color(0xffe6deff),
  //     onTertiaryContainer: Color(0xff1d1148),
  //     error: Color(0xffba1a1a),
  //     onError: Color(0xffffffff),
  //     errorContainer: Color(0xffffdad6),
  //     onErrorContainer: Color(0xff410002),
  //     surface: Color(0xfff8f9ff),
  //     onSurface: Color(0xff191c20),
  //     onSurfaceVariant: Color(0xff43474e),
  //     outline: Color(0xff73777f),
  //     outlineVariant: Color(0xffc3c6cf),
  //     shadow: Color(0xff000000),
  //     scrim: Color(0xff000000),
  //     inverseSurface: Color(0xff2e3035),
  //     inversePrimary: Color(0xffa4c9fe),
  //     primaryFixed: Color(0xffd4e3ff),
  //     onPrimaryFixed: Color(0xff001c39),
  //     primaryFixedDim: Color(0xffa4c9fe),
  //     onPrimaryFixedVariant: Color(0xff204876),
  //     secondaryFixed: Color(0xffaaf2cc),
  //     onSecondaryFixed: Color(0xff002114),
  //     secondaryFixedDim: Color(0xff8ed5b1),
  //     onSecondaryFixedVariant: Color(0xff005236),
  //     tertiaryFixed: Color(0xffe6deff),
  //     onTertiaryFixed: Color(0xff1d1148),
  //     tertiaryFixedDim: Color(0xffcbbeff),
  //     onTertiaryFixedVariant: Color(0xff493e76),
  //     surfaceDim: Color(0xffd9dae0),
  //     surfaceBright: Color(0xfff8f9ff),
  //     surfaceContainerLowest: Color(0xffffffff),
  //     surfaceContainerLow: Color(0xfff2f3fa),
  //     surfaceContainer: Color(0xffededf4),
  //     surfaceContainerHigh: Color(0xffe7e8ee),
  //     surfaceContainerHighest: Color(0xffe1e2e9),
  //   );
  // }

  ThemeData light() {
    return _theme(lightScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb1c6ff),
      surfaceTint: Color(0xffb1c6ff),
      onPrimary: Color(0xff002c70),
      primaryContainer: Color(0xff3870de),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xffb5c6f7),
      onSecondary: Color(0xff1d2f57),
      secondaryContainer: Color(0xff2d3f67),
      onSecondaryContainer: Color(0xffc5d4ff),
      tertiary: Color(0xfffaabff),
      onTertiary: Color(0xff570065),
      tertiaryContainer: Color(0xffa951b4),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff11131a),
      onSurface: Color(0xffe1e2eb),
      onSurfaceVariant: Color(0xffc3c6d5),
      outline: Color(0xff8d909f),
      outlineVariant: Color(0xff424653),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2eb),
      inversePrimary: Color(0xff1558c6),
      primaryFixed: Color(0xffd9e2ff),
      onPrimaryFixed: Color(0xff001946),
      primaryFixedDim: Color(0xffb1c6ff),
      onPrimaryFixedVariant: Color(0xff00419d),
      secondaryFixed: Color(0xffd9e2ff),
      onSecondaryFixed: Color(0xff041941),
      secondaryFixedDim: Color(0xffb5c6f7),
      onSecondaryFixedVariant: Color(0xff35466f),
      tertiaryFixed: Color(0xffffd6fd),
      onTertiaryFixed: Color(0xff36003f),
      tertiaryFixedDim: Color(0xfffaabff),
      onTertiaryFixedVariant: Color(0xff741d82),
      surfaceDim: Color(0xff11131a),
      surfaceBright: Color(0xff373940),
      surfaceContainerLowest: Color(0xff0c0e14),
      surfaceContainerLow: Color(0xff191b22),
      surfaceContainer: Color(0xff1d1f26),
      surfaceContainerHigh: Color(0xff282a31),
      surfaceContainerHighest: Color(0xff32343c),
    );
  }

  ThemeData dark() {
    return _theme(darkScheme());
  }
}
