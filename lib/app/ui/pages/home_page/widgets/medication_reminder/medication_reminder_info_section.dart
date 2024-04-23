import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
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
      TextFormField(
        controller: widget.dosageUnitControl,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          helperText: '',
          labelText: 'Unidade',
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        maxLength: 10,
        validator: ValidationBuilder().minLength(1).build(),
      ),
      TextFormField(
        controller: widget.dosagePronunciationControl,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          helperText: '',
          labelText: 'Pronúncia',
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        maxLength: 30,
        validator: ValidationBuilder().minLength(3).build(),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicWidth(
            child: Row(
              children: [
                Text(
                  'Dados iniciais',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: context.colors.primary),
                ),
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 33),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: double.infinity,
                    height: 2,
                    decoration: BoxDecoration(
                      color: context.colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                Text(
                  'Dosagem',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: context.colors.grey),
                ),
              ].separator(const SizedBox(width: 3)).toList(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: widget.medicationNameControl,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              helperText: '',
              labelText: 'Nome do medicamento',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            maxLength: 100,
            validator: ValidationBuilder().minLength(3).build(),
          ),
          context.isMobile
              ? Column(
                  children: unityFields
                      .separator(const SizedBox(height: 12))
                      .toList(),
                )
              : Row(
                  children: unityFields
                      .asMap()
                      .entries
                      .map((e) => Flexible(
                            flex: e.key == 0 ? 1 : 4,
                            child: e.value,
                          ))
                      .separator(const SizedBox(width: 12))
                      .toList(),
                ),
          TextFormField(
            controller: widget.commentsControl,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
              helperText: '',
              labelText: 'Comentários',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            maxLength: 512,
          ),
        ].separator(const SizedBox(height: 12)).toList(),
      ),
    );
  }
}
