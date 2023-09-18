import 'package:flutter/material.dart';

import '../constants.dart';

extension AppStylesExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile => screenWidth < Constants.screenWidthMobile;
  bool get isTablet =>
      screenWidth >= Constants.screenWidthMobile &&
      screenWidth <= Constants.screenWidthTablet;
  bool get isDesktop => screenWidth > Constants.screenWidthTablet;
}
