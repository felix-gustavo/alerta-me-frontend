import 'package:flutter/material.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../common_components/my_dialog.dart';
import 'medication_reminder_details.dart';

class MedicationReminderCard extends StatefulWidget {
  final MedicationReminder medicationReminder;

  const MedicationReminderCard({
    Key? key,
    required this.medicationReminder,
  }) : super(key: key);

  @override
  State<MedicationReminderCard> createState() => _MedicalReminderCardState();
}

class _MedicalReminderCardState extends State<MedicationReminderCard> {
  bool isHovered = false;

  Widget _buildChipTime(Dosage dosage) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: context.colors.primaryLight,
      ),
      child: Text(
        dosage.time.toHHMM,
        textAlign: TextAlign.center,
        style: textTheme.bodyMedium!.copyWith(
          color: context.colors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('MedicationReminderCard');
    final textTheme = Theme.of(context).textTheme;

    final hasDosages = widget.medicationReminder.dose.entries
        .any((dose) => dose.value != null);

    final child = IntrinsicWidth(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Text(
              widget.medicationReminder.name,
              style: textTheme.bodyLarge,
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Divider(),
          !hasDosages
              ? Padding(
                  padding: const EdgeInsets.all(9),
                  child: Text(
                    'Não há dosagens configuradas',
                    style: textTheme.bodyMedium!.copyWith(
                      color: context.colors.grey,
                    ),
                  ),
                )
              : Flexible(
                  child: Row(
                    children: widget.medicationReminder.dose.entries
                        .map(
                          (entry) => SizedBox(
                            width: 57,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border(
                                  right: entry.key.index ==
                                          widget.medicationReminder.dose.length
                                      ? BorderSide.none
                                      : BorderSide(
                                          color: context.colors.lightGrey
                                              .withOpacity(.33),
                                        ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    entry.key.namePtBrShort,
                                    textAlign: TextAlign.center,
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: context.colors.grey,
                                    ),
                                  ),
                                  ...entry.value
                                          ?.asMap()
                                          .map((index, value) {
                                            return MapEntry(
                                              index,
                                              index < 2
                                                  ? _buildChipTime(value)
                                                  : const SizedBox.shrink(),
                                            );
                                          })
                                          .values
                                          .separator(const SizedBox(height: 6))
                                          .toList() ??
                                      [SizedBox.fromSize()],
                                  if ((entry.value?.length ?? 0) > 2)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: context.colors.grey,
                                        size: 15,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
        ].separator(const VerticalDivider()).toList(),
      ),
    );

    return Card(
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
        side: BorderSide(
          color: isHovered
              ? context.colors.primary.withOpacity(.46)
              : context.colors.lightGrey,
        ),
      ),
      child: InkWell(
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        onHover: (value) => setState(() => isHovered = value),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => MyDialog(
              title: 'Detalhes de Lembrete de Medicamento',
              confirmPop: false,
              child: MedicationReminderDetails(
                medicationReminder: widget.medicationReminder,
              ),
            ),
          );
        },
        child: child,
      ),
    );
  }
}
