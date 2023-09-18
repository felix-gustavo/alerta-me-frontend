import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../../model/authorizations.dart';
import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../stores/authorization/load_autorization/load_authorization_store.dart';
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
  late final LoadAuthorizationStore _loadAuthorizationStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;

  late final ScrollController _remindersScollController = ScrollController();
  late String? _hoverId = '';
  late bool _showPastReminders = false;

  @override
  void initState() {
    super.initState();

    _loadAuthorizationStore = Provider.of<LoadAuthorizationStore>(
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
    return SizedBox(
      width: 327,
      child: Column(
        children: [
          const SkeletonLine(style: SkeletonLineStyle()),
          const SizedBox(height: 3),
          const SkeletonLine(style: SkeletonLineStyle()),
          const SizedBox(height: 12),
          Row(
            children: [
              const SkeletonLine(
                style: SkeletonLineStyle(width: 21, height: 21),
              ),
              const SkeletonLine(
                style: SkeletonLineStyle(width: 120, height: 21),
              ),
              const Spacer(),
              const SkeletonLine(
                style: SkeletonLineStyle(width: 21, height: 21),
              ),
              const SkeletonLine(
                  style: SkeletonLineStyle(width: 46, height: 21)),
            ].separator(const SizedBox(width: 15)).toList(),
          ),
          const SizedBox(height: 12),
          const SkeletonLine(style: SkeletonLineStyle()),
        ],
      ),
    );
  }

  Widget _buildNoReminder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Não há lembretes',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 9),
        Text(
          'Experimente criar lembretes de consultas',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: context.colors.grey),
        ),
      ],
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

  Widget _buildAddMedicalReminderButton() {
    final authorizationApproved =
        _loadAuthorizationStore.authorization?.status ==
            AuthorizationStatus.aprovado;

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

        return ContainerReminder(
          action: _buildAddMedicalReminderButton(),
          page: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (medicalReminders.isNotEmpty)
                IntrinsicWidth(
                  child: LabeledCheckbox(
                    label: 'Mostrar todas as consultas',
                    onChanged: (value) async {
                      await _loadMedicalReminderStore.run(withPast: value);
                      setState(() => _showPastReminders = value);
                    },
                    padding: const EdgeInsets.all(6),
                    value: _showPastReminders,
                  ),
                ),
              _loadMedicalReminderStore.loading
                  ? _buildLoading()
                  : medicalReminders.isNotEmpty
                      ? _buildReminders(medicalReminders)
                      : _buildNoReminder(),
            ],
          ),
          pageName: 'Consultas',
          history: const Text('Histórico em breve'),
        );
      },
    );
  }
}
