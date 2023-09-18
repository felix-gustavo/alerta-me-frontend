import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../model/authorizations.dart';
import '../../../../shared/extensions/colors_app_extension.dart';
import '../../../../stores/authorization/create_autorization/create_autorization_store.dart';
import '../../../../stores/authorization/load_autorization/load_authorization_store.dart';
import '../../../buttons/my_outlined_button.dart';
import '../../../validators/email_validator.dart';

class AuthorizationWidget extends StatefulWidget {
  const AuthorizationWidget({super.key});

  @override
  State<AuthorizationWidget> createState() => _AuthorizationWidgetState();
}

class _AuthorizationWidgetState extends State<AuthorizationWidget> {
  String email = '';
  late final GlobalKey<FormState> _formKey;
  late final LoadAuthorizationStore _loadAuthorizationStore;
  late final CreateAuthorizationStore _createAuthorizationStore;

  late final ReactionDisposer _disposer;

  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    _loadAuthorizationStore = Provider.of<LoadAuthorizationStore>(
      context,
      listen: false,
    );

    _createAuthorizationStore = Provider.of<CreateAuthorizationStore>(
      context,
      listen: false,
    );

    _disposer = reaction(
      (_) => _createAuthorizationStore.authorization,
      (authorization) {
        if (authorization != null) {
          _loadAuthorizationStore.setAuthorization(authorization);
        }
      },
    );
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _disposer();
    super.dispose();
  }

  void _submit() async {
    if (isValid) {
      _formKey.currentState!.save();
      await _createAuthorizationStore.run(email: email);

      if (_createAuthorizationStore.errorMessage != null) {
        EasyLoading.showError(_createAuthorizationStore.errorMessage!);
      }
    }
  }

  Widget _buildWithoutAuthReq() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Para registrar o pedido de autorização, digite o email da pessoa idosa',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: context.colors.grey),
        ),
        const SizedBox(height: 21),
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
  }

  Widget _buildWithAuthReq(Authorizations? authorization) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Status'),
            Text(
              authorization?.status.name ?? '',
              style: textTheme.bodyMedium!.copyWith(
                color: context.colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text('Email'),
            ),
            Expanded(
              flex: 5,
              child: Text(
                authorization?.elderly.email ?? '',
                textAlign: TextAlign.end,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: context.colors.grey,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 21),
        Align(
          alignment: Alignment.centerRight,
          child: MyOutlinedButton(onPressed: () {}, text: 'CANCELAR PEDIDO'),
        ),
      ],
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
          final authorization = _loadAuthorizationStore.authorization;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      'Pedido de autorização',
                      style: textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 3),
                    if (authorization == null)
                      const Tooltip(
                        message: 'Não há pedidos de autorização',
                        child: Icon(Icons.help_center_outlined, size: 21),
                      ),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: _loadAuthorizationStore.loading
                    ? const Center(child: CircularProgressIndicator())
                    : Visibility(
                        visible: authorization != null,
                        replacement: _buildWithoutAuthReq(),
                        child: _buildWithAuthReq(authorization),
                      ),
              )
            ],
          );
        },
      ),
    );
  }
}
