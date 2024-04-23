import 'package:flutter/material.dart';

import '../../shared/extensions/colors_app_extension.dart';
import '../../shared/extensions/datetime_extension.dart';
import '../../shared/extensions/time_of_day_extension.dart';

class MyTimeline extends StatefulWidget {
  final TimeOfDay start;
  final TimeOfDay end;
  final int interval;
  final void Function(List<TimeOfDay> reminders)? onGeneratedReminders;

  const MyTimeline({
    Key? key,
    required this.start,
    required this.end,
    required this.interval,
    this.onGeneratedReminders,
  }) : super(key: key);

  @override
  State<MyTimeline> createState() => _MyTimelineState();
}

class _MyTimelineState extends State<MyTimeline> {
  final ScrollController _timelineScollController = ScrollController();
  // late final List<TimeOfDay> reminders = _generateReminders();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   widget.onGeneratedReminders?.call(reminders);
    // });
  }

  @override
  void dispose() {
    _timelineScollController.dispose();
    super.dispose();
  }

  // List<TimeOfDay> _generateReminders({
  //   required TimeOfDay start,
  //   required TimeOfDay end,
  //   required int interval,
  // }) {
  //   final List<TimeOfDay> reminders = [];

  //   final startDate = DateTime(1998, 10, 29, start.hour, start.minute);
  //   DateTime endDate = DateTime(1998, 10, 29, end.hour, end.minute);

  //   DateTime temp = startDate;

  //   while (temp.isBefore(endDate) || temp.isAtSameMomentAs(endDate)) {
  //     reminders.add(
  //       TimeOfDay(hour: temp.hour, minute: temp.minute),
  //     );
  //     temp = temp.add(Duration(minutes: interval));
  //   }

  //   return reminders;
  // }

  Widget _buildConnector({required double spacing}) {
    return Container(
      width: spacing,
      height: 2,
      color: context.colors.secondary,
    );
  }

  Widget _buildTimelineCardInfoEmpty() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
      padding: const EdgeInsets.all(6),
      child: const Text(''),
    );
  }

  Widget _buildTimelineCardInfo({
    required String text,
    required Color borderColor,
    required Color textColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style:
            Theme.of(context).textTheme.bodyLarge!.copyWith(color: textColor),
      ),
    );
  }

  List<TimeOfDay> _generateTimesReminders() {
    final List<TimeOfDay> times = [];

    final start = widget.start;
    final end = widget.end;

    final startTime = TimeOfDay(hour: start.hour, minute: start.minute);
    final endTime = TimeOfDay(hour: end.hour, minute: end.minute);

    final now = DateTime.now();
    final DateTime startDate = now.updateTime(startTime);
    DateTime endDate = now.updateTime(endTime);

    DateTime temp = startDate;

    if (startTime.compareTo(endTime) == 1) {
      endDate = endDate.add(const Duration(days: 1));
    }

    while (temp.isBefore(endDate) || temp.isAtSameMomentAs(endDate)) {
      times.add(temp.toTimeOfDay);
      temp = temp.add(Duration(minutes: widget.interval));
    }

    if (times.last.convertToMinutes != end.convertToMinutes) times.add(end);

    widget.onGeneratedReminders?.call(times);
    return times;
  }

  @override
  Widget build(BuildContext context) {
    print('build timeline');
    final reminders = _generateTimesReminders();

    final intervalPer24h = widget.start.interval(widget.end);
    final acc = (intervalPer24h.convertToMinutes / widget.interval) + 1;

    return Scrollbar(
      controller: _timelineScollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _timelineScollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 21),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: reminders.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;

            final isLast = index == reminders.length - 1;
            final isPenultimate = index == reminders.length - 2;

            const double spacing = 100;
            final percent = acc - acc.truncate();
            final lowSpace = spacing * (percent != 0 ? percent : 1);
            final isPenultimateAndNotDivisible = isPenultimate && percent != 0;

            const sizeIndicatorDot = 12.0;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isPenultimateAndNotDivisible
                    ? _buildTimelineCardInfoEmpty()
                    : _buildTimelineCardInfo(
                        text: value.toHHMM,
                        borderColor: context.colors.secondary,
                        textColor: context.colors.secondaryDark,
                      ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      width: sizeIndicatorDot,
                      height: sizeIndicatorDot,
                      decoration: isPenultimateAndNotDivisible
                          ? BoxDecoration(
                              border: Border.all(color: context.colors.error),
                              shape: BoxShape.circle,
                            )
                          : BoxDecoration(
                              color: context.colors.secondary,
                              shape: BoxShape.circle,
                            ),
                    ),
                    if (!isLast)
                      _buildConnector(
                        spacing: isPenultimate
                            ? (lowSpace < 39 ? 39 : lowSpace)
                            : spacing,
                      ),
                  ],
                ),
                isPenultimateAndNotDivisible
                    ? Tooltip(
                        message:
                            'A diferença entre este lembrete e o último é menor que o intervalo especificado\nSinta-se livre pra ajustar o horário de início, fim, ou o intervalo entre os lembretes',
                        child: _buildTimelineCardInfo(
                          text: value.toHHMM,
                          textColor: context.colors.error,
                          borderColor: context.colors.error,
                        ),
                      )
                    : _buildTimelineCardInfoEmpty(),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
