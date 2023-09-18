import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../stores/auth/auth_store.dart';
import '../buttons/my_outlined_button.dart';

class RedirectToLogin {
  static Future<void> show(BuildContext context, String message) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(message),
        content: const Text(
          'Você será redirecionado para a tela de login',
        ),
        actions: [
          MyOutlinedButton(
            text: 'Ok',
            onPressed: () async {
              final authStore = Provider.of<AuthStore>(context, listen: false);
              await authStore.signOut();

              if (authStore.error == null && context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
