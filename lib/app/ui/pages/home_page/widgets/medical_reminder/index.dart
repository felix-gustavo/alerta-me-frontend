import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../../model/authorizations.dart';
import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../stores/authorization/autorization/authorization_store.dart';
import '../../../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../../common_components/container_reminder.dart';
import '../../../../common_components/labeled_checkbox.dart';
import '../../../../common_components/my_dialog.dart';
import 'medical_reminder_card.dart';
import 'medical_reminder_details.dart';
import 'medical_reminder_edit.dart';

class MedicalReminderWidget extends StatefulWidget {
  const MedicalReminderWidget({Key? key}) : super(key: key);

  @override
  State<MedicalReminderWidget> createState() => _MedicalReminderWidgetState();
}

class _MedicalReminderWidgetState extends State<MedicalReminderWidget> {
  late final AuthorizationStore _authorizationStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;

  late final ScrollController _remindersScollController = ScrollController();
  late String? _hoverId = '';
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

  @override
  void dispose() {
    _remindersScollController.dispose();
    super.dispose();
  }

  Widget _buildLoading() {
    return Column(
      children: [
        const SkeletonLine(style: SkeletonLineStyle(width: 135)),
        const SkeletonLine(),
        const SkeletonLine(),
        const SkeletonLine(),
      ].separator(const SizedBox(height: 6)).toList(),
    );
  }

  Widget _buildReminders(List<MedicalReminder> medicalReminders) {
    final medicalRemindersCardsList = medicalReminders.map((mr) {
      return InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => MyDialog(
              title: 'Detalhes de Lembrete de Consulta',
              confirmPop: false,
              child: MedicalReminderDetails(medicalReminder: mr),
            ),
          );
        },
        onHover: (value) => setState(() => _hoverId = value ? mr.id : ''),
        child: MedicalReminderCard(
          medicalReminder: mr,
          isHover: _hoverId == mr.id,
        ),
      );
    });

    return Scrollbar(
      controller: _remindersScollController,
      child: SingleChildScrollView(
        controller: _remindersScollController,
        padding: const EdgeInsets.only(bottom: 18),
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: medicalRemindersCardsList
              .separator(const SizedBox(width: 12))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildAddMedicalReminderButton(bool authorizationApproved) {
    return IconButton(
      onPressed: authorizationApproved
          ? () {
              showDialog(
                context: context,
                builder: (_) => MyDialog(
                  title: 'Criação de Lembrete de Consulta',
                  child: SizedBox(
                    width: context.isDesktop ? 801 : 549,
                    child: LayoutBuilder(
                      builder: (_, constraints) => MedicalReminderEditWidget(
                        isMobile: constraints.maxWidth <= 492,
                      ),
                    ),
                  ),
                ),
              );
            }
          : null,
      icon: const Icon(Icons.add),
      splashRadius: 18,
      tooltip: !authorizationApproved
          ? 'Vincule-se a uma pessoa idosa para criar lembretes'
          : null,
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

        print('mudou medicalReminders: $medicalReminders');

        return ContainerReminder(
          action: _buildAddMedicalReminderButton(authorizationApproved),
          page: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._loadMedicalReminderStore.loading
                  ? [_buildLoading()]
                  : [
                      if (authorizationApproved)
                        IntrinsicWidth(
                          child: LabeledCheckbox(
                            label: 'Mostrar todas as consultas',
                            onChanged: (value) async {
                              await _loadMedicalReminderStore.run(
                                withPast: value,
                              );
                              setState(() => _showPastReminders = value);
                            },
                            value: _showPastReminders,
                          ),
                        ),
                      medicalReminders.isNotEmpty
                          ? _buildReminders(medicalReminders)
                          : Text(
                              'Não há lembretes',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                    ].separator(const SizedBox(height: 21)),
            ],
          ),
          pageName: 'Consultas',
          history: const Text('Histórico em breve'),
        );
      },
    );
  }
}
