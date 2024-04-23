import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../shared/extensions/colors_app_extension.dart';
import '../../../../shared/extensions/iterable_extension.dart';
import '../../../../stores/auth/auth_store.dart';
import '../../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../../../../stores/user/delete_user/delete_user_store.dart';
import '../../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
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

  late final LoadWaterReminderStore _loadWaterReminderStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;
  late final LoadMedicationReminderStore _loadMedicationReminderStore;

  @override
  void initState() {
    super.initState();

    _deleteUserStore = Provider.of<DeleteUserStore>(
      context,
      listen: false,
    );

    _loadWaterReminderStore = Provider.of<LoadWaterReminderStore>(
      context,
      listen: false,
    );
    _loadMedicalReminderStore = Provider.of<LoadMedicalReminderStore>(
      context,
      listen: false,
    );
    _loadMedicationReminderStore = Provider.of<LoadMedicationReminderStore>(
      context,
      listen: false,
    );

    _authStore = Provider.of<AuthStore>(context, listen: false);

    _disposer = when(
      (_) => _deleteUserStore.userId != null,
      () {
        print(
            '_deleteUserStore.userId != null && _authStore.authUser?.user.id == _deleteUserStore.userId');
        _loadWaterReminderStore.clear();
        _loadMedicalReminderStore.clear();
        _loadMedicationReminderStore.clear();
        _deleteUserStore.clear();
        _authStore.signOut();
      },
    );
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
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Não'),
                  ),
                  const SizedBox(width: 6),
                  _deleteUserStore.loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await _deleteUserStore.run();
                            if (_deleteUserStore.errorMessage != null) {
                              EasyLoading.showInfo(
                                  _deleteUserStore.errorMessage!);
                            }
                          },
                          child: const Text('Sim'),
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
            child: Observer(
              builder: (context) {
                final userMin = Provider.of<AuthStore>(context).userMin;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildField('Nome: ', userMin?.name ?? ''),
                    _buildField('Email: ', userMin?.email ?? ''),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        onPressed: _deleteAccount,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: context.colors.error,
                          side: BorderSide(color: context.colors.error),
                        ),
                        child: const Text('EXCLUIR CONTA'),
                      ),
                    ),
                  ].separator(const SizedBox(height: 12)).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
