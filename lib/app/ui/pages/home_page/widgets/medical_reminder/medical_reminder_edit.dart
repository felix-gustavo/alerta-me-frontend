import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/datetime_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../stores/medical_reminder/edit_medical_reminder/edit_medical_reminder_store.dart';
import '../../../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../../common_components/active_switch.dart';

class MedicalReminderEditWidget extends StatefulWidget {
  final void Function(MedicalReminder medicalReminder)? onChangeMedical;
  final MedicalReminder? medicalReminder;

  const MedicalReminderEditWidget({
    super.key,
    this.onChangeMedical,
    this.medicalReminder,
  });

  @override
  State<MedicalReminderEditWidget> createState() =>
      _MedicalReminderEditWidgetState();
}

class _MedicalReminderEditWidgetState extends State<MedicalReminderEditWidget> {
  late MedicalReminder _medicalReminder;

  late TextEditingController _medicNameControl;
  late TextEditingController _specialtyControl;
  late TextEditingController _addressControl;

  late GlobalKey<FormState> _formKey;

  late final EditMedicalReminderStore _editMedicalReminderStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();

    _medicalReminder = widget.medicalReminder ?? MedicalReminder.empty();

    _medicNameControl = TextEditingController(text: _medicalReminder.medicName);
    _specialtyControl = TextEditingController(text: _medicalReminder.specialty);
    _addressControl = TextEditingController(text: _medicalReminder.address);

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
    _medicNameControl.dispose();
    _specialtyControl.dispose();

    _formKey.currentState?.dispose();
    _disposer();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
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
    final bodySmallStyle = textTheme.bodySmall!.copyWith(
      color: Theme.of(context).colorScheme.outline,
    );

    return Form(
      key: _formKey,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 333, maxWidth: 752),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Defina a data e hora',
              style: textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Data',
                          style: bodySmallStyle,
                        ),
                        const SizedBox(height: 3),
                        TextButton(
                          onPressed: () async {
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
                                widget.onChangeMedical?.call(_medicalReminder);
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                              textStyle: textTheme.titleMedium),
                          child: Text(_medicalReminder.dateTime.toDateBRL),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Hora', style: bodySmallStyle),
                        const SizedBox(height: 3),
                        TextButton(
                          onPressed: () async {
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
                                widget.onChangeMedical?.call(_medicalReminder);
                              });
                            }
                          },
                          style: TextButton.styleFrom(
                            textStyle: textTheme.titleMedium,
                          ),
                          child: Text(_medicalReminder.dateTime.toTime),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Dados sobre a consulta',
              style: textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
                child: Column(
                  children: [
                    Focus(
                      onFocusChange: (value) {
                        if (!value) {
                          final text = _medicNameControl.text;
                          if (_medicalReminder.medicName != text) {
                            setState(() {
                              _medicalReminder =
                                  _medicalReminder.copyWith(medicName: text);
                              widget.onChangeMedical?.call(_medicalReminder);
                            });
                          }
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nome do médico'),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _medicNameControl,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              helperText: '',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            maxLength: 60,
                            validator: ValidationBuilder().minLength(3).build(),
                          ),
                        ],
                      ),
                    ),
                    Focus(
                      onFocusChange: (value) {
                        if (!value) {
                          final text = _specialtyControl.text;
                          if (_medicalReminder.specialty != text) {
                            setState(() {
                              _medicalReminder =
                                  _medicalReminder.copyWith(specialty: text);
                              widget.onChangeMedical?.call(_medicalReminder);
                            });
                          }
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Especialidade'),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _specialtyControl,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              helperText: '',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            maxLength: 43,
                            validator: ValidationBuilder().minLength(3).build(),
                          ),
                        ],
                      ),
                    ),
                    Focus(
                      onFocusChange: (value) {
                        if (!value) {
                          final text = _addressControl.text;
                          if (_medicalReminder.address != text) {
                            setState(() {
                              _medicalReminder =
                                  _medicalReminder.copyWith(address: text);
                              widget.onChangeMedical?.call(_medicalReminder);
                            });
                          }
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Endereço'),
                          const SizedBox(height: 3),
                          TextFormField(
                            controller: _addressControl,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              helperText: '',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                            ),
                            maxLength: 130,
                            maxLines: 3,
                            keyboardType: TextInputType.multiline,
                            validator: ValidationBuilder().minLength(3).build(),
                          ),
                        ],
                      ),
                    ),
                  ].separator(const SizedBox(height: 12)),
                ),
              ),
            ),
            const SizedBox(height: 6),
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
                    widget.onChangeMedical?.call(_medicalReminder);
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
