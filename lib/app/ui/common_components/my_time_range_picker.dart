import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../../shared/extensions/app_styles_extension.dart';
import '../../shared/extensions/time_of_day_extension.dart';
import 'my_container.dart';

class MyTimeRangePicker extends StatefulWidget {
  final TimeOfDay start;
  final TimeOfDay end;
  final bool readonly;

  final void Function(TimeOfDay start)? onStartChange;
  final void Function(TimeOfDay end)? onEndChange;

  const MyTimeRangePicker({
    super.key,
    required this.start,
    required this.end,
    this.onStartChange,
    this.onEndChange,
  }) : readonly = false;

  const MyTimeRangePicker.readonly({
    super.key,
    required this.start,
    required this.end,
    this.onStartChange,
    this.onEndChange,
  }) : readonly = true;

  @override
  State<MyTimeRangePicker> createState() => _MyTimeRangePickerState();
}

class _MyTimeRangePickerState extends State<MyTimeRangePicker> {
  late TimeOfDay _start;
  late TimeOfDay _end;

  @override
  void initState() {
    super.initState();
    _start = widget.start;
    _end = widget.end;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return IgnorePointer(
      ignoring: widget.readonly,
      child: SizedBox(
        width: context.isTablet ? 222 : 270,
        child: MyContainer(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Início',
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                        Text(_start.toHHMM, style: textTheme.titleLarge),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Fim',
                          style: textTheme.bodyMedium!.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                        Text(_end.toHHMM, style: textTheme.titleLarge),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: TimeRangePicker(
                  paintingStyle: PaintingStyle.stroke,
                  padding: 24,
                  hideButtons: true,
                  strokeWidth: widget.readonly ? 24 : 9,
                  handlerRadius: widget.readonly ? 0 : 9,
                  ticks: 8,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  backgroundWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ativo por',
                        style: textTheme.bodyMedium!.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _start.interval(_end).toHHMM,
                              style: textTheme.headlineSmall!.copyWith(
                                color: colorScheme.primary,
                              ),
                            ),
                            TextSpan(
                              text: 'H',
                              style: textTheme.titleLarge!.copyWith(
                                color: colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  hideTimes: true,
                  start: _start,
                  end: _end,
                  onStartChange: (start) {
                    setState(() => _start = start);
                    widget.onStartChange?.call(start);
                  },
                  onEndChange: (end) {
                    setState(() => _end = end);
                    widget.onEndChange?.call(end);
                  },
                ),
              ),
              // if (widget.readonly) ...[
              //   const Divider(height: 24),
              //   Column(
              //     children: [
              //       Text(
              //         'Ativo por',
              //         style: textTheme.bodyMedium!.copyWith(
              //           color: colorScheme.outline,
              //         ),
              //       ),
              //       const SizedBox(height: 3),
              //       Text.rich(
              //         TextSpan(
              //           children: [
              //             TextSpan(
              //               text: _start.interval(_end).toHHMM,
              //               style: textTheme.headlineSmall!.copyWith(
              //                 color: colorScheme.primary,
              //               ),
              //             ),
              //             TextSpan(
              //               text: 'H',
              //               // style: textTheme.titleLarge!,
              //               style: textTheme.titleLarge!.copyWith(
              //                 color: colorScheme.primary,
              //               ),
              //             )
              //           ],
              //         ),
              //         textAlign: TextAlign.center,
              //       ),
              //       const SizedBox(height: 12),
              //     ],
              //   ),
              // ]
            ],
          ),
        ),
      ),
    );
  }
}
