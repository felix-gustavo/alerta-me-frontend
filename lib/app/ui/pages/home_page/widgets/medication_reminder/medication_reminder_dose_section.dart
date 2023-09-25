import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';

class MedicationReminderDoseSection extends StatefulWidget {
  final MedicationReminder medicationReminder;
  final void Function({
    required bool isExpand,
    required Weekday weekday,
  }) onExpand;
  final void Function({required Map<Weekday, List<Dosage>?> newDose})
      onChangeDose;
  final Map<Weekday, List<Dosage>?> dose;
  final Map<Weekday, bool> activated;

  MedicationReminderDoseSection({
    Key? key,
    required this.medicationReminder,
    required this.onExpand,
    required this.onChangeDose,
    required this.activated,
  })  : dose = medicationReminder.dose,
        super(key: key);

  @override
  State<MedicationReminderDoseSection> createState() =>
      _MedicationReminderDoseSectionState();
}

class _MedicationReminderDoseSectionState
    extends State<MedicationReminderDoseSection> {
  late final Map<Weekday, ScrollController> _dosageScrollController;

  @override
  void initState() {
    final iterMap = Weekday.values.map((e) => MapEntry(e, ScrollController()));
    _dosageScrollController = Map.fromEntries(iterMap);

    super.initState();
  }

  @override
  void dispose() {
    _dosageScrollController.forEach((_, value) => value.dispose());
    super.dispose();
  }

  final defaultDosage = Dosage(
    time: const TimeOfDay(hour: 8, minute: 0),
    amount: 10,
  );

  void _addDose(Weekday weekday) {
    widget.onChangeDose(
      newDose: {
        ...widget.medicationReminder.dose,
        ...{
          weekday: [...widget.dose[weekday] ?? [], defaultDosage]
        }
      },
    );
  }

  void _removeDose({required Dosage dosage, required Weekday weekday}) {
    final copy = {...widget.dose};
    copy[weekday]!.remove(dosage);

    widget.onChangeDose(newDose: copy);
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
        Card(
          margin: const EdgeInsets.only(top: 6, right: 6),
          elevation: 0,
          child: SizedBox(
            width: 93,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () async {
                    final newTime = await showTimePicker(
                      context: context,
                      initialTime: dosage.time,
                    );

                    if (newTime != null) {
                      final copy = {...widget.dose};

                      copy[weekday]!.removeAt(index);
                      copy[weekday]!.insert(
                        index,
                        Dosage(time: newTime, amount: dosage.amount),
                      );

                      widget.onChangeDose(newDose: copy);
                    }
                  },
                  child: Text(
                    (widget.medicationReminder.dose[weekday]?.firstWhere(
                              (element) => element == dosage,
                            ) ??
                            defaultDosage)
                        .time
                        .toHHMM,
                  ),
                ),
                const Divider(),
                TextFormField(
                  controller: TextEditingController(
                    text: dosage.amount.toString(),
                  ),
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium!.copyWith(
                    color: context.colors.grey,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value?.isEmpty ?? true) return 'Informe valor';
                    return null;
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final copy = {...widget.dose};

                      copy[weekday]!.removeAt(index);
                      copy[weekday]!.insert(
                        index,
                        Dosage(
                          time: dosage.time,
                          amount: int.parse(value),
                        ),
                      );

                      widget.onChangeDose(newDose: copy);
                    }
                  },
                  decoration: const InputDecoration(
                    counter: null,
                    contentPadding: EdgeInsets.symmetric(vertical: 9),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
        ),
        if ((widget.dose[weekday]?.length ?? 0) > 1)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => _removeDose(
              dosage: dosage,
              weekday: weekday,
            ),
            color: context.colors.error,
            icon: const Icon(Icons.remove_circle_rounded),
            iconSize: 21,
            splashRadius: 9,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ...Weekday.values.map(
          (weekday) {
            final currentExpanded = widget.activated[weekday] ?? false;

            return Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InkWell(
                    onTap: () {
                      if ((widget.dose[weekday]?.length ?? 0) == 0) {
                        _addDose(weekday);
                      }

                      widget.onExpand(
                        isExpand: !currentExpanded,
                        weekday: weekday,
                      );
                    },
                    child: Container(
                      decoration: !currentExpanded
                          ? null
                          : BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: context.colors.lightGrey,
                                ),
                              ),
                            ),
                      padding: const EdgeInsets.all(9),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            weekday.namePtBr,
                            style: textTheme.bodyMedium!.copyWith(
                              color: currentExpanded
                                  ? context.colors.primary
                                  : context.colors.grey.withOpacity(.54),
                            ),
                          ),
                          Icon(
                            currentExpanded
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: currentExpanded
                                ? context.colors.primary
                                : context.colors.lightGrey,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (currentExpanded)
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Text(
                              'Defina horário e dosagem (${widget.medicationReminder.dosageUnit})',
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
                                    ...widget.dose[weekday]!
                                        .asMap()
                                        .entries
                                        .map(
                                          (entry) => _buildDosageFields(
                                            context,
                                            dosage: entry.value,
                                            index: entry.key,
                                            weekday: weekday,
                                          ),
                                        ),
                                    IconButton(
                                      onPressed: () => _addDose(weekday),
                                      icon: const Icon(Icons.add),
                                      iconSize: 21,
                                      splashRadius: 18,
                                      color: context.colors.secondary,
                                    ),
                                  ]
                                      .separator(const SizedBox(width: 6))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ].separator(const SizedBox(height: 6)).toList(),
    );
  }
}
