import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../stores/auth/auth_store.dart';

class SkillLoggedPage extends StatefulWidget {
  const SkillLoggedPage({super.key});

  @override
  State<SkillLoggedPage> createState() => _SkillLoggedPageState();
}

class _SkillLoggedPageState extends State<SkillLoggedPage> {
  String? getUserName() {
    final authStore = Provider.of<AuthStore>(context, listen: false);
    return authStore.user?.name;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'USUÁRIO LOGADO',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Você está conectado como ${getUserName()}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 33),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}
