import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/water_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../../stores/water_reminder/edit_water_reminder/edit_water_reminder_store.dart';
import '../../../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import '../../../../common_components/my_time_range_picker.dart';
import '../../../../common_components/my_timeline.dart';

const kMinRange = 5;
const kMaxRange = 120;

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
  late final GlobalKey<FormState> _formKey;

  late WaterReminder _waterReminder;

  late TimeOfDay _range;
  late double _acc;

  final ScrollController _timelineScollController = ScrollController();

  late final EditWaterReminderStore _editWaterReminderStore;
  late final LoadWaterReminderStore _loadWaterReminderStore;

  late final ReactionDisposer disposer;

  late List<TimeOfDay> scheduleReminders;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    _waterReminder = widget.waterReminder ?? WaterReminder.empty();

    _range = _waterReminder.start.interval(_waterReminder.end);
    _acc = _getCalculateAcc;

    _editWaterReminderStore =
        Provider.of<EditWaterReminderStore>(context, listen: false);
    _loadWaterReminderStore =
        Provider.of<LoadWaterReminderStore>(context, listen: false);

    disposer = reaction(
      (_) => _editWaterReminderStore.waterReminder,
      (waterReminder) {
        if (waterReminder != null) {
          _loadWaterReminderStore.setWaterReminder(waterReminder);
        }
      },
    );
  }

  @override
  void dispose() {
    _timelineScollController.dispose();
    disposer();
    super.dispose();
  }

  double get _getCalculateAcc =>
      (_range.convertToMinutes / _waterReminder.interval) + 1;

  void _onChangeInterval(int newInterval) {
    setState(() {
      _waterReminder = _waterReminder.copyWith(interval: newInterval);
      _acc = _getCalculateAcc;
    });
  }

  void _onStartChange(TimeOfDay start) {
    setState(() {
      _waterReminder = _waterReminder.copyWith(start: start);
      _range = start.interval(_waterReminder.end);
      _acc = _getCalculateAcc;
    });
  }

  void _onEndChange(TimeOfDay end) {
    setState(() {
      _waterReminder = _waterReminder.copyWith(end: end);
      _range = _waterReminder.start.interval(end);
      _acc = _getCalculateAcc;
    });
  }

  Container _buildTimelineReview() {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.colors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumo dos lembretes (24h)',
            style: textTheme.titleSmall!.copyWith(color: context.colors.grey),
          ),
          const SizedBox(height: 33),
          MyTimeline(
            start: _waterReminder.start,
            end: _waterReminder.end,
            interval: _waterReminder.interval,
            onGeneratedReminders: (reminders) => scheduleReminders = reminders,
          ),
        ],
      ),
    );
  }

  Widget _buildFieldContainer({
    required String label,
    required String sublabel,
    required Widget content,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label),
          Text(
            sublabel,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: context.colors.grey,
                ),
            textAlign: TextAlign.justify,
          ),
          content,
        ].separator(const SizedBox(height: 9)).toList(),
      );

  Widget _buildFormEdit(double maxWidth) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.colors.lightGrey),
      ),
      width: maxWidth,
      child: ExpandablePageView(
        children: [
          Wrap(
            spacing: 33,
            runSpacing: 21,
            alignment: !context.isTablet || context.screenWidth < 735
                ? WrapAlignment.spaceEvenly
                : WrapAlignment.start,
            children: [
              MyTimeRangePicker(
                start: _waterReminder.start,
                end: _waterReminder.end,
                onStartChange: _onStartChange,
                onEndChange: _onEndChange,
              ),
              SizedBox(
                width: 281,
                child: Column(
                  children: [
                    _buildFieldContainer(
                      label: 'Intervalo entre lembretes',
                      sublabel:
                          'Escolha, em minutos, o intervalo entre cada lembrete ($kMinRange - $kMaxRange)',
                      content: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                color: context.colors.primary,
                                splashRadius: 21,
                                iconSize: 24,
                                onPressed: _waterReminder.interval > kMinRange
                                    ? () => _onChangeInterval(
                                          _waterReminder.interval - kMinRange,
                                        )
                                    : null,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: _waterReminder.interval.toString(),
                                      style: textTheme.displaySmall,
                                    ),
                                    TextSpan(
                                      text: 'min',
                                      style: textTheme.labelLarge!.copyWith(
                                        color: context.colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                color: context.colors.primary,
                                splashRadius: 21,
                                iconSize: 24,
                                onPressed: _waterReminder.interval < kMaxRange
                                    ? () => _onChangeInterval(
                                        _waterReminder.interval + kMinRange)
                                    : null,
                              ),
                            ],
                          ),
                          Slider(
                            min: kMinRange.toDouble(),
                            max: kMaxRange.toDouble(),
                            value: _waterReminder.interval.toDouble(),
                            onChanged: (value) =>
                                _onChangeInterval(value.toInt()),
                            divisions: (kMaxRange - kMinRange) ~/ kMinRange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 21),
                    _buildFieldContainer(
                      label: 'Quantidade de lembretes',
                      sublabel:
                          'Para o cálculo é levado em consideração o início e fim dos lembretes, bem como o intervalo entre cada lembrete',
                      content: Text(
                        _acc.ceil().toString(),
                        style: textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 281,
                child: Column(
                  children: [
                    _buildFieldContainer(
                      label: 'Quantidade de água',
                      sublabel:
                          'Defina a quantidade de água a ser ingerida (mL)',
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            helperText: '',
                          ),
                          initialValue: _waterReminder.amount.toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Campo obrigatório';
                            }
                            if (value == '0') {
                              return 'Precisa ser maior que 0';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _waterReminder = _waterReminder.copyWith(
                                  amount: int.parse(value),
                                );
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 21),
                    _buildFieldContainer(
                      label: 'Dose sugerida',
                      sublabel: 'Representa a dose sugerida por lembrete',
                      content: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: (_waterReminder.amount / _acc.ceil())
                                  .floor()
                                  .toString(),
                              style: textTheme.displaySmall,
                            ),
                            TextSpan(
                              text: 'mL',
                              style: textTheme.labelLarge!.copyWith(
                                color: context.colors.grey,
                              ),
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState!.save();
      final navigator = Navigator.of(context);

      print('scheduleReminders: $scheduleReminders');

      await _editWaterReminderStore.run(
        waterReminder: _waterReminder.copyWith(reminders: scheduleReminders),
        update: widget.toUpdate,
      );

      final errorMessage = _editWaterReminderStore.errorMessage;
      errorMessage != null
          ? EasyLoading.showError(errorMessage)
          : EasyLoading.showSuccess('Configuração salva');

      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const maxWidth = 1203.0;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFormEdit(maxWidth),
          _buildTimelineReview(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Switch(
                    value: _waterReminder.active,
                    onChanged: (bool value) {
                      setState(() {
                        _waterReminder = _waterReminder.copyWith(active: value);
                      });
                    },
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Ativo',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: context.colors.grey),
                  ),
                ],
              ),
              Observer(
                builder: (_) {
                  int lastInterval = _waterReminder.interval;
                  final reminders = scheduleReminders;
                  if (reminders.isNotEmpty) {
                    final last = reminders.last.convertToMinutes;

                    final penultimate = reminders[
                            reminders.length >= 2 ? reminders.length - 2 : 0]
                        .convertToMinutes;

                    lastInterval = last - penultimate;
                    if (lastInterval < 0) lastInterval += 1440;
                  }

                  return Visibility(
                    visible: _editWaterReminderStore.loading,
                    replacement: ElevatedButton(
                      onPressed: lastInterval < _waterReminder.interval
                          ? null
                          : _submit,
                      child: const Text('Salvar'),
                    ),
                    child: const CircularProgressIndicator(),
                  );
                },
              ),
            ],
          )
        ].separator(const SizedBox(height: 21)).toList(),
      ),
    );
  }
}
