import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/water_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/datetime_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../../stores/water_reminder/edit_water_reminder/edit_water_reminder_store.dart';
import '../../../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import '../../../../common_components/active_switch.dart';
import '../../../../common_components/my_dialog.dart';
import '../../../../common_components/my_timeline_tile.dart';
import 'edit_fields.dart';

class WaterReminderEditWidget extends StatefulWidget {
  final WaterReminder? waterReminder;
  final bool toUpdate;

  const WaterReminderEditWidget(this.waterReminder, {super.key})
      : toUpdate = waterReminder != null;

  @override
  State<WaterReminderEditWidget> createState() =>
      _WaterReminderEditWidgetState();
}

class _WaterReminderEditWidgetState extends State<WaterReminderEditWidget> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late WaterReminder _waterReminder;
  late final EditWaterReminderStore _editWaterReminderStore;
  late final ReactionDisposer reactionDisposer;
  late double? _lastConnectorWidthPercent;

  @override
  void initState() {
    super.initState();
    _waterReminder = widget.waterReminder ?? WaterReminder.empty();
    _waterReminder = _waterReminder.copyWith(
      reminders: _generateTimesReminders(
        start: _waterReminder.start,
        end: _waterReminder.end,
        interval: _waterReminder.interval,
      ),
    );

    _editWaterReminderStore = Provider.of<EditWaterReminderStore>(
      context,
      listen: false,
    );

    _lastConnectorWidthPercent = null;

    reactionDisposer = reaction(
      (_) => _editWaterReminderStore.waterReminder,
      (waterReminder) {
        if (waterReminder != null) {
          Provider.of<LoadWaterReminderStore>(
            context,
            listen: false,
          ).setWaterReminder(waterReminder);
        }
      },
    );
  }

  @override
  void dispose() {
    reactionDisposer();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      final navigator = Navigator.of(context);

      showMessage(String message) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: SizedBox(
                width: 300,
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              icon: const Icon(
                Icons.warning_amber_rounded,
                size: 45,
              ),
            ),
          );

      print('_waterReminder.reminders: ${_waterReminder.reminders}');

      await _editWaterReminderStore.run(
        waterReminder: _waterReminder,
        update: widget.toUpdate,
      );

      if (_editWaterReminderStore.errorMessage != null) {
        await showMessage(_editWaterReminderStore.errorMessage!);
      } else {
        navigator.pop();
        EasyLoading.showSuccess('Configuração salva');
      }
    }
  }

  List<TimeOfDay> _generateTimesReminders({
    required TimeOfDay start,
    required TimeOfDay end,
    required int interval,
  }) {
    final List<TimeOfDay> times = [];

    final startTime = TimeOfDay(hour: start.hour, minute: start.minute);
    final endTime = TimeOfDay(hour: end.hour, minute: end.minute);

    final now = DateTime.now();
    final DateTime startDate = now.updateTime(startTime);
    DateTime endDate = now.updateTime(endTime);

    DateTime temp = startDate;

    if (startTime.compareTo(endTime) == 1) {
      endDate = endDate.add(const Duration(days: 1));
    }

    while (temp.isBefore(endDate) || temp.isAtSameMomentAs(endDate)) {
      times.add(temp.toTimeOfDay);
      temp = temp.add(Duration(minutes: interval));
    }

    if (times.last.convertToMinutes != end.convertToMinutes) times.add(end);
    return times;
  }

  double? percentConnectorWidth({
    required int interval,
    required List<TimeOfDay> reminders,
  }) {
    int lastInterval = interval;
    if (reminders.isNotEmpty) {
      final last = reminders.last.convertToMinutes;

      final penultimate =
          reminders[reminders.length >= 2 ? reminders.length - 2 : 0]
              .convertToMinutes;

      lastInterval = last - penultimate;
      if (lastInterval < 0) lastInterval += 1440;
    }
    if (lastInterval < interval) {
      return lastInterval / interval;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    // const maxWidth = 1203.0;
    const maxWidth = 990.0;

    return MyDialog(
      title: 'Configuração de Lembrete de Hidratação',
      child: SizedBox(
        width: maxWidth,
        child: Column(
          crossAxisAlignment: context.isMobile
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 21,
                  vertical: 12,
                ),
                child: EditFields(
                  formKey: _formKey,
                  waterReminder: _waterReminder,
                  onChange: (WaterReminder waterReminder) {
                    final reminders = _generateTimesReminders(
                      start: waterReminder.start,
                      end: waterReminder.end,
                      interval: waterReminder.interval,
                    );
                    setState(() {
                      _lastConnectorWidthPercent = percentConnectorWidth(
                        interval: waterReminder.interval,
                        reminders: reminders,
                      );
                      _waterReminder =
                          waterReminder.copyWith(reminders: reminders);
                    });
                  },
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 18, bottom: 12),
              child: const Text(
                'Resumo dos lembretes (24h)',
                // style:
                //     textTheme.bodyMedium!.copyWith(color: context.colors.grey),
              ),
            ),
            // alignment:
            //     context.isMobile ? Alignment.center : Alignment.centerLeft,
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 21,
                  bottom: 6,
                ),
                child: MyTimelineTile(
                  reminders: _waterReminder.reminders,
                  lastConnectorWidthPercent: _lastConnectorWidthPercent,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActiveSwitch(
                  value: _waterReminder.active,
                  onChangeActive: (value) {
                    setState(() {
                      _waterReminder = _waterReminder.copyWith(active: value);
                    });
                  },
                ),
                Observer(
                  builder: (_) {
                    return Visibility(
                      visible: _editWaterReminderStore.loading,
                      replacement: FilledButton(
                        onPressed:
                            _lastConnectorWidthPercent != null ? null : _submit,
                        child: const Text('Salvar'),
                      ),
                      child: const CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
