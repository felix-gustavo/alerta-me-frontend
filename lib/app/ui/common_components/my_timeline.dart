import 'package:flutter/material.dart';

import '../../shared/extensions/colors_app_extension.dart';
import '../../shared/extensions/time_of_day_extension.dart';

class MyTimeline extends StatefulWidget {
  final TimeOfDay start;
  final TimeOfDay end;
  final int interval;

  const MyTimeline({
    Key? key,
    required this.start,
    required this.end,
    required this.interval,
  }) : super(key: key);

  @override
  State<MyTimeline> createState() => _MyTimelineState();
}

class _MyTimelineState extends State<MyTimeline> {
  final ScrollController _timelineScollController = ScrollController();

  @override
  void dispose() {
    _timelineScollController.dispose();
    super.dispose();
  }

  Widget _buildConnector(
    BuildContext context, {
    required bool isPenultimate,
    required double lessSpace,
    required double spacing,
  }) {
    return Container(
      width: isPenultimate ? lessSpace : spacing,
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

  Widget _buildTimelineCardInfo(BuildContext context, {required String text}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.secondary),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  List<TimeOfDay> _generateReminders() {
    final List<TimeOfDay> reminders = [];

    final startDate =
        DateTime(1998, 10, 29, widget.start.hour, widget.start.minute);
    DateTime endDate =
        DateTime(1998, 10, 29, widget.end.hour, widget.end.minute);

    if (endDate.isBefore(startDate)) {
      endDate = endDate.add(const Duration(days: 1));
    }

    DateTime currentTime = startDate;

    while (currentTime.isBefore(endDate) ||
        currentTime.isAtSameMomentAs(endDate)) {
      reminders.add(
        TimeOfDay(hour: currentTime.hour, minute: currentTime.minute),
      );
      currentTime = currentTime.add(Duration(minutes: widget.interval));
    }

    return reminders;
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _generateReminders();
    if (reminders.last.convertToMinutes != widget.end.convertToMinutes) {
      reminders.add(widget.end);
    }

    final intervalPer24h = widget.start.interval(widget.end);
    final acc = (intervalPer24h.convertToMinutes / widget.interval) + 1;

    return Scrollbar(
      controller: _timelineScollController,
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
            final lessSpace = spacing * (percent != 0 ? percent : 1);

            const sizeIndicatorDot = 15.0;

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isPenultimate && percent != 0
                        ? _buildTimelineCardInfoEmpty()
                        : _buildTimelineCardInfo(context, text: value.toHHMM),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        isPenultimate && percent != 0
                            ? Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                width: sizeIndicatorDot,
                                height: sizeIndicatorDot,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: context.colors.secondary,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                width: sizeIndicatorDot,
                                height: sizeIndicatorDot,
                                decoration: BoxDecoration(
                                  color: context.colors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                        if (!isLast)
                          _buildConnector(
                            context,
                            isPenultimate: isPenultimate,
                            lessSpace: lessSpace < 36 ? 36 : lessSpace,
                            spacing: spacing,
                          ),
                      ],
                    ),
                  ],
                ),
                isPenultimate && percent != 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Tooltip(
                            message:
                                'O último intervalo entre os lembretes é menor,\npois é levado em consideração o horário de início e fim,\nbem como o intervalo entre os lembretes',
                            child: _buildTimelineCardInfo(
                              context,
                              text: value.toHHMM,
                            ),
                          ),
                        ],
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
