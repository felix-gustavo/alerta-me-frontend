import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../model/authorizations.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../stores/authorization/autorization/authorization_store.dart';
import '../../../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import '../../../../common_components/container_reminder.dart';
import 'water_reminder_content.dart';
import 'water_reminder_edit.dart';

class WaterReminderWidget extends StatefulWidget {
  const WaterReminderWidget({super.key});

  @override
  State<WaterReminderWidget> createState() => _WaterReminderWidgetState();
}

class _WaterReminderWidgetState extends State<WaterReminderWidget>
    with SingleTickerProviderStateMixin {
  late final AuthorizationStore _authorizationStore;
  late final LoadWaterReminderStore _loadWaterReminderStore;

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
  }

  Future<void> _edit() => showDialog(
        context: context,
        builder: (_) => WaterReminderEditWidget(
          _loadWaterReminderStore.waterReminder,
        ),
      );

  Skeletonizer _buildLoading() {
    final toBreak = context.screenWidth < 940;

    final children = [
      SizedBox(
        width: 435,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Bone(
                    height: 300,
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  children: [
                    const Bone(
                      height: 69,
                      width: 99,
                      borderRadius: BorderRadius.all(
                        Radius.circular(9),
                      ),
                    ),
                    const Bone(
                      height: 69,
                      width: 99,
                      borderRadius: BorderRadius.all(
                        Radius.circular(9),
                      ),
                    ),
                    const Bone(
                      height: 69,
                      width: 99,
                      borderRadius: BorderRadius.all(
                        Radius.circular(9),
                      ),
                    ),
                  ].separator(const SizedBox(height: 12)),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox.square(dimension: 12),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Bone.icon(),
                  const Bone.icon(),
                  const Bone.icon(),
                  const Bone.icon(),
                  const Bone.icon(),
                  const Bone.icon(),
                ].separator(const Bone(height: 6, width: 90)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox.shrink(),
                      Bone.text(words: 2),
                      Bone.icon(),
                    ],
                  ),
                  SizedBox(height: 12),
                  Bone(
                    height: 210,
                    borderRadius: BorderRadius.all(
                      Radius.circular(9),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ];
    return Skeletonizer.zone(
      child: toBreak
          ? Column(children: children)
          : Row(
              children: [
                ...children.getRange(0, children.length - 1),
                Flexible(child: children.last),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final waterReminder = _loadWaterReminderStore.waterReminder;
        final authorizationApproved =
            _authorizationStore.authorization?.status ==
                AuthorizationStatus.aprovado;

        return ContainerReminder(
          // active: waterReminder?.active ?? false,
          onPressed: authorizationApproved ? _edit : null,
          page: _loadWaterReminderStore.loading
              ? Card(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(33),
                      child: _buildLoading(),
                    ),
                  ),
                )
              : waterReminder != null
                  ? WaterReminderContent(waterReminder: waterReminder)
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          'Lembrete não configurado',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
          title: 'Lembrete de Hidratação',
        );
      },
    );
  }
}
