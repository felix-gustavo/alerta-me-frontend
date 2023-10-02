import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../../stores/medication_reminder/edit_medication_reminder/edit_medication_reminder_store.dart';
import '../../../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import 'medication_reminder_dose_section.dart';
import 'medication_reminder_info_section.dart';

class MedicationReminderEditWidget extends StatefulWidget {
  final MedicationReminder? medicationReminder;

  const MedicationReminderEditWidget({
    Key? key,
    this.medicationReminder,
  }) : super(key: key);

  @override
  State<MedicationReminderEditWidget> createState() =>
      _MedicalReminderEditWidgetState();
}

class _MedicalReminderEditWidgetState
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
  late PageController _pageController;
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
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      final currentPage = _pageController.page?.toInt() ?? 0;
      if (_currentPage != currentPage) {
        setState(() => _currentPage = currentPage);
      }
    });
    _currentPage = 0;
  }

  @override
  void dispose() {
    _medicationNameControl.dispose();
    _dosageUnitControl.dispose();
    _commentsControl.dispose();

    _formKey.currentState?.dispose();
    _disposer();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final doseFiltered = _medicationReminder.dose.map(
      (weekday, dosages) => MapEntry(
        weekday,
        _isActivated[weekday]! ? dosages : null,
      ),
    );

    final medicationReminder = _medicationReminder.copyWith(dose: doseFiltered);
    bool hasDuplicateTime = false;

    medicationReminder.dose.forEach((key, value) {
      if (value != null) {
        final Set<TimeOfDay> uniqueTimes = <TimeOfDay>{};

        for (final dose in value) {
          final time = dose.time;

          if (uniqueTimes.contains(time)) {
            hasDuplicateTime = true;
            EasyLoading.showError('Horários duplicados (${key.namePtBr})');
            break;
          } else {
            uniqueTimes.add(time);
          }
        }
      }
    });

    if (!hasDuplicateTime) {
      await _editMedicationReminderStore.run(data: medicationReminder).then(
        (_) {
          final navigator = Navigator.of(context);

          final errorMessage = _editMedicationReminderStore.errorMessage;
          errorMessage != null
              ? EasyLoading.showError(errorMessage)
              : EasyLoading.showSuccess('Configuração salva');

          navigator.pop();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controlButtons = [
      if (_currentPage == 1)
        TextButton(
          onPressed: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
          child: Text(
            'Voltar',
            style: textTheme.bodyMedium!.copyWith(
              color: context.colors.grey,
            ),
          ),
        ),
      ElevatedButton(
        onPressed: () async {
          final formValid = _formKey.currentState?.validate() ?? false;
          if (formValid) {
            if (_currentPage == 0) {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
              setState(() {
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
        },
        child: Text(
          'Continuar',
          style: textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
      ),
    ];

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Adicione informações referentes a medicamentos',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: context.colors.grey),
          ),
          const SizedBox(height: 12),
          ExpandablePageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MedicationReminderInfoSection(
                dosageUnitControl: _dosageUnitControl,
                dosagePronunciationControl: _dosagePronunciationControl,
                medicationNameControl: _medicationNameControl,
                commentsControl: _commentsControl,
              ),
              MedicationReminderDoseSection(
                medicationReminder: _medicationReminder,
                onExpand: ({required isExpand, required weekday}) {
                  setState(() {
                    _isActivated[weekday] = isExpand;
                  });
                },
                activated: _isActivated,
                onChangeDose: ({required newDose}) => setState(() {
                  newDose.forEach((key, value) {
                    value?.sort((a, b) => a.time.compareTo(b.time));
                  });

                  _medicationReminder = _medicationReminder.copyWith(
                    dose: newDose,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 21),
          Observer(
            builder: (_) {
              return _editMedicationReminderStore.loading
                  ? const Align(
                      alignment: Alignment.centerRight,
                      child: CircularProgressIndicator(),
                    )
                  : AnimatedCrossFade(
                      firstChild: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: controlButtons
                            .separator(const SizedBox(height: 12))
                            .toList(),
                      ),
                      secondChild: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: controlButtons
                            .separator(const SizedBox(width: 12))
                            .toList(),
                      ),
                      crossFadeState: context.isMobile
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 402),
                      sizeCurve: Curves.decelerate,
                    );
            },
          ),
        ],
      ),
    );
  }
}
