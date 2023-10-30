import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'OPS! PÁGINA NÃO ENCONTRADA!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Parece que você tentou acessar uma página desconhecida',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 33),
          ElevatedButton(
            onPressed: () => context.go('/home'),
            child: const Text('VOLTAR AO INÍCIO'),
          ),
        ],
      ),
    );
  }
}
