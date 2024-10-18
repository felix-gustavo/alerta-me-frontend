import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/authorizations.dart';
import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../stores/authorization/autorization/authorization_store.dart';
import '../../../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../../../../common_components/container_reminder.dart';
import '../../../../common_components/my_dialog.dart';
import 'medication_reminder_details.dart';
import 'medication_reminder_edit.dart';

class MedicationReminderWidget extends StatefulWidget {
  final bool toBreak;
  const MedicationReminderWidget(this.toBreak, {super.key});

  @override
  State<MedicationReminderWidget> createState() =>
      _MedicationReminderWidgetState();
}

class _MedicationReminderWidgetState extends State<MedicationReminderWidget> {
  late final AuthorizationStore _authorizationStore;
  late final LoadMedicationReminderStore _loadMedicationReminderStore;

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

  Future<void> _add() => showDialog(
        context: context,
        builder: (_) => const MyDialog(
          title: 'Criação de Lembrete de Medicamento',
          child: SizedBox(
            width: 600,
            child: MedicationReminderEditWidget(),
          ),
        ),
      );

  void _onTapDetails(MedicationReminder medicationReminder) {
    showDialog(
      context: context,
      builder: (_) => MyDialog(
        title: 'Detalhes de Lembrete de Medicamento',
        canPop: true,
        child: MedicationReminderDetails(
          medicationReminder: medicationReminder,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Observer(
      builder: (_) {
        final medicationReminders =
            _loadMedicationReminderStore.medicationReminders;
        final authorizationApproved =
            _authorizationStore.authorization?.status ==
                AuthorizationStatus.aprovado;

        final content = Card(
          child: Visibility(
            visible: medicationReminders.isNotEmpty,
            replacement: Padding(
              padding: const EdgeInsets.all(12),
              child: IntrinsicHeight(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sticky_note_2_outlined,
                        size: context.isMobile ? 45 : 72,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      Text(
                        'Sem lembretes',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 9,
                top: 9,
                left: 15,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth - 15;
                  final nameColWidth = width * .4;
                  final weekColWidth = (width * .6) / Weekday.values.length;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.only(right: 15),
                    child: DataTable(
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: nameColWidth,
                            child: const Text('Nome do Medicamento'),
                          ),
                        ),
                        ...Weekday.values.map(
                          (e) => DataColumn(
                            label: SizedBox(
                              width: weekColWidth,
                              child: Text(
                                context.screenWidth < 600
                                    ? e.namePtBrShort[0]
                                    : e.namePtBrShort,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: [
                        ...medicationReminders.map(
                          (e) => DataRow(
                            onSelectChanged: (_) => _onTapDetails(e),
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: nameColWidth,
                                  child: Text(
                                    e.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              ...e.dose.entries.map(
                                (e) {
                                  final value = e.value;
                                  return DataCell(
                                    Center(
                                      child: value != null && value.isNotEmpty
                                          ? Icon(
                                              Icons.done_rounded,
                                              color: colorScheme.primary,
                                              size:
                                                  context.isMobile ? 18 : null,
                                            )
                                          : Text(
                                              '-',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    color: colorScheme
                                                        .outlineVariant,
                                                  ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );

        return ContainerReminder(
          onPressed: authorizationApproved ? _add : null,
          title: 'Lembretes de Medicamentos',
          page: widget.toBreak
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 330),
                  child: content,
                )
              : Expanded(child: content),
        );
      },
    );
  }
}
