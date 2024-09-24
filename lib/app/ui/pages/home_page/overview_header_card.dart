import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../shared/extensions/datetime_extension.dart';
import '../../../shared/extensions/iterable_extension.dart';
import '../../../stores/auth/auth_store.dart';
import '../../../stores/authorization/autorization/authorization_store.dart';
import '../../../stores/brightness/brightness_store.dart';
import '../../../stores/elderly/load_elderly/load_elderly_store.dart';
import '../../common_components/confirm_dialog.dart';
import '../settings_page/index.dart';

class OverviewHeaderCard extends StatefulWidget {
  const OverviewHeaderCard({super.key});

  @override
  State<OverviewHeaderCard> createState() => _OverviewHeaderCardState();
}

class _OverviewHeaderCardState extends State<OverviewHeaderCard> {
  late final BrightnessStore _brightnessStore;

  late final AuthorizationStore _authorizationStore;
  late final LoadElderlyStore _loadElderlyStore;
  late final AuthStore _authStore;

  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();

    _brightnessStore = Provider.of<BrightnessStore>(
      context,
      listen: false,
    );

    _authorizationStore = Provider.of<AuthorizationStore>(
      context,
      listen: false,
    );
    _loadElderlyStore = Provider.of<LoadElderlyStore>(context, listen: false);
    _authStore = Provider.of<AuthStore>(context, listen: false);

    _disposer = reaction(
      (_) => _authorizationStore.authorization,
      (_) async => await _loadElderlyStore.run(),
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodyMedium = textTheme.bodyMedium;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text('Visão geral', style: textTheme.titleLarge),
            //     const SizedBox(height: 9),
            //   ],
            // ),
            Text(DateTime.now().toDateBRLExtension),
            Row(
              children: [
                Observer(
                  builder: (context) {
                    final lightMode = _brightnessStore.brightnessMode ==
                        Brightness.light.name;

                    return IconButton(
                      onPressed: () => _brightnessStore.changeBrightness(),
                      icon: Icon(
                        lightMode
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                      ),
                    );
                  },
                ),
                PopupMenuButton(
                  tooltip: '',
                  offset: const Offset(0, 39),
                  splashRadius: 21,
                  icon: const Icon(Icons.person_outline_rounded),
                  padding: EdgeInsets.zero,
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      enabled: false,
                      padding: const EdgeInsets.only(
                        left: 6,
                        right: 6,
                        bottom: 12,
                      ),
                      child: Observer(
                        builder: (context) {
                          final elderly = _loadElderlyStore.elderly;
                          final status =
                              _authorizationStore.authorization?.status;
                          final user = _authStore.userMin;

                          return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text('Minha Conta'),
                                if (user == null)
                                  Text('Sem informações', style: bodyMedium)
                                else ...[
                                  Text(user.name, style: bodyMedium),
                                  Text(user.email, style: bodyMedium),
                                ],
                                const SizedBox(height: 6),
                                const Text('Pessoa Idosa'),
                                if (elderly == null || status == null)
                                  Text(
                                    'Vincule-se a uma pessoa idosa',
                                    style: bodyMedium,
                                  )
                                else ...[
                                  Text(elderly.email, style: bodyMedium),
                                  Text(
                                    'status: ${status.name}',
                                    style: bodyMedium,
                                  ),
                                  Text(
                                    'Permite notificações? ${elderly.askUserId != null ? 'sim' : 'não'}',
                                    style: bodyMedium,
                                  ),
                                ],
                              ].separator(const SizedBox(height: 6)),
                            ),
                          );
                        },
                      ),
                    ),
                    PopupMenuItem(
                      value: 'settings',
                      onTap: () => showDialog(
                        context: context,
                        builder: (_) => const SettingsPage(),
                      ),
                      child: const ListTile(
                        leading: Icon(Icons.settings),
                        title: Text('CONFIGURAÇÕES'),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'signOut',
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: 'Sair',
                          content: 'Deseja realmente sair do sistema?',
                          positiveBtnText: 'SIM',
                          onPostivePressed: () async =>
                              await _authStore.signOut(),
                          negativeBtnText: 'NÃO',
                        ),
                      ),
                      child: const ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('SAIR'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
