import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../shared/constants.dart';

class EasyLoadingConfig {
  static void setup() {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..indicatorType = EasyLoadingIndicatorType.wave
      ..displayDuration = const Duration(seconds: 2)
      ..loadingStyle = EasyLoadingStyle.custom
      ..radius = 6
      ..progressColor = Constants.primaryColor
      ..backgroundColor = Colors.white
      ..indicatorColor = Constants.primaryColor
      ..textColor = Constants.primaryColor
      ..userInteractions = false
      ..dismissOnTap = false;
  }
}
