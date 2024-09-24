import 'package:flutter/material.dart';

import '../../common_components/my_dialog.dart';
import 'widgets/account.dart';
import 'widgets/authorization.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyDialog(
      canPop: true,
      title: 'Configurações',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthorizationWidget(),
          SizedBox(height: 18),
          AccountWidget(),
        ],
      ),
    );
  }
}
