import 'package:flutter/material.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';

class MedicationReminderCard extends StatefulWidget {
  final MedicationReminder medicationReminder;
  final bool isHover;

  const MedicationReminderCard({
    Key? key,
    required this.medicationReminder,
    this.isHover = false,
  }) : super(key: key);

  @override
  State<MedicationReminderCard> createState() => _MedicalReminderCardState();
}

class _MedicalReminderCardState extends State<MedicationReminderCard> {
  Widget _buildChipTime(Dosage dosage) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1.2),
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        // border: Border.all(color: context.colors.lightGrey),
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
    final textTheme = Theme.of(context).textTheme;

    final child = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Text(
            widget.medicationReminder.name,
            style: textTheme.bodyLarge,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Row(
            children: widget.medicationReminder.dose.entries
                .map(
                  (entry) => SizedBox(
                    width: 57,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          right: entry.key.index ==
                                  widget.medicationReminder.dose.length
                              ? BorderSide.none
                              : BorderSide(
                                  color:
                                      context.colors.lightGrey.withOpacity(.33),
                                ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: context.colors.lightGrey,
                                ),
                              ),
                            ),
                            margin: const EdgeInsets.only(bottom: 3),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(
                                entry.key.namePtBrShort,
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium!.copyWith(
                                  color: context.colors.grey,
                                ),
                              ),
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
                                  .toList() ??
                              [SizedBox.fromSize()],
                          if ((entry.value?.length ?? 0) > 2)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
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
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: widget.isHover
              ? context.colors.primary.withOpacity(.46)
              : context.colors.lightGrey,
        ),
      ),
      child: child,
    );
  }
}
