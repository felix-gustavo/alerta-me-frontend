import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../../stores/medication_reminder/delete_medication_reminder/delete_medication_reminder_store.dart';
import '../../../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../../../../common_components/confirm_dialog.dart';
import '../../../../common_components/my_dialog.dart';
import 'details_content.dart';
import 'details_content_mobile.dart';
import 'medication_reminder_edit.dart';

class MedicationReminderDetails extends StatefulWidget {
  final MedicationReminder medicationReminder;

  const MedicationReminderDetails({
    super.key,
    required this.medicationReminder,
  });

  @override
  State<MedicationReminderDetails> createState() =>
      _MedicationReminderDetailsState();
}

class _MedicationReminderDetailsState extends State<MedicationReminderDetails> {
  late final DeleteMedicationReminderStore _deleteMedicationReminderStore;
  late final LoadMedicationReminderStore _loadMedicationReminderStore;

  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();

    _deleteMedicationReminderStore = Provider.of<DeleteMedicationReminderStore>(
      context,
      listen: false,
    );

    _loadMedicationReminderStore = Provider.of<LoadMedicationReminderStore>(
      context,
      listen: false,
    );

    _disposer = reaction(
      (_) => _deleteMedicationReminderStore.medicationId,
      (medicationId) {
        if (medicationId != null) {
          _loadMedicationReminderStore.removeMedicationReminder(medicationId);
        }
      },
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  Widget _buildCardDosage(Dosage dosage) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(.6),
        ),
      ),
      child: Column(
        children: [
          Text(
            dosage.time.toHHMM,
            style: textTheme.bodyMedium!.copyWith(color: colorScheme.primary),
          ),
          Text(
            '${dosage.amount} ${widget.medicationReminder.dosageUnit}',
          ),
        ],
      ),
    );
  }

  void _doDelete() async {
    final navigator = Navigator.of(context);

    await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Exclusão de lembrete de medicamento',
        content:
            'O lembrete para o medicamento ${widget.medicationReminder.name} será excluído, deseja realmente excluir?',
        negativeBtnText: 'Não',
        positiveBtnText: 'Sim',
        onPostivePressed: () async {
          final id = widget.medicationReminder.id;
          if (id != null) {
            Navigator.of(context).pop();
            await _deleteMedicationReminderStore.run(id: id).then((_) {
              final errorMessage = _deleteMedicationReminderStore.errorMessage;
              errorMessage != null
                  ? EasyLoading.showError(errorMessage)
                  : EasyLoading.showSuccess('Configuração salva');
            }).whenComplete(() => navigator.pop());
          }
        },
      ),
    );
  }

  void _goEditPage() {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (_) => MyDialog(
        title: 'Edição de Lembrete de Medicamento',
        child: SizedBox(
          width: 600,
          child: MedicationReminderEditWidget(
            medicationReminder: widget.medicationReminder,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            context.isMobile
                ? DetailsContentMobile(
                    medicationReminder: widget.medicationReminder,
                    buildCardDosage: _buildCardDosage,
                  )
                : DetailsContent(
                    medicationReminder: widget.medicationReminder,
                    buildCardDosage: _buildCardDosage,
                  ),
            const SizedBox(height: 21),
            _deleteMedicationReminderStore.loading
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: _doDelete,
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context).colorScheme.error,
                        ),
                        label: const Text('Excluir'),
                        icon: const Icon(Icons.delete),
                      ),
                      const SizedBox(width: 15),
                      TextButton(
                        onPressed: _goEditPage,
                        child: const Text('Editar'),
                      ),
                    ],
                  )
          ],
        );
      },
    );
  }
}
