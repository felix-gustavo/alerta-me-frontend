import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../../model/authorizations.dart';
import '../../../../../model/water_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../../stores/authorization/autorization/authorization_store.dart';
import '../../../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import '../../../../common_components/container_reminder.dart';
import '../../../../common_components/my_dialog.dart';
import '../../../../common_components/my_time_range_picker.dart';
import '../../../../common_components/my_timeline.dart';
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

  Widget _buildLoading() {
    return Column(
      children: [
        const SkeletonLine(style: SkeletonLineStyle(width: 135)),
        const SkeletonLine(),
        const SkeletonLine(),
        const SkeletonLine(),
      ].separator(const SizedBox(height: 6)).toList(),
    );
  }

  Widget _buildNoWaterReminder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lembrete não configurado',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 9),
        Text(
          'É necessário configurar os lembretes',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: context.colors.grey),
        ),
      ],
    );
  }

  Widget _buildWaterReminder(WaterReminder waterReminder) {
    final textTheme = Theme.of(context).textTheme;

    final startTime = waterReminder.start;
    final endTime = waterReminder.end;
    final range = startTime.interval(endTime);

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.lightGrey),
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              child: Wrap(
                alignment: WrapAlignment.spaceAround,
                runSpacing: 24,
                spacing: 9,
                children: [
                  MyTimeRangePicker.small(
                    key: ValueKey(range),
                    start: startTime,
                    end: endTime,
                    readonly: true,
                  ),
                  SizedBox(
                    width: 258,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quantidade de água',
                              style: textTheme.bodyMedium!
                                  .copyWith(color: context.colors.grey),
                            ),
                            Text(
                              '${(waterReminder.amount / 1000).toStringAsFixed(2)} L',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total de lembretes',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: context.colors.grey),
                            ),
                            Text(
                              ((range.convertToMinutes /
                                          waterReminder.interval) +
                                      1)
                                  .ceil()
                                  .toString(),
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Divider(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Início',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: context.colors.grey),
                            ),
                            Text(startTime.toHHMM, style: textTheme.bodyMedium),
                          ],
                        ),
                        const Divider(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Fim',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: context.colors.grey),
                            ),
                            Text(endTime.toHHMM, style: textTheme.bodyMedium),
                          ],
                        ),
                        const Divider(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Intervalo',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: context.colors.grey),
                            ),
                            Text(
                              '${waterReminder.interval.toString()} min',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: context.screenWidth > 1400
                        ? context.screenWidth * .48
                        : context.screenWidth > 1200
                            ? context.screenWidth * .39
                            : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Linha do tempo (24h)',
                          style: textTheme.bodyMedium!
                              .copyWith(color: context.colors.grey),
                        ),
                        const SizedBox(height: 33),
                        MyTimeline(
                          start: startTime,
                          end: endTime,
                          interval: waterReminder.interval,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!waterReminder.active)
          Tooltip(
            message: 'Lembrete desativado',
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(
                Icons.warning_amber_rounded,
                color: context.colors.grey,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildConfigWaterReminderButton() {
    final authorizationApproved = _authorizationStore.authorization?.status ==
        AuthorizationStatus.aprovado;

    return IconButton(
      onPressed: authorizationApproved
          ? () {
              showDialog(
                context: context,
                builder: (_) => MyDialog(
                  title: 'Configuração de Lembrete de Água',
                  child: WaterReminderEditWidget(
                    _loadWaterReminderStore.waterReminder,
                  ),
                ),
              );
            }
          : null,
      icon: const Icon(Icons.edit_outlined),
      splashRadius: 18,
      tooltip: !authorizationApproved
          ? 'Vincule-se a uma pessoa idosa para configurar este lembrete'
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final waterReminder = _loadWaterReminderStore.waterReminder;

        return ContainerReminder(
          action: _buildConfigWaterReminderButton(),
          page: _loadWaterReminderStore.loading
              ? _buildLoading()
              : waterReminder != null
                  ? _buildWaterReminder(waterReminder)
                  : _buildNoWaterReminder(),
          pageName: 'Água',
          history: const Text('Histórico em breve'),
        );
      },
    );
  }
}
