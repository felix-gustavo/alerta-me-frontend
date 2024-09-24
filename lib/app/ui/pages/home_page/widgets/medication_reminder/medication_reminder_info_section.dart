import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';

class MedicationReminderInfoSection extends StatefulWidget {
  final TextEditingController dosageUnitControl;
  final TextEditingController dosagePronunciationControl;
  final TextEditingController medicationNameControl;
  final TextEditingController commentsControl;

  const MedicationReminderInfoSection({
    Key? key,
    required this.dosageUnitControl,
    required this.dosagePronunciationControl,
    required this.medicationNameControl,
    required this.commentsControl,
  }) : super(key: key);

  @override
  State<MedicationReminderInfoSection> createState() =>
      _MedicationReminderInfoSectionState();
}

class _MedicationReminderInfoSectionState
    extends State<MedicationReminderInfoSection> {
  @override
  Widget build(BuildContext context) {
    print('MedicationReminderInfoSection');
    final unityFields = [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Unidade'),
          const SizedBox(height: 3),
          TextFormField(
            controller: widget.dosageUnitControl,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            maxLength: 10,
            validator: ValidationBuilder().minLength(1).required().build(),
          ),
        ],
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pronúncia'),
          const SizedBox(height: 3),
          TextFormField(
            controller: widget.dosagePronunciationControl,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            maxLength: 30,
            validator: ValidationBuilder().minLength(3).required().build(),
          ),
        ],
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Nome'),
                const SizedBox(height: 3),
                TextFormField(
                  controller: widget.medicationNameControl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  validator:
                      ValidationBuilder().minLength(3).required().build(),
                ),
              ],
            ),
            context.isMobile
                ? Column(
                    children: unityFields.separator(const SizedBox(height: 12)),
                  )
                : Row(
                    children: unityFields
                        .asMap()
                        .entries
                        .map((e) => Flexible(
                              flex: e.key == 0 ? 3 : 5,
                              child: e.value,
                            ))
                        .separator(const SizedBox(width: 12)),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Comentários'),
                const SizedBox(height: 3),
                TextFormField(
                  controller: widget.commentsControl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 512,
                ),
              ],
            ),
          ].separator(const SizedBox(height: 12)),
        ),
      ),
    );
  }
}
