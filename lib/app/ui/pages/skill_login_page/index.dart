import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../services/auth/providers/login_provider.dart';
import '../../../shared/extensions/colors_app_extension.dart';
import '../../../stores/auth/auth_store.dart';

class SkillLoginPage extends StatelessWidget {
  const SkillLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.all(54),
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.lightGrey),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          width: 601,
          height: 462,
          child: Observer(
            builder: (context) {
              return Column(
                children: [
                  Text(
                    'Login',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: context.colors.grey),
                  ),
                  const SizedBox(height: 42),
                  Text(
                    'Bem-vindo(a) ao AlertaMe Skill!',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge!
                        .copyWith(color: context.colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Por favor, faça login como idoso para se comunicar por voz',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge!
                        .copyWith(color: context.colors.grey),
                  ),
                  const Spacer(flex: 4),
                  Visibility(
                    visible: authStore.loading,
                    replacement: authStore.error != null
                        ? Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: context.colors.lightGrey),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(authStore.error ?? ''),
                                const SizedBox(width: 6),
                                Icon(
                                  Icons.error,
                                  color: context.colors.error.withOpacity(.9),
                                  size: 21,
                                )
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                    child: const CircularProgressIndicator(),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      await authStore.signIn(LoginProviders.skill);
                    },
                    child: const Text('Usuário Idoso Demo 2'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
