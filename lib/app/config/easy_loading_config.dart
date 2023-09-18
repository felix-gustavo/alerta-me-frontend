import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../shared/extensions/colors_app_extension.dart';

class EasyLoadingConfig {
  static void setup() {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..indicatorType = EasyLoadingIndicatorType.wave
      ..displayDuration = const Duration(seconds: 2)
      ..loadingStyle = EasyLoadingStyle.custom
      ..radius = 6
      ..progressColor = ColorsApp.i.primary
      ..backgroundColor = Colors.white
      ..indicatorColor = ColorsApp.i.primary
      ..textColor = ColorsApp.i.primary
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}
