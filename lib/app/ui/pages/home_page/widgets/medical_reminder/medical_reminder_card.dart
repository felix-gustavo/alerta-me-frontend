import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/string_extension.dart';

class MedicalReminderCard extends StatefulWidget {
  final MedicalReminder medicalReminder;
  final bool isHover;
  final bool details;

  const MedicalReminderCard({
    super.key,
    required this.medicalReminder,
    this.isHover = false,
    this.details = true,
  });

  @override
  State<MedicalReminderCard> createState() => _MedicalReminderCardState();
}

class _MedicalReminderCardState extends State<MedicalReminderCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final date = widget.medicalReminder.dateTime.toLocal();

    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 315,
        maxWidth: widget.details ? 426 : 315,
      ),
      child: AnimatedScale(
        scale: widget.isHover ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 99),
        child: Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.medicalReminder.medicName,
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.justify,
                      overflow: widget.details ? null : TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.medicalReminder.specialty,
                      textAlign: TextAlign.justify,
                      overflow: widget.details ? null : TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Wrap(
                  spacing: 15,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 3),
                        Text(
                          DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR')
                              .format(date)
                              .capitalize,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: widget.medicalReminder.active
                              ? 'Ativo'
                              : 'Desativado',
                          child: Icon(
                            widget.medicalReminder.active
                                ? Icons.alarm_on_outlined
                                : Icons.alarm_off_outlined,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(DateFormat.Hm('pt_BR').format(date).capitalize),
                      ],
                    ),
                  ],
                ),
                Text(
                  widget.medicalReminder.address,
                  textAlign: TextAlign.justify,
                  overflow: widget.details ? null : TextOverflow.ellipsis,
                ),
              ].separator(const SizedBox(height: 24)),
            ),
          ),
        ),
      ),
    );
  }
}
