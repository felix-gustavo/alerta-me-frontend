import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';

import '../../shared/extensions/time_of_day_extension.dart';

const kTileHeight = 128.0;

class MyTimelineTile extends StatefulWidget {
  final List<TimeOfDay> reminders;
  final double? lastConnectorWidthPercent;

  const MyTimelineTile({
    super.key,
    required this.reminders,
    required this.lastConnectorWidthPercent,
  });

  const MyTimelineTile.readonly({
    super.key,
    required this.reminders,
  }) : lastConnectorWidthPercent = null;

  @override
  State<MyTimelineTile> createState() => _MyTimelineTileState();
}

class _MyTimelineTileState extends State<MyTimelineTile> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TimeOfDay> data = widget.reminders;
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 369),
      child: IntrinsicHeight(
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            // padding: const EdgeInsets.only(bottom: 6),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: FixedTimeline.tileBuilder(
                theme: TimelineThemeData(
                  direction: Axis.horizontal,
                  indicatorTheme: IndicatorThemeData(
                    color: colorScheme.primary,
                  ),
                  connectorTheme: ConnectorThemeData(
                    color: colorScheme.primary,
                  ),
                ),
                builder: TimelineTileBuilder.connected(
                  itemExtentBuilder: (_, index) {
                    double value = kTileHeight;
                    if (index == data.length - 2 &&
                        widget.lastConnectorWidthPercent != null) {
                      final minValue =
                          kTileHeight * widget.lastConnectorWidthPercent!;
                      value = minValue < 75 ? 75 : minValue;
                    }
                    return value;
                  },
                  itemCount: data.length,
                  nodePositionBuilder: (_, __) => .69,
                  indicatorBuilder: (_, index) {
                    return index == data.length - 2 &&
                            widget.lastConnectorWidthPercent != null
                        ? OutlinedDotIndicator(
                            size: 12,
                            color: colorScheme.error,
                          )
                        : const DotIndicator(size: 12);
                  },
                  indicatorPositionBuilder: (_, __) => 0,
                  connectorBuilder: (_, __, ___) => const SolidLineConnector(),
                  oppositeContentsBuilder: (context, index) {
                    final penultimate = index == data.length - 2 &&
                        widget.lastConnectorWidthPercent != null;

                    final timeCard = Text(data[index].toHHMM);
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 9,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: penultimate
                                ? colorScheme.error.withOpacity(.6)
                                : colorScheme.outlineVariant.withOpacity(.6),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(9),
                            bottomLeft: Radius.zero,
                            bottomRight: Radius.circular(9),
                            topRight: Radius.circular(9),
                          ),
                        ),
                        child: penultimate
                            ? Tooltip(
                                message:
                                    'A diferença entre este lembrete e o último é menor que o intervalo especificado\nSinta-se livre pra ajustar o horário de início, fim, ou o intervalo entre os lembretes',
                                child: timeCard,
                              )
                            : timeCard,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
