import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../model/authorizations.dart';
import '../../../../model/users.dart';
import '../../../../shared/extensions/colors_app_extension.dart';
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

class AuthorizarionWidget extends StatefulWidget {
  const AuthorizarionWidget({super.key});

  @override
  State<AuthorizarionWidget> createState() => _AuthorizarionWidgetState();
}

class _AuthorizarionWidgetState extends State<AuthorizarionWidget> {
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
          return deleteElderlyId != null && deleteElderlyId == elderlyId;
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

  void _deleteElderly(String elderlyId) {
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
              const SizedBox(height: 27),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Não'),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await _deleteElderlyStore.run(id: elderlyId);
                      if (_deleteElderlyStore.errorMessage != null) {
                        EasyLoading.showInfo(_deleteElderlyStore.errorMessage!);
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

  void _submit() async {
    if (isValid) {
      _formKey.currentState!.save();

      final authorization = _authorizationStore.authorization;
      final elderly = _loadElderlyStore.elderly;
      if (authorization?.status == AuthorizationStatus.negado &&
          email == elderly?.email) {
        showDialog(
          context: context,
          builder: (context) => const MyDialog(
            confirmPop: false,
            title: 'Pedido não registrado',
            child: SizedBox(
              width: 330,
              child: Column(
                children: [
                  Text(
                      'Tente enviar a solicitação para outro usuário ou peça para o usuário idoso reavaliar a sua solicitação atual'),
                ],
              ),
            ),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return ConfirmDialog(
              title: 'Confirmar pedido de autorização',
              content: authorization?.status == AuthorizationStatus.negado
                  ? 'Ao registrar um novo pedido, a solicitação para ${elderly?.email} será removida'
                  : null,
              positiveBtnText: 'Continuar',
              negativeBtnText: 'Cancelar',
              onPostivePressed: () async {
                Navigator.of(context).pop();

                await _createAuthorizationStore.run(email: email);
                if (_createAuthorizationStore.errorMessage != null) {
                  EasyLoading.showInfo(
                    _createAuthorizationStore.errorMessage!,
                  );
                } else if (authorization != null) {
                  await _deleteAuthorizationStore.run();
                  if (_deleteAuthorizationStore.errorMessage != null) {
                    EasyLoading.showInfo(
                      _deleteAuthorizationStore.errorMessage!,
                    );
                  }
                }
              },
            );
          },
        );
      }
    }
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

  Widget _buildNewAuthorization() {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_authorizationStore.authorization != null)
              const Divider(height: 24),
            Text(
              'Para registrar o pedido de autorização, digite o email da pessoa idosa',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: context.colors.grey),
            ),
            const SizedBox(height: 12),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: TextFormField(
                initialValue: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  helperText: '',
                ),
                validator: (value) {
                  final error = EmailValidator().validator(value);
                  if ((error == null) != isValid) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() => isValid = !isValid);
                    });
                  }

                  return error;
                },
                onSaved: (newValue) {
                  if (newValue != null) {
                    email = newValue;
                  }
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _createAuthorizationStore.loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: isValid ? _submit : null,
                      child: const Text('Registrar pedido'),
                    ),
            )
          ],
        );
      },
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
      child: Observer(
        builder: (_) {
          final authorization = _authorizationStore.authorization;
          List<Widget> fields = [];

          if (authorization != null) {
            final Users? elderly = _loadElderlyStore.elderly;
            fields.add(_buildField('Nome: ', elderly?.name ?? ''));
            fields.add(_buildField('Email: ', elderly?.email ?? ''));
            fields.add(_buildField('Status: ', authorization.status.name));
            fields = fields.separator(const SizedBox(height: 12)).toList();
          }

          if (authorization?.status == AuthorizationStatus.aprovado) {
            fields = [
              ...fields,
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                runSpacing: 6,
                children: [
                  Text(
                    'Você pode excluir a conta do usuário idoso',
                    style: textTheme.bodySmall!.copyWith(
                      color: context.colors.grey,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => _deleteElderly(authorization!.elderly),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.colors.error,
                      side: BorderSide(color: context.colors.error),
                    ),
                    child: const Text('EXCLUIR CONTA'),
                  ),
                ],
              ),
            ];
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Autorização',
                      style: textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    if (!(authorization == null ||
                        authorization.status == AuthorizationStatus.negado))
                      OutlinedButton(
                        onPressed: () {
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
                                if (_deleteAuthorizationStore.errorMessage !=
                                    null) {
                                  EasyLoading.showInfo(
                                    _deleteAuthorizationStore.errorMessage!,
                                  );
                                }

                                navigator.pop();
                              },
                            ),
                          );
                        },
                        child: const Text('CANCELAR'),
                      ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...fields,
                    if (authorization == null ||
                        authorization.status == AuthorizationStatus.negado)
                      _buildNewAuthorization(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
