import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../model/authorizations.dart';
import '../../../shared/extensions/app_styles_extension.dart';
import '../../../shared/extensions/iterable_extension.dart';
import '../../../stores/auth/auth_store.dart';
import '../../../stores/authorization/autorization/authorization_store.dart';
import '../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import 'overview_header_card.dart';
import 'widgets/medical_reminder/index.dart';
import 'widgets/medication_reminder/index.dart';
import 'widgets/water_reminder/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final AuthorizationStore _authorizationStore;
  late final LoadWaterReminderStore _loadWaterReminderStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;
  late final LoadMedicationReminderStore _loadMedicationReminderStore;

  late final AuthStore _authStore;

  late final ReactionDisposer _autorunDisposer;
  late final ReactionDisposer _loadStoresDisposer;

  @override
  void initState() {
    super.initState();

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

    _autorunDisposer = autorun((_) async {
      _authStore.initAuthUser();
      await _authorizationStore.run();
    });

    _loadStoresDisposer = when(
      (_) =>
          _authorizationStore.authorization?.status ==
          AuthorizationStatus.aprovado,
      () async {
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

  List<Widget> _getChildren(bool toBreak) => [
        MedicationReminderWidget(toBreak),
        MedicalReminderWidget(toBreak),
      ];

  @override
  Widget build(BuildContext context) {
    double horizontalMargin = context.screenWidth * 0.036;
    if (context.isMobile) {
      horizontalMargin = context.screenWidth * 0.021;
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalMargin,
          vertical: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const OverviewHeaderCard(),
            const WaterReminderWidget(),
            if (context.isDesktop) ...[
              SizedBox(
                height: 321,
                child: Row(
                  children: _getChildren(false)
                      .map((e) => Flexible(child: e))
                      .separator(const SizedBox(width: 18)),
                ),
              )
            ] else
              ..._getChildren(true),
          ].separator(const SizedBox(height: 12)),
        ),
      ),
    );
  }
}
