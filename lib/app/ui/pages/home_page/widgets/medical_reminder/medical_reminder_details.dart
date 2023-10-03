import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/medical_reminder.dart';
import '../../../../../shared/extensions/colors_app_extension.dart';
import '../../../../../stores/medical_reminder/delete_medical_reminder/delete_medical_reminder_store.dart';
import '../../../../../stores/medical_reminder/load_medical_reminder/load_medical_reminder_store.dart';
import '../../../../common_components/confirm_dialog.dart';
import '../../../../common_components/expanded_section.dart';
import 'medical_reminder_card.dart';
import 'medical_reminder_edit.dart';

class MedicalReminderDetails extends StatefulWidget {
  final MedicalReminder medicalReminder;

  const MedicalReminderDetails({
    Key? key,
    required this.medicalReminder,
  }) : super(key: key);

  @override
  State<MedicalReminderDetails> createState() => _MedicalReminderDetailsState();
}

class _MedicalReminderDetailsState extends State<MedicalReminderDetails> {
  late final DeleteMedicalReminderStore _deleteMedicalReminderStore;
  late final LoadMedicalReminderStore _loadMedicalReminderStore;
  late final ReactionDisposer _disposer;

  late bool _isExpanded;

  final GlobalKey _medicalReminderCardKey = GlobalKey();
  double? _medicalReminderCardWidth;

  late MedicalReminder _medicalReminderEdit;
  Widget? _medicalReminderEditWidget;

  @override
  void initState() {
    super.initState();
    _isExpanded = false;
    _medicalReminderEdit = widget.medicalReminder.copyWith();

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _medicalReminderCardWidth = getSize(_medicalReminderCardKey)?.width;
      });
    });
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  Size? getSize(GlobalKey key) {
    final context = key.currentState?.context;

    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      return box.size;
    }
    return null;
  }

  Widget _buildPreviewCards({
    required bool overflowed,
    required double? width,
    required double iconSize,
  }) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        AnimatedOpacity(
          opacity: _isExpanded ? 0 : 1,
          duration: const Duration(milliseconds: 501),
          curve: Curves.easeIn,
          child: MedicalReminderCard(
            key: _medicalReminderCardKey,
            medicalReminder: widget.medicalReminder,
            expanded: true,
          ),
        ),
        ExpandedSection(
          axis: overflowed ? Axis.vertical : Axis.horizontal,
          expand: _isExpanded,
          child: _isExpanded
              ? SizedBox(
                  width: width,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    children: [
                      Opacity(
                        opacity: .69,
                        child: MedicalReminderCard(
                          medicalReminder: widget.medicalReminder,
                          expanded: true,
                        ),
                      ),
                      SizedBox(
                        width: iconSize,
                        child: Icon(
                          overflowed
                              ? Icons.keyboard_double_arrow_down
                              : Icons.keyboard_double_arrow_right,
                          color: context.colors.secondary,
                          size: 33,
                        ),
                      ),
                      MedicalReminderCard(
                        medicalReminder: _medicalReminderEdit,
                        isHover: true,
                        expanded: true,
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  Widget _buildEditSection({
    required bool overflowed,
    required double? width,
  }) {
    final medicalEdit = MedicalReminderEditWidget(
        medicalReminder: _medicalReminderEdit,
        isMobile: overflowed,
        onEdit: (medicalReminder) {
          setState(() => _medicalReminderEdit = medicalReminder);
        });

    _medicalReminderEditWidget = _isExpanded
        ? WillPopScope(
            onWillPop: () async {
              final shouldPop = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return ConfirmDialog.pop(
                    onPostivePressed: () async => Navigator.pop(context, true),
                  );
                },
              );
              return shouldPop ?? false;
            },
            child: medicalEdit,
          )
        : medicalEdit;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edição',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color:
                                _isExpanded ? context.colors.primaryDark : null,
                          ),
                    ),
                    _isExpanded
                        ? const Icon(Icons.keyboard_arrow_up)
                        : const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            ExpandedSection(
              expand: _isExpanded,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: context.colors.lightGrey),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: _medicalReminderEditWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _doDelete() async {
    final navigator = Navigator.of(context);

    await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Exclusão de lembrete de consulta',
        content:
            'O lembrete para a consulta com ${_medicalReminderEdit.medicName} será excluído, deseja realmente excluir?',
        negativeBtnText: 'Não',
        positiveBtnText: 'Sim',
        onPostivePressed: () async {
          final id = _medicalReminderEdit.id;
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
    );
  }

  @override
  Widget build(BuildContext context) {
    print('widget.medicalReminder.id: ${widget.medicalReminder.id}');

    return LayoutBuilder(
      builder: (context, constraints) {
        const iconSize = 45.0;
        final widthExpanded = (_medicalReminderCardWidth ?? 0) * 2 + iconSize;
        final overflowed = constraints.maxWidth <= widthExpanded;

        final width = _isExpanded && !overflowed
            ? widthExpanded
            : _medicalReminderCardWidth;

        return IntrinsicWidth(
          child: Column(
            children: [
              Observer(
                builder: (_) {
                  return Stack(
                    alignment: Alignment.topRight,
                    children: [
                      _buildPreviewCards(
                        overflowed: overflowed,
                        iconSize: iconSize,
                        width: width,
                      ),
                      if (!_isExpanded)
                        _deleteMedicalReminderStore.loading
                            ? const Padding(
                                padding: EdgeInsets.all(6),
                                child: SizedBox.square(
                                  dimension: 21,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : IconButton(
                                onPressed: _doDelete,
                                icon: Icon(
                                  Icons.delete,
                                  color: context.colors.error,
                                ),
                                splashRadius: 3,
                                iconSize: 21,
                              ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildEditSection(overflowed: overflowed, width: width),
            ],
          ),
        );
      },
    );
  }
}
