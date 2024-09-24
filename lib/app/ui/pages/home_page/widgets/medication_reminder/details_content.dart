import 'package:flutter/material.dart';

import '../../../../../model/medication_reminder.dart';

class DetailsContent extends StatelessWidget {
  final MedicationReminder medicationReminder;
  final Widget Function(Dosage dosage) buildCardDosage;

  const DetailsContent({
    super.key,
    required this.medicationReminder,
    required this.buildCardDosage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                medicationReminder.name,
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...medicationReminder.dose.entries.map(
                    (entry) => IntrinsicWidth(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 54),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              entry.key.namePtBrShort,
                              // style: textTheme.bodyMedium!.copyWith(
                              //   color: context.colors.grey,
                              // ),
                              textAlign: TextAlign.center,
                            ),
                            ...entry.value?.map(buildCardDosage) ??
                                [
                                  const Text(
                                    '-',
                                    // style: textTheme.bodyMedium!.copyWith(
                                    //   color: context.colors.grey,
                                    // ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (medicationReminder.comments != null &&
                medicationReminder.comments!.isNotEmpty) ...[
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Comentários',
                      // style: textTheme.bodyMedium!
                      //     .copyWith(color: context.colors.grey),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      medicationReminder.comments!,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
