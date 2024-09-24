import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
// import 'package:skeletons/skeletons.dart';

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

  // Widget _buildLoading() {
  //   return Column(
  //     children: [
  //       const SkeletonLine(style: SkeletonLineStyle(width: 135)),
  //       const SkeletonLine(),
  //       const SkeletonLine(),
  //       const SkeletonLine(),
  //     ].separator(const SizedBox(height: 6)).toList(),
  //   );
  // }

  // Widget _buildAddMedicalReminderButton(bool authorizationApproved) {
  //   return IconButton(
  //     onPressed: authorizationApproved
  //         ? () {
  //             showDialog(
  //               context: context,
  //               builder: (_) => const MyDialog(
  //                 title: 'Criação de Lembrete de Consulta',
  //                 child: MedicalReminderEditWidget(),
  //               ),
  //             );
  //           }
  //         : null,
  //     icon: const Icon(Icons.add),
  //     splashRadius: 18,
  //     tooltip: !authorizationApproved
  //         ? 'Vincule-se a uma pessoa idosa para criar lembretes'
  //         : null,
  //   );
  // }

  Future<void> _add() => showDialog(
        context: context,
        builder: (_) => const MyDialog(
          title: 'Criação de Lembrete de Consulta',
          child: MedicalReminderCardEdit(null),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final medicalReminders = _loadMedicalReminderStore.medicalReminders;
        final authorizationApproved =
            _authorizationStore.authorization?.status ==
                AuthorizationStatus.aprovado;

        final content = Card(
          child: Visibility(
            visible: _loadMedicalReminderStore.loading,
            replacement: Padding(
              padding: const EdgeInsets.only(
                bottom: 6,
                left: 12,
                right: 12,
                top: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (authorizationApproved) ...[
                    LabeledCheckbox(
                      label: 'Lembretes antigos',
                      onChanged: (value) async {
                        await _loadMedicalReminderStore.run(isPast: value);
                        setState(() => _showPastReminders = value);
                      },
                      value: _showPastReminders,
                    ),
                  ],
                  if (!widget.toBreak) const Spacer(),
                  if (medicalReminders.isNotEmpty)
                    ScrollCards(medicalReminders: medicalReminders)
                  else ...[
                    Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.sticky_note_2_outlined,
                            size: context.isMobile ? 45 : 72,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                          Text(
                            'Sem lembretes',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (!widget.toBreak) const Spacer(flex: 2),
                  ],
                ],
              ),
            ),
            child: const Center(child: CircularProgressIndicator()),
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
