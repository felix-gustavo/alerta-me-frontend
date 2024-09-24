import 'package:flutter/material.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/iterable_extension.dart';

class DetailsContentMobile extends StatelessWidget {
  final MedicationReminder medicationReminder;
  final Widget Function(Dosage dosage) buildCardDosage;

  const DetailsContentMobile({
    super.key,
    required this.medicationReminder,
    required this.buildCardDosage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 600,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(medicationReminder.name, style: textTheme.bodyLarge),
          const SizedBox.shrink(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: medicationReminder.dose.entries.map((entry) {
              final hasDosages = entry.value != null;

              return Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: hasDosages
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              entry.key.namePtBr,
                              // style: textTheme.bodyMedium!.copyWith(
                              //   color: context.colors.grey,
                              // ),
                            ),
                            const SizedBox(height: 9),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                children: entry.value!
                                    .map(buildCardDosage)
                                    .separator(const SizedBox(width: 6)),
                              ),
                            )
                          ],
                        )
                      : Row(
                          children: [
                            Text(
                              entry.key.namePtBr,
                              // style: textTheme.bodyMedium!.copyWith(
                              //   color: context.colors.grey,
                              // ),
                            ),
                            const Spacer(),
                            const Text(
                              'Sem registro',
                              // style: textTheme.bodySmall!.copyWith(
                              //   color: context.colors.lightGrey,
                              // ),
                            ),
                          ],
                        ),
                ),
              );
            }).separator(const SizedBox(height: 6)),
          ),
          if (medicationReminder.comments != null &&
              medicationReminder.comments!.isNotEmpty) ...[
            const SizedBox.shrink(),
            const Text(
              'Comentários',
              // style: textTheme.bodyMedium!.copyWith(color: context.colors.grey),
            ),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicationReminder.comments!,
                      // style: textTheme.bodyMedium!.copyWith(
                      //   color: context.colors.grey,
                      // ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ]
        ].separator(const SizedBox(height: 6)),
      ),
    );
  }
}
