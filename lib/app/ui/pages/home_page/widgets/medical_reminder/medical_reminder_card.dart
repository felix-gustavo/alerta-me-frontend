import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/string_extension.dart';

class MedicalReminderCard extends StatefulWidget {
  final MedicalReminder medicalReminder;
  final bool isHover;
  final bool expanded;

  const MedicalReminderCard({
    Key? key,
    required this.medicalReminder,
    this.isHover = false,
    this.expanded = false,
  }) : super(key: key);

  @override
  State<MedicalReminderCard> createState() => _MedicalReminderCardState();
}

class _MedicalReminderCardState extends State<MedicalReminderCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final date = widget.medicalReminder.dateTime.toLocal();

    final child = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.medicalReminder.medicName,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.justify,
                overflow: widget.expanded ? null : TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                widget.medicalReminder.specialty,
                style: textTheme.bodyMedium!.copyWith(
                  color: context.colors.grey,
                ),
                textAlign: TextAlign.justify,
                overflow: widget.expanded ? null : TextOverflow.ellipsis,
              ),
            ],
          ),
          Wrap(
            spacing: 15,
            alignment: WrapAlignment.spaceBetween,
            children: [
              IntrinsicWidth(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR')
                          .format(date)
                          .capitalize,
                      style: textTheme.bodyMedium!.copyWith(
                        color: context.colors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              IntrinsicWidth(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: context.colors.primary,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      DateFormat.Hm('pt_BR').format(date).capitalize,
                      style: textTheme.bodyMedium!.copyWith(
                        color: context.colors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            widget.medicalReminder.address,
            style: textTheme.bodyMedium!.copyWith(
              color: context.colors.grey,
            ),
            textAlign: TextAlign.justify,
            overflow: widget.expanded ? null : TextOverflow.ellipsis,
          ),
        ].separator(const SizedBox(height: 15)).toList(),
      ),
    );

    return Container(
      constraints: BoxConstraints(
        minWidth: 327,
        maxWidth: widget.expanded ? 418 : 327,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: widget.isHover
              ? context.colors.primary.withOpacity(.46)
              : context.colors.lightGrey,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}
