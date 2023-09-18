import 'package:flutter/material.dart';

class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get i {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get primary => const Color(0xFF0A83E6);
  Color get primaryLight => const Color(0xFFEAF5FD);
  Color get primaryDark => const Color(0xFF0A3C65);
  Color get secondary => const Color(0xFF2cc477);
  Color get secondaryLight => const Color(0xFFE5F8EE);
  Color get secondaryDark => const Color(0xFF0A532E);
  Color get scaffoldBackground => const Color(0xFFF4F7F9);
  Color get grey => const Color(0xFF666666);
  Color get lightGrey => const Color(0xFFE1E1E1);
  Color get error => const Color(0xFFE11B0E);
}

extension ColorsAppExtension on BuildContext {
  ColorsApp get colors => ColorsApp.i;
}
