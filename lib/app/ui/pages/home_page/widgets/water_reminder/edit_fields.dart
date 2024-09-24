import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../model/water_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../common_components/my_time_range_picker.dart';
import 'card_info.dart';

const kMinRange = 5;
const kMaxRange = 120;

class EditFields extends StatefulWidget {
  final WaterReminder waterReminder;
  final void Function(WaterReminder waterReminder) onChange;
  final GlobalKey<FormState> formKey;

  const EditFields({
    super.key,
    required this.waterReminder,
    required this.onChange,
    required this.formKey,
  });

  @override
  State<EditFields> createState() => _EditFieldsState();
}

class _EditFieldsState extends State<EditFields> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final amountReminders = (widget.waterReminder.start
                .interval(widget.waterReminder.end)
                .convertToMinutes /
            widget.waterReminder.interval) +
        1;

    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: [
        MyTimeRangePicker(
          start: widget.waterReminder.start,
          end: widget.waterReminder.end,
          onStartChange: (start) {
            widget.onChange(
              widget.waterReminder.copyWith(start: start),
            );
          },
          onEndChange: (end) {
            widget.onChange(
              widget.waterReminder.copyWith(end: end),
            );
          },
        ),
        Column(
          children: [
            // Wrap(
            //   spacing: 12,
            //   runSpacing: 12,
            //   children: [
            //     Column(
            //       children: [
            //         const Text(
            //           'Lembretes',
            //           // style: textTheme.bodyMedium!.copyWith(
            //           //   color: context.colors.grey,
            //           // ),
            //         ),
            //         Text(
            //           amountReminders.ceil().toString(),
            //           // style: textTheme.displaySmall!
            //           //     .copyWith(color: context.colors.grey),
            //           textAlign: TextAlign.center,
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         const Text(
            //           'Dose sugerida',
            //           // style: textTheme.bodyMedium!.copyWith(
            //           //   color: context.colors.grey,
            //           // ),
            //         ),
            //         Text.rich(
            //           TextSpan(
            //             children: [
            //               TextSpan(
            //                 text: (widget.waterReminder.amount /
            //                         amountReminders.ceil())
            //                     .floor()
            //                     .toString(),
            //                 // style: textTheme.displaySmall!
            //                 //     .copyWith(color: context.colors.grey),
            //               ),
            //               const TextSpan(
            //                 text: 'mL',
            //                 // style: textTheme.labelLarge!.copyWith(
            //                 //   color: context.colors.grey,
            //                 // ),
            //               )
            //             ],
            //           ),
            //           textAlign: TextAlign.center,
            //         ),
            //       ],
            //     ),
            //   ]
            //       .map(
            //         (e) => SizedBox(
            //           width: 171,
            //           child: Card(
            //             child: Padding(
            //               padding: const EdgeInsets.all(12),
            //               child: e,
            //             ),
            //           ),
            //         ),
            //       )
            //       .toList(),
            // ),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CardInfo(
                  label: 'Lembretes',
                  value: amountReminders.ceil().toString(),
                ),
                CardInfo(
                  label: 'Dose sugerida',
                  value: (widget.waterReminder.amount / amountReminders.ceil())
                      .floor()
                      .toString(),
                  unit: 'mL',
                ),
              ],
            ),
            const SizedBox(height: 18),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 281,
                  child: Column(
                    children: [
                      const Text(
                        'Intervalo entre lembretes',
                        // style: textTheme.bodyMedium!.copyWith(
                        //   color: context.colors.grey,
                        // ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // IconButton(
                          //   icon: const Icon(Icons.remove_circle),
                          //   // color: context.colors.primary,
                          //   splashRadius: 21,
                          //   iconSize: 24,
                          //   onPressed: widget.waterReminder.interval >
                          //           kMinRange
                          //       ? () {
                          //           widget.onChange(
                          //             widget.waterReminder.copyWith(
                          //               interval:
                          //                   widget.waterReminder.interval -
                          //                       kMinRange,
                          //             ),
                          //           );
                          //         }
                          //       : null,
                          // ),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      widget.waterReminder.interval.toString(),
                                  style: textTheme.displaySmall,
                                ),
                                TextSpan(
                                  text: 'min',
                                  style: textTheme.labelLarge,
                                ),
                              ],
                            ),
                          ),
                          // IconButton(
                          //   icon: const Icon(Icons.add_circle),
                          //   // color: context.colors.primary,
                          //   splashRadius: 21,
                          //   iconSize: 24,
                          //   onPressed:
                          //       widget.waterReminder.interval < kMaxRange
                          //           ? () {
                          //               final newInterval =
                          //                   widget.waterReminder.interval +
                          //                       kMinRange;
                          //               widget.onChange(
                          //                 widget.waterReminder.copyWith(
                          //                   interval: newInterval,
                          //                 ),
                          //               );
                          //             }
                          //           : null,
                          // ),
                        ],
                      ),
                      Slider(
                        min: kMinRange.toDouble(),
                        max: kMaxRange.toDouble(),
                        value: widget.waterReminder.interval.toDouble(),
                        onChanged: (value) {
                          widget.onChange(
                            widget.waterReminder.copyWith(
                              interval: value.toInt(),
                            ),
                          );
                        },
                        divisions: (kMaxRange - kMinRange) ~/ kMinRange,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: context.isMobile ? null : 81,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total (mL)', style: textTheme.labelMedium),
                      const SizedBox(height: 6),
                      Form(
                        key: widget.formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            helperText: '',
                            contentPadding: EdgeInsets.zero,
                            prefixIconConstraints: BoxConstraints.tight(
                              const Size(12, 0),
                            ),
                            prefixIcon: const SizedBox.shrink(),
                          ),
                          initialValue: widget.waterReminder.amount.toString(),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5)
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Obrigatório';
                            }
                            if (value == '0') {
                              return 'Precisa ser maior que 0';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              widget.onChange(
                                widget.waterReminder.copyWith(
                                  amount: int.parse(value),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
