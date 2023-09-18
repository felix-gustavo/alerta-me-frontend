import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../shared/extensions/colors_app_extension.dart';
import '../../../../stores/auth/auth_store.dart';
import '../../../buttons/my_outlined_button.dart';

class AccountWidget extends StatelessWidget {
  const AccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = Provider.of<AuthStore>(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.lightGrey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Conta',
              style: textTheme.titleMedium!.copyWith(color: Colors.black),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const Text('Nome'),
                    Expanded(
                      child: Text(
                        authStore.user?.name ?? '',
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Email'),
                    Expanded(
                      child: Text(
                        authStore.user?.email ?? '',
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 21),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyOutlinedButton(
                    onPressed: () {},
                    text: 'EXCLUIR CONTA',
                    color: context.colors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
