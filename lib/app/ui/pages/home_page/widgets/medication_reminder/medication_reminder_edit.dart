import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../stores/medication_reminder/edit_medication_reminder/edit_medication_reminder_store.dart';
import '../../../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import 'medication_reminder_dose_section.dart';
import 'medication_reminder_info_section.dart';

class MedicationReminderEditWidget extends StatefulWidget {
  final MedicationReminder? medicationReminder;

  const MedicationReminderEditWidget({
    super.key,
    this.medicationReminder,
  });

  @override
  State<MedicationReminderEditWidget> createState() =>
      _MedicationReminderEditWidgetState();
}

class _MedicationReminderEditWidgetState
    extends State<MedicationReminderEditWidget> {
  late MedicationReminder _medicationReminder;

  late TextEditingController _medicationNameControl;
  late TextEditingController _dosageUnitControl;
  late TextEditingController _dosagePronunciationControl;
  late TextEditingController _commentsControl;

  late GlobalKey<FormState> _formKey;

  late final EditMedicationReminderStore _editMedicationReminderStore;
  late final LoadMedicationReminderStore _loadMedicationReminderStore;
  late final ReactionDisposer _disposer;

  late final Map<Weekday, bool> _isActivated;
  late int _currentPage;

  @override
  void initState() {
    super.initState();

    _medicationReminder =
        widget.medicationReminder ?? MedicationReminder.empty();

    _medicationNameControl = TextEditingController(
      text: _medicationReminder.name,
    );
    _dosageUnitControl = TextEditingController(
      text: _medicationReminder.dosageUnit,
    );
    _dosagePronunciationControl = TextEditingController(
      text: _medicationReminder.dosagePronunciation,
    );
    _commentsControl = TextEditingController(
      text: _medicationReminder.comments,
    );

    _formKey = GlobalKey<FormState>();

    _editMedicationReminderStore = Provider.of<EditMedicationReminderStore>(
      context,
      listen: false,
    );

    _loadMedicationReminderStore = Provider.of<LoadMedicationReminderStore>(
      context,
      listen: false,
    );

    _disposer = reaction(
      (_) => _editMedicationReminderStore.medicationReminder,
      (medicationReminder) {
        if (medicationReminder != null) {
          _loadMedicationReminderStore
              .addOrUpdateMedicationReminder(medicationReminder);
        }
      },
    );

    _isActivated = {
      for (final weekday in Weekday.values)
        weekday: (_medicationReminder.dose[weekday]?.length ?? 0) > 0
    };
    // _pageController = PageController(initialPage: 0);
    // _pageController.addListener(() {
    //   final currentPage = _pageController.page?.toInt() ?? 0;
    //   if (_currentPage != currentPage) {
    //     setState(() => _currentPage = currentPage);
    //   }
    // });
    _currentPage = 0;
  }

  @override
  void dispose() {
    _medicationNameControl.dispose();
    _dosageUnitControl.dispose();
    _dosagePronunciationControl.dispose();
    _commentsControl.dispose();

    _formKey.currentState?.dispose();
    _disposer();
    // _pageController.dispose();
    super.dispose();
  }

  String? _findDuplicateDosageDays(Map<Weekday, List<Dosage>?> dose) {
    final Set<Weekday> duplicateDays = {};

    dose.forEach((day, dosages) {
      if (dosages != null) {
        final Set<TimeOfDay> timeOccurrences = {};
        for (var dosage in dosages) {
          if (timeOccurrences.contains(dosage.time)) {
            duplicateDays.add(day);
            break;
          }
          timeOccurrences.add(dosage.time);
        }
      }
    });

    return duplicateDays.isNotEmpty
        ? duplicateDays.map((e) => e.namePtBr).join(', ')
        : null;
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;

    if (formValid) {
      final doseFiltered = _medicationReminder.dose.map(
        (w, d) => MapEntry(w, _isActivated[w]! ? d : null),
      );

      final duplicateDosageDays = _findDuplicateDosageDays(doseFiltered);
      if (duplicateDosageDays?.isNotEmpty ?? false) {
        return EasyLoading.showError(
          'Horários duplicados [$duplicateDosageDays]',
        );
      }

      final navigator = Navigator.of(context);

      await _editMedicationReminderStore.run(
        data: _medicationReminder.copyWith(dose: doseFiltered),
      );

      final errorMessage = _editMedicationReminderStore.errorMessage;
      if (errorMessage == null) {
        EasyLoading.showSuccess('Configuração salva');
        return navigator.pop();
      }
      EasyLoading.showError(errorMessage);
    }
  }

  void _onStepContinue() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    if (formValid) {
      if (_currentPage == 0) {
        setState(() {
          _currentPage++;
          _medicationReminder = _medicationReminder.copyWith(
            name: _medicationNameControl.text,
            dosageUnit: _dosageUnitControl.text,
            dosagePronunciation: _dosagePronunciationControl.text,
            comments: _commentsControl.text,
          );
        });
      } else if (_currentPage == 1) {
        await _submit();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stepper(
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (details.currentStep == 1) ...[
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Voltar'),
                  ),
                  const SizedBox(width: 9),
                ],
                FilledButton(
                  onPressed: details.onStepContinue,
                  child: const Text('Continuar'),
                ),
              ],
            ),
          );
        },
        onStepContinue: _onStepContinue,
        currentStep: _currentPage,
        onStepTapped: (value) {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (!formValid) return;
          setState(() => _currentPage = value);
        },
        onStepCancel: () {
          if (_currentPage > 0) setState(() => _currentPage--);
        },
        steps: [
          Step(
            state: _currentPage == 1 ? StepState.complete : StepState.indexed,
            stepStyle: StepStyle(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            title: Text(
              'Dados iniciais',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            content: MedicationReminderInfoSection(
              dosageUnitControl: _dosageUnitControl,
              dosagePronunciationControl: _dosagePronunciationControl,
              medicationNameControl: _medicationNameControl,
              commentsControl: _commentsControl,
            ),
          ),
          Step(
            title: Text(
              'Dosagem',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: _currentPage == 1
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
            ),
            stepStyle: StepStyle(
              color: _currentPage == 1
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
            ),
            content: MedicationReminderDoseSection(
              dose: _medicationReminder.dose,
              dosageUnit: _medicationReminder.dosageUnit,
              onExpand: ({required isExpand, required weekday}) {
                setState(() => _isActivated[weekday] = isExpand);
              },
              activated: _isActivated,
              onChangeDose: ({
                required Weekday weekday,
                List<Dosage>? dosage,
              }) {
                setState(() {
                  final medicationReminderDose = {..._medicationReminder.dose};
                  medicationReminderDose[weekday] = dosage;
                  _medicationReminder = _medicationReminder.copyWith(
                    dose: medicationReminderDose,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
