import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../exceptions/exceptions_impl.dart';
import '../../../../../model/water_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../../stores/water_reminder/edit_water_reminder/edit_water_reminder_store.dart';
import '../../../../../stores/water_reminder/load_water_reminder/load_water_reminder_store.dart';
import '../../../../common_components/my_time_range_picker.dart';
import '../../../../common_components/my_timeline.dart';
import '../../../../common_components/redirect_to_login.dart';

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

  late TimeOfDay _start;
  late TimeOfDay _end;
  late TimeOfDay _range;

  late int _interval;
  late double _acc;
  late int _amount;

  final ScrollController _timelineScollController = ScrollController();

  late final EditWaterReminderStore _editWaterReminderStore;
  late final LoadWaterReminderStore _loadWaterReminderStore;

  late final ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();

    _start = widget.waterReminder?.start ?? const TimeOfDay(hour: 8, minute: 0);
    _end = widget.waterReminder?.end ?? const TimeOfDay(hour: 12, minute: 0);
    _range = _start.interval(_end);
    _interval = widget.waterReminder?.interval ?? 35;
    _acc = _getCalculateAcc;
    _amount = widget.waterReminder?.amount ?? 3000;

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

  double get _getCalculateAcc => (_range.convertToMinutes / _interval) + 1;

  void _onChangeInterval(int newInterval) {
    setState(() {
      _interval = newInterval;
      _acc = _getCalculateAcc;
    });
  }

  void _onStartChange(TimeOfDay start) {
    setState(() {
      _start = start;
      _range = start.interval(_end);
      _acc = _getCalculateAcc;
    });
  }

  void _onEndChange(TimeOfDay end) {
    setState(() {
      _end = end;
      _range = _start.interval(end);
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
            start: _start,
            end: _end,
            interval: _interval,
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
                start: _start,
                end: _end,
                onStartChange: _onStartChange,
                onEndChange: _onEndChange,
              ),
              SizedBox(
                width: 281,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldContainer(
                      label: 'Intervalo entre lembretes',
                      sublabel:
                          'Escolha, em minutos, o intervalo entre cada lembrete (5 - 120)',
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
                                onPressed: _interval > 5
                                    ? () => _onChangeInterval(_interval -= 5)
                                    : null,
                              ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: _interval.toString(),
                                    style: textTheme.displaySmall,
                                  ),
                                  TextSpan(
                                    text: ' min',
                                    style: textTheme.bodyLarge!.copyWith(
                                      color: context.colors.grey,
                                    ),
                                  ),
                                ]),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle),
                                color: context.colors.primary,
                                splashRadius: 21,
                                iconSize: 24,
                                onPressed: _interval < 120
                                    ? () => _onChangeInterval(_interval += 5)
                                    : null,
                              ),
                            ],
                          ),
                          Slider(
                            min: 5,
                            max: 120,
                            value: _interval.toDouble(),
                            onChanged: (value) =>
                                _onChangeInterval(value.toInt()),
                            divisions: 23,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 21),
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
                          initialValue: _amount.toString(),
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
                          onSaved: (newValue) {
                            if (newValue != null && newValue.isNotEmpty) {
                              setState(() {
                                _amount = int.parse(newValue);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 281,
                child: _buildFieldContainer(
                  label: 'Quantidade de lembretes',
                  sublabel:
                      'Para o cálculo é levado em consideração o início e fim dos lembretes, bem como o intervalo entre cada lembrete',
                  content: Text(
                    _acc.ceil().toString(),
                    style: textTheme.displaySmall,
                  ),
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
      await _editWaterReminderStore
          .run(
        amount: _amount,
        interval: _interval,
        start: _start,
        end: _end,
        update: widget.toUpdate,
      )
          .then(
        (_) {
          final navigator = Navigator.of(context);

          final errorMessage = _editWaterReminderStore.errorMessage;

          errorMessage != null
              ? EasyLoading.showError(errorMessage)
              : EasyLoading.showSuccess('Configuração salva');

          navigator.pop();
        },
        onError: (error) async {
          if (error is SessionExpiredException) {
            await RedirectToLogin.show(context, error.message);
          }
        },
      );
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
          Center(
            child: Observer(
              builder: (_) {
                return Visibility(
                  visible: _editWaterReminderStore.loading,
                  replacement: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Salvar'),
                  ),
                  child: const CircularProgressIndicator(),
                );
              },
            ),
          )
        ].separator(const SizedBox(height: 21)).toList(),
      ),
    );
  }
}
