import 'package:flutter/material.dart';

import '../../../shared/extensions/app_styles_extension.dart';
import '../../../shared/extensions/iterable_extension.dart';

import 'widgets/account.dart';
import 'widgets/authorization.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
          const AuthorizarionWidget(),
          const AccountWidget(),
        ].separator(const SizedBox(height: 21)).toList(),
      ),
    );
  }
}
