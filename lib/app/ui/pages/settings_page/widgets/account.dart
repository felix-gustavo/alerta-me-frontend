import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../shared/extensions/colors_app_extension.dart';
import '../../../../shared/extensions/iterable_extension.dart';
import '../../../../stores/auth/auth_store.dart';
import '../../../../stores/user/delete_user/delete_user_store.dart';
import '../../../buttons/my_outlined_button.dart';
import '../../../common_components/my_dialog.dart';
import '../../../common_components/unordered_list_item.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
  late final DeleteUserStore _deleteUserStore;
  late final AuthStore _authStore;
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();

    _deleteUserStore = Provider.of<DeleteUserStore>(
      context,
      listen: false,
    );

    _authStore = Provider.of<AuthStore>(context, listen: false);

    _disposer = when(
        (_) =>
            _deleteUserStore.userId != null &&
            _authStore.authUser?.user.id == _deleteUserStore.userId, () async {
      await _authStore.signOut();
    });
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  Widget _buildField(String label, String value) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: 6,
      runSpacing: 6,
      children: [
        Text(label),
        Text(value, overflow: TextOverflow.ellipsis),
      ],
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => MyDialog(
        confirmPop: false,
        title: 'Excluir conta?',
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ao excluir sua conta: ',
              ),
              const SizedBox(height: 12),
              ...[
                'O pedido de autorização será removido',
                'A conta do usuário idoso não será removida'
              ].map((item) => UnorderedListItem(text: item)),
              const SizedBox(height: 27),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyOutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: 'Não',
                  ),
                  const SizedBox(width: 6),
                  _deleteUserStore.loading
                      ? const CircularProgressIndicator()
                      : MyOutlinedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await _deleteUserStore.run();
                            if (_deleteUserStore.errorMessage != null) {
                              EasyLoading.showInfo(
                                  _deleteUserStore.errorMessage!);
                            }
                          },
                          text: 'Sim',
                        ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

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
              'Minha conta',
              style: textTheme.titleMedium!.copyWith(color: Colors.black),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildField('Nome: ', authStore.user?.name ?? ''),
                _buildField('Email: ', authStore.user?.email ?? ''),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: MyOutlinedButton(
                    onPressed: _deleteAccount,
                    text: 'EXCLUIR CONTA',
                    color: context.colors.error,
                  ),
                ),
              ].separator(const SizedBox(height: 12)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
