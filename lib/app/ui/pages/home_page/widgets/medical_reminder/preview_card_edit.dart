import 'package:flutter/material.dart';

import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import 'medical_reminder_card.dart';

class PreviewCardEdit extends StatefulWidget {
  final MedicalReminder _medicalReminder;
  final MedicalReminder _medicalReminderEdit;
  final bool _isEdit;

  const PreviewCardEdit({
    super.key,
    required MedicalReminder medicalReminder,
    required MedicalReminder medicalReminderEdit,
    required bool isEdit,
  })  : _medicalReminder = medicalReminder,
        _medicalReminderEdit = medicalReminderEdit,
        _isEdit = isEdit;

  @override
  State<PreviewCardEdit> createState() => _PreviewCardEditState();
}

class _PreviewCardEditState extends State<PreviewCardEdit> {
  // late final DeleteMedicalReminderStore _deleteMedicalReminderStore;
  // late final LoadMedicalReminderStore _loadMedicalReminderStore;
  // late final ReactionDisposer _disposer;

  // @override
  // void initState() {
  //   super.initState();

  //   _loadMedicalReminderStore = Provider.of<LoadMedicalReminderStore>(
  //     context,
  //     listen: false,
  //   );
  // }

  // @override
  // void dispose() {
  //   _disposer();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final medicalReminderCard = MedicalReminderCard(
      medicalReminder: widget._medicalReminder,
    );

    final children = [
      Opacity(opacity: .69, child: medicalReminderCard),
      MedicalReminderCard(medicalReminder: widget._medicalReminderEdit),
    ];

    final arrow = SizedBox.square(
      dimension: 54,
      child: Icon(
        context.isMobile
            ? Icons.keyboard_double_arrow_down
            : Icons.keyboard_double_arrow_right,
        color: Theme.of(context).colorScheme.secondary,
        size: 33,
      ),
    );

    return widget._isEdit
        ? context.isMobile
            ? Column(children: children.separator(arrow))
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    children.map((e) => Flexible(child: e)).separator(arrow),
              )
        : medicalReminderCard;
  }
}
