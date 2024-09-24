import 'package:flutter/material.dart';

import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import 'medical_reminder_card.dart';
import 'medical_reminder_details.dart';

class ScrollCards extends StatefulWidget {
  final List<MedicalReminder> medicalReminders;
  const ScrollCards({super.key, required this.medicalReminders});

  @override
  State<ScrollCards> createState() => _ScrollCardsState();
}

class _ScrollCardsState extends State<ScrollCards> {
  late final ScrollController _remindersScollController = ScrollController();
  late String? _hoverId = '';

  @override
  void dispose() {
    _remindersScollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _remindersScollController,
      child: SingleChildScrollView(
        controller: _remindersScollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.medicalReminders.map((mr) {
            return InkWell(
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => MedicalReminderDetails(
                    medicalReminder: mr,
                  ),
                );
              },
              onHover: (value) {
                setState(() => _hoverId = value ? mr.id : '');
              },
              child: MedicalReminderCard(
                medicalReminder: mr,
                isHover: _hoverId == mr.id,
                details: false,
              ),
            );
          }).separator(const SizedBox(width: 21)),
        ),
      ),
    );
  }
}
