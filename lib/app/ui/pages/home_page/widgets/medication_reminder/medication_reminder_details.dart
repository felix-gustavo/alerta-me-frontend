import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/medication_reminder.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../../stores/medication_reminder/delete_medication_reminder/delete_medication_reminder_store.dart';
import '../../../../../stores/medication_reminder/load_medication_reminder/load_medication_reminder_store.dart';
import '../../../../common_components/confirm_dialog.dart';
import '../../../../common_components/my_dialog.dart';
import 'medication_reminder_edit.dart';

class MedicationReminderDetails extends StatefulWidget {
  final MedicationReminder _medReminder;

  const MedicationReminderDetails({
    Key? key,
    required MedicationReminder medicationReminder,
  })  : _medReminder = medicationReminder,
        super(key: key);

  @override
  State<MedicationReminderDetails> createState() =>
      _MedicationReminderDetailsState();
}

class _MedicationReminderDetailsState extends State<MedicationReminderDetails> {
  late final DeleteMedicationReminderStore _deleteMedicationReminderStore;
  late final LoadMedicationReminderStore _loadMedicationReminderStore;

  final GlobalKey _rowDosageKey = GlobalKey();
  double? _maxWidth;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _maxWidth = getSize(_rowDosageKey)?.width;
      });
    });
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  Widget _buildContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: context.colors.lightGrey),
      ),
      clipBehavior: Clip.hardEdge,
      child: child,
    );
  }

  Widget _buildCardDosage(Dosage dosage) {
    final textTheme = Theme.of(context).textTheme;

    return _buildContainer(
      child: SizedBox(
        width: 96,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                dosage.time.toHHMM,
                style: textTheme.bodyMedium!.copyWith(
                  color: context.colors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                '${dosage.amount} ${widget._medReminder.dosageUnit}',
                style: textTheme.bodyMedium!.copyWith(
                  color: context.colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    final textTheme = Theme.of(context).textTheme;

    return _buildContainer(
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child:
                  Text(widget._medReminder.name, style: textTheme.titleMedium),
            ),
            const Divider(),
            IntrinsicHeight(
              child: Row(
                key: _rowDosageKey,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...widget._medReminder.dose.entries.map(
                    (entry) => Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Text(
                                  entry.key.namePtBrShort,
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: entry.value?.isNotEmpty ?? false
                                        ? context.colors.primary
                                        : context.colors.lightGrey,
                                  ),
                                ),
                              ),
                              ...entry.value
                                      ?.map((d) => _buildCardDosage(d))
                                      .separator(const SizedBox(height: 12))
                                      .toList() ??
                                  [
                                    Text(
                                      '-',
                                      style: textTheme.bodyMedium!.copyWith(
                                        color: context.colors.lightGrey,
                                      ),
                                    )
                                  ],
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                        if (entry.key.index !=
                            widget._medReminder.dose.length - 1)
                          VerticalDivider(
                            color: context.colors.lightGrey.withOpacity(.33),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget._medReminder.comments != null &&
                widget._medReminder.comments!.isNotEmpty) ...[
              const Divider(),
              SizedBox(
                width: _maxWidth,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comentários',
                        style: textTheme.bodyMedium!
                            .copyWith(color: context.colors.grey),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        widget._medReminder.comments!,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardMobile() {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget._medReminder.name, style: textTheme.bodyLarge),
          Text(
            'Horários e dosagens',
            style: textTheme.bodyMedium!.copyWith(color: context.colors.grey),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widget._medReminder.dose.entries
                .map((entry) {
                  final hasDosages = entry.value != null;

                  return _buildContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: hasDosages
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  entry.key.namePtBr,
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: context.colors.primary,
                                  ),
                                ),
                                const SizedBox(height: 9),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(6),
                                  child: Row(
                                    children: entry.value!
                                        .map((d) => _buildCardDosage(d))
                                        .separator(const SizedBox(width: 6))
                                        .toList(),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key.namePtBr,
                                  style: textTheme.bodyMedium!.copyWith(
                                    color: context.colors.lightGrey,
                                  ),
                                ),
                                Text(
                                  'Sem registro',
                                  style: textTheme.bodySmall!.copyWith(
                                    color: context.colors.lightGrey,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                })
                .separator(const SizedBox(height: 6))
                .toList(),
          ),
          if (widget._medReminder.comments != null &&
              widget._medReminder.comments!.isNotEmpty) ...[
            Text(
              'Comentários',
              style: textTheme.bodyMedium!.copyWith(color: context.colors.grey),
            ),
            Text(
              widget._medReminder.comments!,
              style: textTheme.bodyMedium!.copyWith(
                color: context.colors.grey,
              ),
              textAlign: TextAlign.justify,
            ),
          ]
        ].separator(const SizedBox(height: 12)).toList(),
      ),
    );
  }

  Size? getSize(GlobalKey key) {
    final context = key.currentContext;

    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      return box.size;
    }
    return null;
  }

  void _doDelete() async {
    final navigator = Navigator.of(context);

    await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Exclusão de lembrete de medicamento',
        content:
            'O lembrete para o medicamento ${widget._medReminder.name} será excluído, deseja realmente excluir?',
        negativeBtnText: 'Não',
        positiveBtnText: 'Sim',
        onPostivePressed: () async {
          final id = widget._medReminder.id;
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
          width: 549,
          child: MedicationReminderEditWidget(
            medicationReminder: widget._medReminder,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final overflowed = (_maxWidth ?? 0) + 3 > constraints.maxWidth;
        final textTheme = Theme.of(context).textTheme;

        return Observer(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                overflowed ? _buildCardMobile() : _buildCard(),
                const SizedBox(height: 12),
                _deleteMedicationReminderStore.loading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: _doDelete,
                            child: Text(
                              'Excluir',
                              style: textTheme.bodyMedium!.copyWith(
                                color: context.colors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: _goEditPage,
                            child: Text(
                              'Editar',
                              style: textTheme.bodyMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      )
              ],
            );
          },
        );
      },
    );
  }
}
