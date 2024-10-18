import 'package:flutter/material.dart';

import '../../../../../model/water_reminder.dart';
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/iterable_extension.dart';
import '../../../../../shared/extensions/time_of_day_extension.dart';
import '../../../../common_components/my_time_range_picker.dart';
import '../../../../common_components/my_timeline_tile.dart';
import 'card_info.dart';
import 'water_history.dart';

class WaterReminderContent extends StatelessWidget {
  final WaterReminder waterReminder;
  const WaterReminderContent({super.key, required this.waterReminder});

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;

    final startTime = waterReminder.start;
    final endTime = waterReminder.end;
    final range = startTime.interval(endTime);

    final amount = (waterReminder.amount / 1000).toStringAsFixed(2);
    // final total = ((range.convertToMinutes / waterReminder.interval) + 1)
    // .ceil()
    // .toString();

    final toBreak = context.screenWidth < 940;
    final spacingPerc = context.screenWidth * .01;
    final spacing = spacingPerc < 6.0 ? 6.0 : spacingPerc;

    final amountReminders =
        (waterReminder.start.interval(waterReminder.end).convertToMinutes /
                waterReminder.interval) +
            1;

    final children = [
      Card(
        child: Padding(
          padding: EdgeInsets.all(spacing),
          child: LayoutBuilder(
            builder: (context, c) {
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                alignment: WrapAlignment.center,
                // crossAxisAlignment: WrapCrossAlignment.center,
                runAlignment: WrapAlignment.center,
                children: [
                  SizedBox(
                    height: toBreak ? null : c.maxHeight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyTimeRangePicker.readonly(
                          key: ValueKey(range),
                          start: startTime,
                          end: endTime,
                        ),
                        SizedBox(height: spacing),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              waterReminder.active
                                  ? Icons.alarm_on
                                  : Icons.alarm_off_outlined,
                            ),
                            const SizedBox(width: 9),
                            Text(
                              'Lembrete ${waterReminder.active ? 'ativado' : 'desativado'}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: toBreak ? null : c.maxHeight,
                    child: Column(
                      children: [
                        CardInfo(
                          label: 'Água total',
                          value: amount,
                          unit: 'L',
                        ),
                        CardInfo(
                          label: 'Intervalo',
                          value: waterReminder.interval.toString(),
                          unit: 'min',
                        ),
                        // CardInfo(
                        //   label: 'Lembretes',
                        //   value: amountReminders.ceil().toString(),
                        // ),
                        CardInfo(
                          label: 'Sugestão',
                          value: (waterReminder.amount / amountReminders.ceil())
                              .floor()
                              .toString(),
                          unit: 'mL',
                        ),
                        // ],
                      ].separator(SizedBox(height: spacing)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      const SizedBox.square(dimension: 12),
      Flexible(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 6,
                  top: 12,
                  left: 12,
                  right: 12,
                ),
                child: MyTimelineTile.readonly(
                  reminders: waterReminder.reminders,
                ),
              ),
            ),
            const SizedBox.square(dimension: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: WaterHistory(toBreak),
              ),
            ),
          ],
        ),
      ),
    ];

    return toBreak
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          )
        : SizedBox(
            height: 441,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          );
  }
}
