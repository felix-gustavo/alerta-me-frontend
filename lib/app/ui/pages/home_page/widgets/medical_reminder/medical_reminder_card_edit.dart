import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/datetime_extension.dart';
import '../../../../../shared/extensions/string_extension.dart';
import '../../../../../shared/extensions/validation_builder_extension.dart';
import '../../../../../stores/medical_reminder/edit_medical_reminder/edit_medical_reminder_store.dart';
import '../../../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../../common_components/active_switch.dart';

class MedicalReminderCardEdit extends StatefulWidget {
  final MedicalReminder? medicalReminder;

  const MedicalReminderCardEdit(this.medicalReminder, {super.key});

  @override
  State<MedicalReminderCardEdit> createState() =>
      _MedicalReminderCardEditState();
}

class _MedicalReminderCardEditState extends State<MedicalReminderCardEdit> {
  late MedicalReminder _medicalReminder;

  late GlobalKey<FormState> _formKey;

  late final EditMedicalReminderStore _editMedicalReminderStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _medicalReminder = widget.medicalReminder ?? MedicalReminder.empty();

    _formKey = GlobalKey<FormState>();

    _editMedicalReminderStore = Provider.of<EditMedicalReminderStore>(
      context,
      listen: false,
    );

    _loadMedicalReminderStore = Provider.of<LoadMedicalReminderStore>(
      context,
      listen: false,
    );

    _disposer = reaction(
      (_) => _editMedicalReminderStore.medicalReminder,
      (medicalReminder) {
        if (medicalReminder != null) {
          _loadMedicalReminderStore.addOrUpdateMedicalReminder(medicalReminder);
        }
      },
    );
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _disposer();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final navigator = Navigator.of(context);
      await _editMedicalReminderStore.run(data: _medicalReminder);

      final errorMessage = _editMedicalReminderStore.errorMessage;
      if (errorMessage == null) {
        EasyLoading.showSuccess('Configuração salva');
        navigator.pop();
      } else {
        EasyLoading.showError(errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final date = _medicalReminder.dateTime.toLocal();

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 315, maxWidth: 426),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: _medicalReminder.medicName,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 2,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                        hintText: 'Nome',
                        hoverColor: Theme.of(context).hoverColor,
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.transparent,
                      ),
                      inputFormatters: [LengthLimitingTextInputFormatter(60)],
                      textInputAction: TextInputAction.next,
                      validator: ValidationBuilder().minLengthCustom(3).build(),
                      onSaved: (newValue) => setState(
                        () => _medicalReminder = _medicalReminder.copyWith(
                          medicName: newValue?.trim(),
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: _medicalReminder.specialty,
                      inputFormatters: [LengthLimitingTextInputFormatter(43)],
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                        hintText: 'Especialidade',
                        hoverColor: Theme.of(context).hoverColor,
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.transparent,
                      ),
                      validator: ValidationBuilder().minLengthCustom(3).build(),
                      onSaved: (newValue) => setState(
                        () => _medicalReminder = _medicalReminder.copyWith(
                          specialty: newValue?.trim(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      child: Wrap(
                        spacing: 6,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () async {
                              final newDate = await showDatePicker(
                                context: context,
                                initialDate: _medicalReminder.dateTime,
                                firstDate: widget.medicalReminder?.dateTime ??
                                    DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (newDate != null) {
                                setState(() {
                                  final dateTime =
                                      _medicalReminder.dateTime.updateDate(
                                    newDate,
                                  );
                                  _medicalReminder = _medicalReminder.copyWith(
                                    dateTime: dateTime,
                                  );
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.calendar_month),
                                  const SizedBox(width: 3),
                                  Text(
                                    DateFormat("d 'de' MMMM 'de' yyyy", 'pt_BR')
                                        .format(date)
                                        .capitalize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () async {
                              final newTime = await showTimePicker(
                                context: context,
                                initialTime:
                                    _medicalReminder.dateTime.toTimeOfDay,
                              );
                              if (newTime != null) {
                                setState(() {
                                  final dateTime =
                                      _medicalReminder.dateTime.updateTime(
                                    newTime,
                                  );
                                  _medicalReminder = _medicalReminder.copyWith(
                                    dateTime: dateTime,
                                  );
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Tooltip(
                                    message: _medicalReminder.active
                                        ? 'Ativo'
                                        : 'Desativado',
                                    child: Icon(
                                      _medicalReminder.active
                                          ? Icons.alarm_on_outlined
                                          : Icons.alarm_off_outlined,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    DateFormat.Hm('pt_BR')
                                        .format(date)
                                        .capitalize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      initialValue: _medicalReminder.address,
                      style: textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                        hoverColor: Theme.of(context).hoverColor,
                        filled: true,
                        border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Colors.transparent,
                        hintText: 'Endereço',
                      ),
                      minLines: 1,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      inputFormatters: [LengthLimitingTextInputFormatter(130)],
                      validator: ValidationBuilder().minLengthCustom(3).build(),
                      onSaved: (newValue) => setState(
                        () => _medicalReminder = _medicalReminder.copyWith(
                          address: newValue?.trim(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Clique no campo que deseja alterar',
              style: textTheme.labelMedium!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ActiveSwitch(
                  value: _medicalReminder.active,
                  onChangeActive: (value) {
                    setState(() {
                      _medicalReminder = _medicalReminder.copyWith(
                        active: value,
                      );
                    });
                  },
                ),
                Observer(
                  builder: (_) => _editMedicalReminderStore.loading
                      ? const CircularProgressIndicator()
                      : FilledButton(
                          onPressed: _submit,
                          child: const Text('Salvar'),
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
