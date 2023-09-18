import 'package:flutter/material.dart';

import '../../../shared/extensions/app_styles_extension.dart';
import '../../../shared/extensions/iterable_extension.dart';
import 'widgets/index.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double widthContainer = context.screenWidth * .30;

    if (context.screenWidth < 800) {
      widthContainer = context.screenWidth * .8;
    } else if (context.screenWidth < 1300) {
      widthContainer = context.screenWidth * .42;
    }

    return SizedBox(
      width: widthContainer,
      child: Column(
        children: [
          const AuthorizationWidget(),
          const AccountWidget(),
        ].separator(const SizedBox(height: 21)).toList(),
      ),
    );
  }
}
