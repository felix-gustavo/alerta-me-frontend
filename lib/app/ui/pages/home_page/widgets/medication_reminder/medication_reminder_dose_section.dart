import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';

class MedicationReminderDoseSection extends StatefulWidget {
  final String dosageUnit;
  final void Function({
    required bool isExpand,
    required Weekday weekday,
  }) onExpand;
  final void Function({required Weekday weekday, List<Dosage>? dosage})
      onChangeDose;
  final Map<Weekday, List<Dosage>?> dose;
  final Map<Weekday, bool> activated;

  const MedicationReminderDoseSection({
    Key? key,
    required this.dosageUnit,
    required this.dose,
    required this.onExpand,
    required this.onChangeDose,
    required this.activated,
  }) : super(key: key);

  @override
  State<MedicationReminderDoseSection> createState() =>
      _MedicationReminderDoseSectionState();
}

class _MedicationReminderDoseSectionState
    extends State<MedicationReminderDoseSection> {
  late final Map<Weekday, ScrollController> _dosageScrollController;
  late final Map<Weekday, List<TextEditingController>?> _textEC;

  @override
  void initState() {
    _dosageScrollController = Map.fromEntries(
      Weekday.values.map((e) => MapEntry(e, ScrollController())),
    );
    _textEC = Map.fromEntries(
      Weekday.values.map(
        (weekday) {
          final List<TextEditingController> list = [];
          for (int i = 0; i < (widget.dose[weekday]?.length ?? 0); i++) {
            final e = widget.dose[weekday]![i];
            final textEC = TextEditingController(text: e.amount.toString());

            textEC.addListener(() {
              final value = textEC.text;
              if (value.isNotEmpty) {
                final newValue = int.parse(value);
                final dosage = widget.dose[weekday]![i];

                if (dosage.amount != newValue) {
                  final newDosage = Dosage(
                    time: dosage.time,
                    amount: newValue,
                  );

                  final copy = [...?(widget.dose[weekday])];

                  copy.removeAt(i);
                  copy.insert(i, newDosage);

                  widget.onChangeDose(weekday: weekday, dosage: copy);
                }
              }
            });

            list.add(textEC);
          }
          return MapEntry(weekday, list);
        },
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _dosageScrollController.forEach((_, value) => value.dispose());
    _textEC.forEach((_, value) {
      if (value != null) {
        for (var i = 0; i < value.length; i++) {
          value[i].dispose();
        }
      }
    });
    super.dispose();
  }

  final defaultDosage = Dosage(
    time: const TimeOfDay(hour: 8, minute: 0),
    amount: 10,
  );

  void _addDose(Weekday weekday) {
    setState(() {
      final textEC = TextEditingController(
        text: defaultDosage.amount.toString(),
      );

      if (_textEC[weekday] != null) {
        _textEC[weekday]!.add(textEC);
      } else {
        _textEC[weekday] = [textEC];
      }

      textEC.addListener(() {
        final value = textEC.text;
        if (value.isNotEmpty) {
          final index = _textEC[weekday]!.length - 1;
          final newValue = int.parse(value);
          final dosage = widget.dose[weekday]![index];

          if (dosage.amount != newValue) {
            final newDosage = Dosage(
              time: dosage.time,
              amount: newValue,
            );

            final copy = [...?(widget.dose[weekday])];

            copy.removeAt(index);
            copy.insert(index, newDosage);

            widget.onChangeDose(weekday: weekday, dosage: copy);
          }
        }
      });
    });

    widget.onChangeDose(
      weekday: weekday,
      dosage: [...widget.dose[weekday] ?? [], defaultDosage],
    );
  }

  void _removeDose({
    required Weekday weekday,
    required int index,
  }) {
    final copy = [...?(widget.dose[weekday])];
    copy.removeAt(index);

    setState(() {
      _textEC[weekday]!.removeAt(index);
    });

    widget.onChangeDose(weekday: weekday, dosage: copy);
  }

  Widget _buildDosageFields(
    BuildContext context, {
    required Dosage dosage,
    required Weekday weekday,
    required int index,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outlineVariant.withOpacity(.6),
            ),
          ),
          width: 93,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9),
                      topRight: Radius.circular(9),
                    ),
                  ),
                ),
                onPressed: () async {
                  final newTime = await showTimePicker(
                    context: context,
                    initialTime: dosage.time,
                  );

                  if (newTime != null && newTime.compareTo(dosage.time) != 0) {
                    final copy = [...?(widget.dose[weekday])];

                    copy.removeAt(index);
                    copy.insert(
                      index,
                      Dosage(time: newTime, amount: dosage.amount),
                    );

                    widget.onChangeDose(weekday: weekday, dosage: copy);
                  }
                },
                child: Text(dosage.time.toHHMM),
              ),
              const Divider(height: 1),
              TextFormField(
                controller: _textEC[weekday]?[index],
                // onSaved: (value) {
                //   if (value != null && value.isNotEmpty) {
                //     final newValue = int.parse(value);
                //     if (dosage.amount != newValue) {
                //       final newDosage = Dosage(
                //         time: dosage.time,
                //         amount: newValue,
                //       );

                //       final copy = [...?(widget.dose[weekday])];

                //       copy.removeAt(index);
                //       copy.insert(index, newDosage);

                //       widget.onChangeDose(weekday: weekday, dosage: copy);
                //     }
                //   }
                // },
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Informe valor';
                  } else if (int.parse(value!) <= 0) {
                    return 'Min > 0';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  counter: null,
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ],
          ),
        ),
        if ((widget.dose[weekday]?.length ?? 0) > 1)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _removeDose(weekday: weekday, index: index),
            color: Theme.of(context).colorScheme.error,
            icon: const Icon(Icons.remove_circle_rounded),
            iconSize: 21,
            splashRadius: 9,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('MedicationReminderDoseSection');
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ...Weekday.values.map(
          (weekday) {
            final isExpanded = widget.activated[weekday] ?? false;
            final colorScheme = Theme.of(context).colorScheme;

            return ExpansionTile(
              initiallyExpanded: isExpanded,
              onExpansionChanged: (_) {
                if (widget.dose[weekday] == null) _addDose(weekday);
                widget.onExpand(isExpand: !isExpanded, weekday: weekday);
              },
              dense: true,
              trailing: Icon(
                isExpanded
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank,
                size: 18,
              ),
              textColor: colorScheme.primary,
              // collapsedBackgroundColor: colorScheme.surfaceContainerLow,
              backgroundColor: colorScheme.surfaceContainerLowest,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              tilePadding: const EdgeInsets.only(left: 15, right: 9),
              expandedAlignment: Alignment.centerLeft,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(.6),
                ),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(9)),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(.6),
                ),
              ),
              title: Text(weekday.namePtBr),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 6),
                  child: Text(
                    'Defina horário e dosagem (${widget.dosageUnit})',
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 6),
                Scrollbar(
                  controller: _dosageScrollController[weekday],
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                      left: 12,
                      right: 12,
                    ),
                    child: SingleChildScrollView(
                      controller: _dosageScrollController[weekday],
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...widget.dose[weekday]?.asMap().entries.map(
                                    (entry) => _buildDosageFields(
                                      context,
                                      dosage: entry.value,
                                      index: entry.key,
                                      weekday: weekday,
                                    ),
                                  ) ??
                              [const SizedBox.shrink()],
                          IconButton(
                            onPressed: () => _addDose(weekday),
                            icon: const Icon(Icons.add),
                            iconSize: 21,
                            splashRadius: 18,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ].separator(const SizedBox(width: 6)),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ].separator(const SizedBox(height: 6)),
    );
  }
}
