import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../model/authorizations.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../stores/authorization/autorization/authorization_store.dart';
import '../../../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../../common_components/container_reminder.dart';
import '../../../../common_components/labeled_checkbox.dart';
import '../../../../common_components/my_dialog.dart';
import 'medical_reminder_card_edit.dart';
import 'scroll_cards.dart';

class MedicalReminderWidget extends StatefulWidget {
  final bool toBreak;
  const MedicalReminderWidget(this.toBreak, {super.key});

  @override
  State<MedicalReminderWidget> createState() => _MedicalReminderWidgetState();
}

class _MedicalReminderWidgetState extends State<MedicalReminderWidget> {
  late final AuthorizationStore _authorizationStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;

  late bool _showPastReminders = false;

  @override
  void initState() {
    super.initState();

    _authorizationStore = Provider.of<AuthorizationStore>(
      context,
      listen: false,
    );

    _loadMedicalReminderStore = Provider.of<LoadMedicalReminderStore>(
      context,
      listen: false,
    );
  }

  Future<void> _add() => showDialog(
        context: context,
        builder: (_) => const MyDialog(
          title: 'Criação de Lembrete de Consulta',
          child: MedicalReminderCardEdit(null),
        ),
      );

  Skeletonizer _buildLoading() {
    return const Skeletonizer.zone(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Bone.text(words: 3),
                  Bone.text(words: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Bone.iconButton(size: 21),
                          SizedBox(width: 6),
                          Bone.text(width: 120)
                        ],
                      ),
                      Row(
                        children: [
                          Bone.iconButton(size: 21),
                          SizedBox(width: 6),
                          Bone.text(width: 45),
                        ],
                      ),
                    ],
                  ),
                  Bone.text(words: 4),
                  Bone.text(words: 4),
                  Bone.text(words: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final medicalReminders = _loadMedicalReminderStore.medicalReminders;
        final authorizationApproved =
            _authorizationStore.authorization?.status ==
                AuthorizationStatus.aprovado;

        final content = Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (authorizationApproved)
                  LabeledCheckbox(
                    label: 'Lembretes antigos',
                    onChanged: (value) async {
                      setState(() => _showPastReminders = value);
                      await _loadMedicalReminderStore.run(isPast: value);
                    },
                    value: _showPastReminders,
                  ),
                Visibility(
                  visible: _loadMedicalReminderStore.loading,
                  replacement: Visibility(
                    visible: medicalReminders.isNotEmpty,
                    replacement: Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sticky_note_2_outlined,
                              size: context.isMobile ? 45 : 72,
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                            Text(
                              'Sem lembretes',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: ScrollCards(medicalReminders: medicalReminders),
                  ),
                  child: Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildLoading(),
                          _buildLoading(),
                          _buildLoading(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        return ContainerReminder(
          onPressed: authorizationApproved ? _add : null,
          page: widget.toBreak ? content : Expanded(child: content),
          title: 'Lembrete de Consulta',
        );
      },
    );
  }
}
