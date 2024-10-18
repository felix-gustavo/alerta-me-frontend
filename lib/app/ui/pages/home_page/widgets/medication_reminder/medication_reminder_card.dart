import 'package:flutter/material.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../common_components/my_dialog.dart';
import 'medication_reminder_details.dart';

class MedicationReminderCard extends StatefulWidget {
  final MedicationReminder medicationReminder;

  const MedicationReminderCard({
    super.key,
    required this.medicationReminder,
  });

  @override
  State<MedicationReminderCard> createState() => _MedicationReminderCardState();
}

class _MedicationReminderCardState extends State<MedicationReminderCard> {
  bool isHovered = false;

  Widget _buildChipTime(Dosage dosage) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(dosage.time.toHHMM, textAlign: TextAlign.center),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final hasDosages = widget.medicationReminder.dose.entries
        .any((dose) => dose.value != null);

    return AnimatedScale(
      scale: isHovered ? 1.03 : 1.0,
      duration: const Duration(milliseconds: 99),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          onHover: (value) => setState(() => isHovered = value),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => MyDialog(
                title: 'Detalhes de Lembrete de Medicamento',
                canPop: true,
                child: MedicationReminderDetails(
                  medicationReminder: widget.medicationReminder,
                ),
              ),
            );
          },
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    widget.medicationReminder.name,
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Divider(),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 12,
                  ),
                  child: Visibility(
                    visible: !hasDosages,
                    replacement: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...widget.medicationReminder.dose.entries.map(
                          (entry) => Container(
                            constraints: const BoxConstraints(minWidth: 36),
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: IntrinsicWidth(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    entry.key.namePtBrShort,
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
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
                                          .separator(
                                            const SizedBox(height: 3),
                                          ) ??
                                      [SizedBox.fromSize()],
                                  if ((entry.value?.length ?? 0) > 2)
                                    const Icon(
                                      Icons.more_vert,
                                      size: 15,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    child: const Text('Não há dosagens configuradas'),
                  ),
                ),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
