import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

import '../../shared/extensions/colors_app_extension.dart';
import '../../shared/extensions/time_of_day_extension.dart';

class MyTimeRangePicker extends StatefulWidget {
  final TimeOfDay start;
  final TimeOfDay end;
  final double width;
  final bool rangeTextSmall;
  final double padding;
  final bool hideTimes;
  final bool readonly;

  final void Function(TimeOfDay start)? onStartChange;
  final void Function(TimeOfDay end)? onEndChange;

  const MyTimeRangePicker({
    Key? key,
    required this.start,
    required this.end,
    this.width = 271,
    this.rangeTextSmall = false,
    this.padding = 33,
    this.hideTimes = false,
    this.onStartChange,
    this.onEndChange,
    this.readonly = false,
  }) : super(key: key);

  const MyTimeRangePicker.small({
    Key? key,
    required this.start,
    required this.end,
    this.width = 183,
    this.rangeTextSmall = true,
    this.padding = 18,
    this.hideTimes = true,
    this.onStartChange,
    this.onEndChange,
    this.readonly = false,
  }) : super(key: key);

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

    return IgnorePointer(
      ignoring: widget.readonly,
      child: IntrinsicWidth(
        child: Container(
          decoration: !widget.hideTimes
              ? BoxDecoration(
                  border: Border.all(color: context.colors.lightGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                )
              : null,
          child: Column(
            children: [
              if (!widget.hideTimes)
                Container(
                  decoration: BoxDecoration(
                    color: context.colors.primaryLight,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: widget.padding / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Início',
                            style: textTheme.titleMedium!
                                .copyWith(color: context.colors.primary),
                          ),
                          Text(
                            _start.toHHMM,
                            style: textTheme.headlineSmall!
                                .copyWith(color: context.colors.primary),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Fim',
                            style: textTheme.titleMedium!
                                .copyWith(color: context.colors.primary),
                          ),
                          Text(
                            _end.toHHMM,
                            style: textTheme.headlineSmall!
                                .copyWith(color: context.colors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              SizedBox(
                width: widget.width,
                height: widget.width,
                child: TimeRangePicker(
                  padding: widget.padding,
                  hideButtons: true,
                  backgroundWidget: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Ativo por',
                        style: textTheme.bodySmall!
                            .copyWith(color: context.colors.grey),
                      ),
                      Text(
                        _start.interval(_end).toHHMM,
                        style: widget.rangeTextSmall
                            ? textTheme.headlineMedium
                            : textTheme.displaySmall,
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
            ],
          ),
        ),
      ),
    );
  }
}
