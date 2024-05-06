import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../model/authorizations.dart';
import '../../../shared/extensions/colors_app_extension.dart';
import '../../../shared/extensions/datetime_extension.dart';
import '../../../shared/extensions/iterable_extension.dart';
import '../../../stores/auth/auth_store.dart';
import '../../../stores/authorization/autorization/authorization_store.dart';
import '../../../stores/elderly/load_elderly/load_elderly_store.dart';
import '../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import '../../common_components/confirm_dialog.dart';
import '../../common_components/my_dialog.dart';
import '../settings_page/index.dart';
import 'widgets/medical_reminder/index.dart';
import 'widgets/medication_reminder/index.dart';
import 'widgets/water_reminder/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AuthorizationStore _authorizationStore;
  late LoadElderlyStore _loadElderlyStore;
  late LoadWaterReminderStore _loadWaterReminderStore;
  late LoadMedicalReminderStore _loadMedicalReminderStore;
  late LoadMedicationReminderStore _loadMedicationReminderStore;

  late AuthStore _authStore;

  late ReactionDisposer _autorunDisposer;
  late ReactionDisposer _loadStoresDisposer;

  @override
  void initState() {
    super.initState();

    _loadElderlyStore = Provider.of<LoadElderlyStore>(
      context,
      listen: false,
    );

    _authorizationStore = Provider.of<AuthorizationStore>(
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

    _autorunDisposer = autorun((_) {
      _authStore.initAuthUser();
      _authorizationStore.run().then((_) {
        print('carregou elderly');
        return _loadElderlyStore.run();
      });
    });

    _loadStoresDisposer = when(
      (_) =>
          _authorizationStore.authorization?.status ==
          AuthorizationStatus.aprovado,
      () async {
        print(
            '_authorizationStore.authorization?.status == AuthorizationStatus.aprovado');
        await Future.wait(
          [
            _loadWaterReminderStore.run(),
            _loadMedicalReminderStore.run(),
            _loadMedicationReminderStore.run()
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _loadStoresDisposer();
    _autorunDisposer();
    super.dispose();
  }

  Widget _buildAuthInfo() {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          'MEUS DADOS',
          style: textTheme.labelLarge!.copyWith(
            color: context.colors.grey,
            letterSpacing: 3,
          ),
        ),
        const Divider(endIndent: 6, indent: 6, height: 12),
        Text(
          _authStore.userMin?.name ?? '',
          style: textTheme.bodyMedium!.copyWith(color: Colors.black),
        ),
        Text(_authStore.userMin?.email ?? '', style: textTheme.bodySmall),
      ].separator(const SizedBox(height: 9)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(21),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visão geral',
                      style: textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.w200),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      DateTime.now().toDateBRLExtension,
                      style: textTheme.bodySmall,
                    ),
                    // const SizedBox(height: 33),
                  ],
                ),
                IntrinsicHeight(
                  child: Material(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        PopupMenuButton(
                          tooltip: '',
                          offset: const Offset(0, 37),
                          splashRadius: 18,
                          icon: const Icon(Icons.assignment_ind_rounded),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                enabled: false,
                                padding: const EdgeInsets.all(12),
                                child: Center(
                                  child: Observer(
                                    builder: (context) {
                                      final elderlyEmail =
                                          _loadElderlyStore.elderly?.email;
                                      final status = _authorizationStore
                                          .authorization?.status;

                                      return Column(
                                        children: [
                                          ...elderlyEmail != null &&
                                                  status != null
                                              ? _buildElderlyInfoContent(
                                                  context,
                                                  textTheme,
                                                  elderlyEmail,
                                                  status.name,
                                                )
                                              : [
                                                  Text(
                                                    'Vincule-se a uma pessoa idosa',
                                                    style: textTheme.bodyMedium,
                                                  ),
                                                ],
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              )
                            ];
                          },
                        ),
                        const VerticalDivider(
                          width: 33,
                          indent: 12,
                          endIndent: 12,
                        ),
                        PopupMenuButton<int>(
                          tooltip: '',
                          offset: const Offset(0, 57),
                          splashRadius: 18,
                          icon: const Icon(Icons.person),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              enabled: false,
                              padding: const EdgeInsets.all(12),
                              child: Center(child: _buildAuthInfo()),
                            ),
                            PopupMenuItem(
                              padding: EdgeInsets.zero,
                              onTap: () => showDialog(
                                context: context,
                                builder: (_) => const MyDialog(
                                  title: 'Configurações',
                                  confirmPop: false,
                                  child: SettingsPage(),
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.settings),
                                iconColor: context.colors.primary,
                                title: Text(
                                  'CONFIGURAÇÕES',
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () => showDialog(
                                context: context,
                                builder: (context) => ConfirmDialog(
                                  title: 'Sair',
                                  content: 'Deseja realmente sair do sistema?',
                                  positiveBtnText: 'SIM',
                                  onPostivePressed: () async {
                                    await _authStore.signOut();
                                  },
                                  negativeBtnText: 'NÃO',
                                ),
                              ),
                              child: ListTile(
                                leading: const Icon(Icons.logout),
                                iconColor: context.colors.primary,
                                title: Text(
                                  'SAIR',
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: context.colors.scaffoldBackground,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WaterReminderWidget(),
                    const MedicationReminderWidget(),
                    const MedicalReminderWidget(),
                  ].separator(const SizedBox(height: 12)).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildElderlyInfoContent(
    BuildContext context,
    TextTheme textTheme,
    String elderlyEmail,
    String status,
  ) {
    return [
      Text(
        'PESSOA IDOSA',
        style: textTheme.labelLarge!
            .copyWith(color: context.colors.grey, letterSpacing: 3),
      ),
      const Divider(endIndent: 6, indent: 6, height: 12),
      const SizedBox(height: 3),
      Text(elderlyEmail, style: textTheme.bodyMedium),
      Text('status: $status', style: textTheme.bodyMedium),
    ].separator(const SizedBox(height: 6)).toList();
  }
}
