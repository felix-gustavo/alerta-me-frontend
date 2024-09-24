import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../model/authorizations.dart';
import '../../../../model/users.dart';
import '../../../../shared/extensions/datetime_extension.dart';
import '../../../../shared/extensions/iterable_extension.dart';
import '../../../../stores/authorization/autorization/authorization_store.dart';
import '../../../../stores/authorization/create_autorization/create_autorization_store.dart';
import '../../../../stores/authorization/delete_autorization/delete_authorization_store.dart';
import '../../../../stores/elderly/load_elderly/load_elderly_store.dart';
import '../../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../../../../stores/user/delete_elderly/delete_elderly_store.dart';
import '../../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import '../../../common_components/confirm_dialog.dart';
import '../../../common_components/my_dialog.dart';
import '../../../common_components/unordered_list_item.dart';
import '../../../validators/email_validator.dart';

class AuthorizationWidget extends StatefulWidget {
  const AuthorizationWidget({super.key});

  @override
  State<AuthorizationWidget> createState() => _AuthorizationWidgetState();
}

class _AuthorizationWidgetState extends State<AuthorizationWidget> {
  String email = '';
  late final GlobalKey<FormState> _formKey;
  late final CreateAuthorizationStore _createAuthorizationStore;
  late final LoadElderlyStore _loadElderlyStore;
  late final AuthorizationStore _authorizationStore;
  late final DeleteAuthorizationStore _deleteAuthorizationStore;
  late final DeleteElderlyStore _deleteElderlyStore;

  late final LoadWaterReminderStore _loadWaterReminderStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;
  late final LoadMedicationReminderStore _loadMedicationReminderStore;

  late final List<ReactionDisposer?> _disposers;

  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    _loadElderlyStore = Provider.of<LoadElderlyStore>(
      context,
      listen: false,
    );

    _createAuthorizationStore = Provider.of<CreateAuthorizationStore>(
      context,
      listen: false,
    );

    _authorizationStore = Provider.of<AuthorizationStore>(
      context,
      listen: false,
    );

    _deleteAuthorizationStore = Provider.of<DeleteAuthorizationStore>(
      context,
      listen: false,
    );

    _deleteElderlyStore = Provider.of<DeleteElderlyStore>(
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

    _disposers = [
      when(
        (_) =>
            _createAuthorizationStore.authorization != null &&
            _authorizationStore.authorization?.id !=
                _createAuthorizationStore.authorization?.id,
        () async {
          print('authorization é diferente de createAuthorization');
          _authorizationStore.setAuthorization(
            _createAuthorizationStore.authorization,
          );
          await _loadElderlyStore.run();
          _createAuthorizationStore.clear();
        },
      ),
      when(
        (_) {
          final authorizationId = _authorizationStore.authorization?.id;
          final deleteAuthoriId = _deleteAuthorizationStore.authorizationId;
          return deleteAuthoriId != null && deleteAuthoriId == authorizationId;
        },
        () {
          print('_authorizationStore == _deleteAuthorizationStore');
          _clearStores();
          _deleteAuthorizationStore.clear();
        },
      ),
      when(
        (_) {
          final elderlyId = _authorizationStore.authorization?.elderly;
          final deleteElderlyId = _deleteElderlyStore.elderlyId;
          return deleteElderlyId != null &&
              deleteElderlyId == elderlyId &&
              _deleteElderlyStore.errorMessage == null;
        },
        () {
          print('_authorizationStore == _deleteElderlyStore');
          _clearStores();
          _deleteElderlyStore.clear();
        },
      ),
    ];
  }

  void _clearStores() {
    _authorizationStore.clear();
    _loadElderlyStore.clear();
    _loadWaterReminderStore.clear();
    _loadMedicalReminderStore.clear();
    _loadMedicationReminderStore.clear();
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _disposers.map((disposer) => disposer?.call());
    super.dispose();
  }

