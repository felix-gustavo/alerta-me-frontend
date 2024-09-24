import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/authorizations.dart';
import '../../../../../stores/authorization/autorization/authorization_store.dart';
import '../../../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import '../../../../common_components/container_reminder.dart';
import 'water_reminder_content.dart';
import 'water_reminder_edit.dart';

class WaterReminderWidget extends StatefulWidget {
  const WaterReminderWidget({Key? key}) : super(key: key);

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

  // Widget _buildLoading() {
  //   return Column(
  //     children: [
  //       const SkeletonLine(style: SkeletonLineStyle(width: 135)),
  //       const SkeletonLine(),
  //       const SkeletonLine(),
  //       const SkeletonLine(),
  //     ].separator(const SizedBox(height: 6)).toList(),
  //   );
  // }

  // Widget _buildConfigWaterReminderButton(bool? active) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       IconButton(
  //         // onPressed: ,
  //         icon: const Icon(Icons.edit_outlined),
  //         splashRadius: 18,
  //         tooltip: !authorizationApproved
  //             ? 'Vincule-se a uma pessoa idosa para configurar este lembrete'
  //             : null,
  //       ),
  //       if (!(active ?? false))
  //         const Tooltip(
  //           message: 'Lembrete desativado',
  //           child: Padding(
  //             padding: EdgeInsets.only(right: 6),
  //             child: Icon(
  //               Icons.warning_amber_rounded,
  //               size: 24,
  //               // color: context.colors.grey,
  //             ),
  //           ),
  //         )
  //     ],
  //   );
  // }

  Future<void> _edit() => showDialog(
        context: context,
        builder: (_) => WaterReminderEditWidget(
          _loadWaterReminderStore.waterReminder,
        ),
      );

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
              ? const Card(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(33),
                      child: CircularProgressIndicator(),
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
