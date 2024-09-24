import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../stores/medical_reminder/delete_medical_reminder/delete_medical_reminder_store.dart';
import '../../../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../../common_components/confirm_dialog.dart';
import '../../../../common_components/my_dialog.dart';
import 'medical_reminder_edit.dart';
import 'preview_card_edit.dart';

class MedicalReminderDetails extends StatefulWidget {
  final MedicalReminder medicalReminder;

  const MedicalReminderDetails({Key? key, required this.medicalReminder})
      : super(key: key);

  @override
  State<MedicalReminderDetails> createState() => _MedicalReminderDetailsState();
}

class _MedicalReminderDetailsState extends State<MedicalReminderDetails> {
  bool _isExpanded = false;
  late MedicalReminder _medicalReminderEdit = widget.medicalReminder.copyWith();
  late final DeleteMedicalReminderStore _deleteMedicalReminderStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();

    _deleteMedicalReminderStore = Provider.of<DeleteMedicalReminderStore>(
      context,
      listen: false,
    );

    _loadMedicalReminderStore = Provider.of<LoadMedicalReminderStore>(
      context,
      listen: false,
    );

    _disposer = reaction(
      (_) => _deleteMedicalReminderStore.medicalId,
      (medicationId) {
        if (medicationId != null) {
          _loadMedicalReminderStore.removeMedicalReminder(medicationId);
        }
      },
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  void _doDelete() async {
    final navigator = Navigator.of(context);

    await showDialog(
      context: context,
      builder: (context) => SizedBox(
        width: 330,
        child: ConfirmDialog(
          title: 'Exclusão de lembrete de consulta',
          content:
              'O lembrete para a consulta com ${widget.medicalReminder.medicName} será excluído, deseja realmente excluir?',
          negativeBtnText: 'Não',
          positiveBtnText: 'Sim',
          onPostivePressed: () async {
            final id = widget.medicalReminder.id;
            if (id != null) {
              Navigator.of(context).pop();
              await _deleteMedicalReminderStore.run(id: id).then((_) {
                final errorMessage = _deleteMedicalReminderStore.errorMessage;
                errorMessage != null
                    ? EasyLoading.showError(errorMessage)
                    : EasyLoading.showSuccess('Configuração salva');
              }).whenComplete(() => navigator.pop());
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MyDialog(
      canPop: !_isExpanded,
      title: 'Detalhes de Lembrete de Consulta',
      child: SizedBox(
        width: _isExpanded
            ? context.isMobile
                ? 480
                : 752
            : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PreviewCardEdit(
              medicalReminder: widget.medicalReminder,
              medicalReminderEdit: _medicalReminderEdit,
              isEdit: _isExpanded,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      widget.medicalReminder.active
                          ? Icons.alarm_on_outlined
                          : Icons.alarm_off_outlined,
                    ),
                    const SizedBox(width: 9),
                    Text(
                      'Lembrete ${widget.medicalReminder.active ? 'ativado' : 'desativado'}',
                    ),
                  ],
                ),
                Observer(
                  builder: (context) {
                    return _deleteMedicalReminderStore.loading
                        ? const Padding(
                            padding: EdgeInsets.all(6),
                            child: SizedBox.square(
                              dimension: 21,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : IconButton(
                            onPressed: _doDelete,
                            color: Theme.of(context).colorScheme.error,
                            icon: const Icon(Icons.delete),
                          );
                  },
                )
              ],
            ),
            const SizedBox(height: 12),
            ExpansionTile(
              onExpansionChanged: (_) {
                setState(() => _isExpanded = !_isExpanded);
              },
              collapsedBackgroundColor: colorScheme.surfaceContainerLowest,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(.6),
                ),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.circular(9)),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withOpacity(.6),
                ),
              ),
              title: const Text('Edição'),
              textColor: colorScheme.primary,
              children: [
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: MedicalReminderEditWidget(
                    medicalReminder: _medicalReminderEdit,
                    onChangeMedical: (medicalReminder) => setState(
                      () => _medicalReminderEdit = medicalReminder,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
