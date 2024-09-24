import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

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

  void _deleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => MyDialog.confirm(
        title: 'Excluir conta?',
        loading: _deleteUserStore.loading,
        action: () async {
          Navigator.of(context).pop();
          await _deleteUserStore.run();
          if (_deleteUserStore.errorMessage != null) {
            EasyLoading.showInfo(_deleteUserStore.errorMessage!);
          }
        },
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Observer(
      builder: (context) {
        final userMin = Provider.of<AuthStore>(
          context,
          listen: false,
        ).userMin;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Minha conta'),
            const SizedBox(height: 12),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (userMin != null) ...[
                      Text(
                        'Nome: ${userMin.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Email: ${userMin.email}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else
                      Text('Sem informações', style: textTheme.bodyMedium),
                    OutlinedButton(
                      onPressed: _deleteAccountDialog,
                      child: const Text('Excluir minha conta'),
                    ),
                  ].separator(const SizedBox(height: 12)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
