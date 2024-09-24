import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../../stores/auth/auth_store.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bodyLargeStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant);

    return Scaffold(
      body: Center(
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(54),
            width: 601,
            height: 462,
            child: Observer(
              builder: (_) {
                final authStore = Provider.of<AuthStore>(
                  context,
                  listen: false,
                );

                return Column(
                  children: [
                    Text(
                      'Login',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 42),
                    Text(
                      'Bem-vindo(a) ao AlertaMe!',
                      textAlign: TextAlign.center,
                      style: bodyLargeStyle,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Por favor, faça login como cuidador para acessar as funcionalidades do gerenciamento de lembretes',
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(flex: 4),
                    Visibility(
                      visible: authStore.loading,
                      replacement: authStore.errorMessage != null
                          ? Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(authStore.errorMessage ?? ''),
                                  const SizedBox(width: 6),
                                  Icon(
                                    Icons.error,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error
                                        .withOpacity(.9),
                                    size: 21,
                                  )
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                      child: const CircularProgressIndicator(),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed:
                          authStore.loading ? null : () => authStore.signIn(),
                      child: const Text('Login com Google'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
