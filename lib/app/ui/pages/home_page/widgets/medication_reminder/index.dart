import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../../model/authorizations.dart';
import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../stores/authorization/autorization/authorization_store.dart';
import '../../../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../../../../common_components/container_reminder.dart';
import '../../../../common_components/my_dialog.dart';
import 'medication_reminder_card.dart';
import 'medication_reminder_details.dart';
import 'medication_reminder_edit.dart';

class MedicationReminderWidget extends StatefulWidget {
  const MedicationReminderWidget({Key? key}) : super(key: key);

  @override
  State<MedicationReminderWidget> createState() =>
      _MedicationReminderWidgetState();
}

class _MedicationReminderWidgetState extends State<MedicationReminderWidget> {
  late final AuthorizationStore _authorizationStore;
  late final LoadMedicationReminderStore _loadMedicationReminderStore;
  late final ScrollController _remindersScollController = ScrollController();

  late String? _hoverId = '';

  @override
  void initState() {
    super.initState();

    _authorizationStore = Provider.of<AuthorizationStore>(
      context,
      listen: false,
    );

    _loadMedicationReminderStore = Provider.of<LoadMedicationReminderStore>(
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
          'Experimente criar lembretes de medicamentos',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: context.colors.grey),
        ),
      ],
    );
  }

  Widget _buildReminders(List<MedicationReminder> medicationReminders) {
    final medicationRemindersCards = medicationReminders.map(
      (mr) => InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => MyDialog(
              title: 'Detalhes de Lembrete de Medicamento',
              confirmPop: false,
              child: MedicationReminderDetails(medicationReminder: mr),
            ),
          );
        },
        onHover: (value) => setState(() => _hoverId = value ? mr.id : ''),
        child: MedicationReminderCard(
          medicationReminder: mr,
          isHover: _hoverId == mr.id,
        ),
      ),
    );

    return Scrollbar(
      controller: _remindersScollController,
      child: SingleChildScrollView(
        controller: _remindersScollController,
        padding: const EdgeInsets.only(bottom: 18),
        scrollDirection: Axis.horizontal,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: medicationRemindersCards
                .separator(const SizedBox(width: 12))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAddMedicationReminderButton() {
    final authorizationApproved = _authorizationStore.authorization?.status ==
        AuthorizationStatus.aprovado;

    return IconButton(
      onPressed: authorizationApproved
          ? () {
              showDialog(
                context: context,
                builder: (_) => const MyDialog(
                  title: 'Criação de Lembrete de Medicamento',
                  child: SizedBox(
                    width: 549,
                    child: MedicationReminderEditWidget(),
                  ),
                ),
              );
            }
          : null,
      icon: const Icon(Icons.add),
      splashRadius: 18,
      tooltip: !authorizationApproved
          ? 'Vincule-se a uma pessoa idosa para configurar este lembrete'
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final medicationReminders =
            _loadMedicationReminderStore.medicationReminders;
        return ContainerReminder(
          action: _buildAddMedicationReminderButton(),
          page: _loadMedicationReminderStore.loading
              ? _buildLoading()
              : medicationReminders.isNotEmpty
                  ? _buildReminders(medicationReminders)
                  : _buildNoReminder(),
          pageName: 'Medicamento',
          history: const Text('Histórico em breve'),
        );
      },
    );
  }
}
