import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:form_validator/form_validator.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/datetime_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/string_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../../stores/medical_reminder/edit_medical_reminder/edit_medical_reminder_store.dart';
import '../../../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';

class MedicalReminderEditWidget extends StatefulWidget {
  final MedicalReminder? medicalReminder;
  final void Function(MedicalReminder medicalReminder)? onEdit;
  final bool isMobile;

  const MedicalReminderEditWidget({
    Key? key,
    this.medicalReminder,
    this.onEdit,
    required this.isMobile,
  }) : super(key: key);

  @override
  State<MedicalReminderEditWidget> createState() =>
      _MedicalReminderEditWidgetState();
}

class _MedicalReminderEditWidgetState extends State<MedicalReminderEditWidget> {
  late ValueNotifier<MedicalReminder> _medicalReminder;

  late TextEditingController _medicNameControl;
  late TextEditingController _specialtyControl;
  late TextEditingController _addressControl;

  late TextEditingController _dateController;
  late TextEditingController _timeController;

  late GlobalKey<FormState> _formKey;

  late final EditMedicalReminderStore _editMedicalReminderStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();

    _medicalReminder = ValueNotifier(
      widget.medicalReminder ?? MedicalReminder.empty(),
    );
    _medicalReminder.addListener(
      () => widget.onEdit?.call(_medicalReminder.value),
    );

    _medicNameControl =
        TextEditingController(text: _medicalReminder.value.medicName);
    _specialtyControl =
        TextEditingController(text: _medicalReminder.value.specialty);
    _addressControl =
        TextEditingController(text: _medicalReminder.value.address);

    _formKey = GlobalKey<FormState>();

    final dateTime = _medicalReminder.value.dateTime;

    _dateController = TextEditingController(text: dateTime.toDateBRL);
    _timeController = TextEditingController(text: dateTime.toTime);

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
    _medicalReminder.dispose();
    _medicNameControl.dispose();
    _specialtyControl.dispose();

    _dateController.dispose();
    _timeController.dispose();
    _formKey.currentState?.dispose();
    _disposer();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final navigator = Navigator.of(context);
      await _editMedicalReminderStore.run(data: _medicalReminder.value);

      final errorMessage = _editMedicalReminderStore.errorMessage;
      errorMessage != null
          ? EasyLoading.showError(errorMessage)
          : EasyLoading.showSuccess('Configuração salva');

      navigator.pop();
    }
  }

  Widget content(isMobile) {
    final List<Widget> medicSpecialtyFields = [
      Focus(
        onFocusChange: (_) {
          if (_medicalReminder.value.medicName != _medicNameControl.text) {
            setState(() {
              _medicalReminder.value = _medicalReminder.value.copyWith(
                medicName: _medicNameControl.text,
              );
            });
          }
        },
        child: TextFormField(
          controller: _medicNameControl,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            helperText: '',
            labelText: 'Nome do médico',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          maxLength: 60,
          validator: ValidationBuilder().minLength(3).build(),
        ),
      ),
      Focus(
        onFocusChange: (_) {
          if (_medicalReminder.value.specialty != _specialtyControl.text) {
            setState(() {
              _medicalReminder.value = _medicalReminder.value.copyWith(
                specialty: _specialtyControl.text,
              );
            });
          }
        },
        child: TextFormField(
          controller: _specialtyControl,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            helperText: '',
            labelText: 'Especialidade',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          maxLength: 43,
          validator: ValidationBuilder().minLength(3).build(),
        ),
      ),
    ];

    final List<Widget> dateTimeAddrsFields = [
      Row(
        children: [
          Flexible(
            child: TextFormField(
              readOnly: true,
              controller: _dateController,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                helperText: '',
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.calendar_month),
                ),
                labelText: 'Data',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding: EdgeInsets.only(left: 12),
              ),
              onTap: () async {
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: _dateController.text.dateBRLtoDateTime,
                  firstDate: DateTime(
                    widget.medicalReminder?.dateTime.year ??
                        DateTime.now().year,
                  ),
                  lastDate: DateTime(2100),
                );
                if (newDate != null) {
                  setState(() {
                    _dateController.text = newDate.toDateBRL;
                    _medicalReminder.value = _medicalReminder.value.copyWith(
                      dateTime:
                          _medicalReminder.value.dateTime.updateDate(newDate),
                    );
                  });
                }
              },
            ),
          ),
          IntrinsicWidth(
            child: TextFormField(
              readOnly: true,
              controller: _timeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                helperText: '',
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.access_time),
                ),
                labelText: 'Hora',
                contentPadding: EdgeInsets.only(left: 12),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              onTap: () async {
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: _timeController.text.hhmmToTime,
                );
                if (newTime != null) {
                  setState(() {
                    _timeController.text = newTime.toHHMM;
                    _medicalReminder.value = _medicalReminder.value.copyWith(
                      dateTime:
                          _medicalReminder.value.dateTime.updateTime(newTime),
                    );
                  });
                }
              },
            ),
          ),
        ].separator(const SizedBox(width: 12)).toList(),
      ),
      Focus(
        onFocusChange: (_) {
          if (_medicalReminder.value.address != _addressControl.text) {
            setState(() {
              _medicalReminder.value = _medicalReminder.value.copyWith(
                address: _addressControl.text,
              );
            });
          }
        },
        child: TextFormField(
          controller: _addressControl,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            helperText: '',
            labelText: 'Endereço',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
          maxLength: 130,
          validator: ValidationBuilder().minLength(3).build(),
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Adicione informações referentes a consulta médica',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: context.colors.grey),
          ),
          ...isMobile
              ? [...medicSpecialtyFields, ...dateTimeAddrsFields]
              : [
                  Row(
                    children: medicSpecialtyFields
                        .map((field) => Flexible(child: field))
                        .separator(const SizedBox(width: 12))
                        .toList(),
                  ),
                  Row(
                    children: dateTimeAddrsFields
                        .map((e) => Flexible(child: e))
                        .separator(const SizedBox(width: 12))
                        .toList(),
                  ),
                ],
          Observer(
            builder: (_) => Align(
              alignment: Alignment.centerRight,
              child: _editMedicalReminderStore.loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Salvar'),
                    ),
            ),
          ),
        ].separator(const SizedBox(height: 12)).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => content(widget.isMobile);
}