  void _submit() async {
    if (isValid) {
      _formKey.currentState!.save();

      final authorization = _authorizationStore.authorization;

      await _createAuthorizationStore.run(email: email);
      if (_createAuthorizationStore.errorMessage != null) {
        EasyLoading.showInfo(_createAuthorizationStore.errorMessage!);
      } else if (authorization != null) {
        await _deleteAuthorizationStore.run();
        if (_deleteAuthorizationStore.errorMessage != null) {
          EasyLoading.showInfo(_deleteAuthorizationStore.errorMessage!);
        }
      }
    }
  }

  void _deleteElderly(String elderlyId) {
    showDialog(
      context: context,
      builder: (context) => MyDialog.confirm(
        title: 'Excluir conta?',
        loading: _deleteElderlyStore.loading,
        action: () async {
          Navigator.of(context).pop();
          await _deleteElderlyStore.run(id: elderlyId);
          if (_deleteElderlyStore.errorMessage != null) {
            EasyLoading.showInfo(_deleteElderlyStore.errorMessage!);
          }
        },
        child: SizedBox(
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ao excluir a conta da pessoa idosa: ',
              ),
              const SizedBox(height: 12),
              ...[
                'Todos os lembretes serão removidos',
                'O pedido de autorização será removido'
              ].map((item) => UnorderedListItem(text: item)),
              const SizedBox(height: 12),
              const Text(
                'Caso queira apenas se desvincular da pessoa idosa, sugiro que cancele a autorização',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteAuthorization() {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Cancelar autorização?',
        content:
            'Ao cancelar a autorização, você não poderá gerenciar os lembretes desse usuário',
        positiveBtnText: 'Sim',
        negativeBtnText: 'Não',
        onPostivePressed: () async {
          final navigator = Navigator.of(context);
          await _deleteAuthorizationStore.run();
          if (_deleteAuthorizationStore.errorMessage != null) {
            EasyLoading.showInfo(
              _deleteAuthorizationStore.errorMessage!,
            );
          }

          navigator.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Observer(
      builder: (_) {
        final authorization = _authorizationStore.authorization;
        final Users? elderly = _loadElderlyStore.elderly;

        final approved = authorization?.status == AuthorizationStatus.aprovado;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Autorização'),
                if (authorization != null)
                  TextButton(
                    onPressed: _deleteAuthorization,
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text('Cancelar'),
                  )
              ],
            ),
            const SizedBox(height: 12),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (authorization != null && elderly != null) ...[
                      Text(
                        'Nome: ${elderly.name}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Email: ${elderly.email}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Status: ',
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: approved
                                      ? Colors.green[50]
                                      : Colors.yellow[200],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  authorization.status.name,
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: approved
                                        ? Colors.green[800]
                                        : textTheme.bodyMedium!.decorationColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Criado em: ${authorization.datetime.toDateBRL}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text.rich(
                        TextSpan(
                          text: 'Permite notificações? ',
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  elderly.askUserId != null ? 'sim' : 'não',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else
                      Container(
                        constraints: const BoxConstraints(maxWidth: 350),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (_authorizationStore.authorization != null)
                              const Divider(height: 24),
                            const Text(
                              'Para registrar o pedido de autorização, digite o email da pessoa idosa',
                            ),
                            const SizedBox(height: 21),
                            Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: TextFormField(
                                initialValue: email,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  helperText: '',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  final error =
                                      EmailValidator().validator(value);
                                  if ((error == null) != isValid) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      setState(() => isValid = !isValid);
                                    });
                                  }

                                  return error;
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) email = newValue;
                                },
                              ),
                            ),
                            _createAuthorizationStore.loading
                                ? const CircularProgressIndicator()
                                : FilledButton(
                                    onPressed: isValid ? _submit : null,
                                    child: const Text('Registrar pedido'),
                                  ),
                          ],
                        ),
                      ),
                    if (approved)
                      OutlinedButton(
                        onPressed: () => _deleteElderly(authorization!.elderly),
                        child: const Text('Excluir pessoa idosa'),
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
