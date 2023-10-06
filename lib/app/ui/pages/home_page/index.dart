import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../shared/extensions/app_styles_extension.dart';
import '../../../shared/extensions/colors_app_extension.dart';
import '../../../shared/extensions/datetime_extension.dart';
import '../../../shared/extensions/iterable_extension.dart';
import '../../../stores/auth/auth_store.dart';
import '../../../stores/authorization/load_autorization/load_authorization_store.dart';
import '../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import 'widgets/medical_reminder/index.dart';
import 'widgets/medication_reminder/index.dart';
import 'widgets/sidebar.dart';
import 'widgets/water_reminder/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late LoadAuthorizationStore _loadAuthorizationStore;
  late LoadWaterReminderStore _loadWaterReminderStore;
  late LoadMedicalReminderStore _loadMedicalReminderStore;
  late LoadMedicationReminderStore _loadMedicationReminderStore;

  late AuthStore _authStore;

  late TabController _waterTabController;
  late PageController _waterPageController;

  @override
  void initState() {
    super.initState();
    _loadAuthorizationStore = Provider.of<LoadAuthorizationStore>(
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

    _waterTabController = TabController(length: 2, vsync: this);
    _waterPageController = PageController();

    _waterTabController.addListener(() {
      if (_waterTabController.index != _waterPageController.page?.toInt()) {
        _waterPageController.animateToPage(_waterTabController.index,
            duration: const Duration(milliseconds: 100), curve: Curves.ease);
      }
    });

    _waterPageController.addListener(() {
      if (_waterTabController.index != _waterPageController.page?.toInt()) {
        _waterTabController.animateTo(_waterPageController.page?.toInt() ?? 0,
            duration: const Duration(milliseconds: 100));
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        _loadAuthorizationStore.run(),
        _loadWaterReminderStore.run(),
        _loadMedicalReminderStore.run(),
        _loadMedicationReminderStore.run()
      ]);
    });
  }

  @override
  void dispose() {
    _waterTabController.dispose();
    super.dispose();
  }

  List<Widget> _buildUserInfo(
    String? name,
    String? email,
    TextTheme textTheme,
  ) =>
      [
        Text(name ?? ''),
        const SizedBox(height: 9),
        Text(
          email ?? '',
          style: textTheme.bodySmall,
        )
      ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SidebarWiget(),
          const VerticalDivider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: context.colors.lightGrey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Visão geral', style: textTheme.headlineSmall),
                            const SizedBox(height: 3),
                            Text(
                              DateTime.now().toDateBRLExtension,
                              style: textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Observer(
                          builder: (_) {
                            if (_authStore.error != null) {
                              EasyLoading.showInfo(_authStore.error!);
                            }

                            return context.isMobile
                                ? MenuAnchor(
                                    menuChildren: [
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: _buildUserInfo(
                                            _authStore.user?.name ?? '',
                                            _authStore.user?.email ?? '',
                                            textTheme,
                                          ),
                                        ),
                                      ),
                                    ],
                                    alignmentOffset: const Offset(-171, 0),
                                    builder:
                                        (context, controller, Widget? child) {
                                      return Material(
                                        color: Colors.transparent,
                                        child: IconButton(
                                          onPressed: () {
                                            controller.isOpen
                                                ? controller.close()
                                                : controller.open();
                                          },
                                          icon: Icon(Icons.person,
                                              color: context.colors.primary),
                                          splashRadius: 18,
                                        ),
                                      );
                                    },
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: _buildUserInfo(
                                      _authStore.user?.name ?? '',
                                      _authStore.user?.email ?? '',
                                      textTheme,
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                  const WaterReminderWidget(),
                  const MedicationReminderWidget(),
                  const MedicalReminderWidget(),
                ].separator(const SizedBox(height: 12)).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
