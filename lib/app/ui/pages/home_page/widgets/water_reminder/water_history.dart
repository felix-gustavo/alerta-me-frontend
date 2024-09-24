import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../../../model/water_history.dart' as model;
import '../../../../../shared/extensions/app_styles_extension.dart';
import '../../../../../shared/extensions/datetime_extension.dart';
import '../../../../../stores/water_history/load_older_date_history/load_older_date_history_store.dart';
import '../../../../../stores/water_history/load_water_history/load_water_history_store.dart';
import '../../../../common_components/legend_widget.dart';

class WaterHistory extends StatefulWidget {
  final bool toBreak;
  const WaterHistory(this.toBreak, {super.key});

  @override
  State<WaterHistory> createState() => _WaterHistoryState();
}

class _WaterHistoryState extends State<WaterHistory> {
  late final LoadWaterHistoryStore _loadWaterHistoryStore;
  late final LoadOlderDateHistoryStore _loadOlderDateHistoryStore;
  late DateTime _selectedDate;
  late final ReactionDisposer _disposer;
  late final amountColor = Theme.of(context).colorScheme.primary;
  late final suggestedColor = Theme.of(context).colorScheme.secondary;

  @override
  void initState() {
    super.initState();
    _loadWaterHistoryStore = Provider.of<LoadWaterHistoryStore>(
      context,
      listen: false,
    );
    _loadOlderDateHistoryStore = Provider.of<LoadOlderDateHistoryStore>(
      context,
      listen: false,
    );

    _selectedDate = DateTime.now();

    _disposer = autorun(
      (_) async {
        await Future.wait([
          _loadWaterHistoryStore.run(date: _selectedDate),
          _loadOlderDateHistoryStore.run(),
        ]);

        final waterHistory = _loadWaterHistoryStore.waterHistory;
        if (waterHistory.isNotEmpty) _selectedDate = waterHistory.last.datetime;
      },
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  Widget _buildLineChart(List<model.WaterHistory> waterHistory) {
    List<int> showingTooltipOnSpots =
        List.generate(waterHistory.length, (index) => index);

    final lineBarData = LineChartBarData(
      showingIndicators: showingTooltipOnSpots,
      spots: _amountHistoryToFlSpots(waterHistory),
      color: amountColor,
    );

    final lineBarDataSuggested = LineChartBarData(
      showingIndicators: showingTooltipOnSpots,
      spots: _suggestedAmountToFlSpots(waterHistory),
      color: suggestedColor,
    );

    final maxY = waterHistory
            .reduce(
              (a, b) => a.suggestedAmount > b.suggestedAmount ? a : b,
            )
            .suggestedAmount
            .toDouble() *
        1.2;

    final first = waterHistory.first.datetime.millisecondsSinceEpoch.toDouble();
    final last = waterHistory.last.datetime.millisecondsSinceEpoch.toDouble();

    final duration = last - first;
    final intervalTimes = duration / 3;

    return Padding(
      padding: const EdgeInsets.only(right: 18),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(
            drawVerticalLine: false,
            drawHorizontalLine: true,
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          minY: 0,
          maxY: maxY,
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles()),
            rightTitles: const AxisTitles(sideTitles: SideTitles()),
            leftTitles: AxisTitles(
              // axisNameWidget: const Text('mL'),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 63,
                getTitlesWidget: (value, meta) {
                  if (meta.axisPosition == 0) return SizedBox.fromSize();
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                    child: Text(
                      '${value.toString()} mL',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              drawBelowEverything: false,
              sideTitles: SideTitles(
                showTitles: true,
                interval: waterHistory.length > 1 ? intervalTimes : null,
                getTitlesWidget: (value, meta) {
                  // if (meta.axisPosition == 0) return SizedBox.fromSize();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      DateTime.fromMillisecondsSinceEpoch(value.toInt()).toTime,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            // handleBuiltInTouches: false,
            touchSpotThreshold: 21,
            // getTouchedSpotIndicator: (barData, spotIndexes) => spotIndexes.map(
            //   (spotIndex) {
            //     return const TouchedSpotIndicatorData(
            //       FlLine(color: Colors.transparent),
            //       FlDotData(),
            //     );
            //   },
            // ).toList(),
            touchTooltipData: LineTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipHorizontalAlignment: FLHorizontalAlignment.right,
              tooltipRoundedRadius: 6,
              // tooltipBorder: BorderSide(color: context.colors.primary),
              getTooltipColor: (_) =>
                  Theme.of(context).colorScheme.primaryContainer,
              tooltipMargin: 12,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 9,
                vertical: 3,
              ),
              getTooltipItems: (touchedSpots) {
                return [
                  ...touchedSpots.map(
                    (barSpot) {
                      final flSpot = barSpot;
                      if (flSpot.x == 0) return null;

                      return LineTooltipItem(
                        '${flSpot.y.toString()} mL',
                        TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      );
                    },
                  )
                ];
              },
            ),
          ),
          showingTooltipIndicators: [
            ...showingTooltipOnSpots.map((index) {
              return ShowingTooltipIndicators([
                LineBarSpot(
                  lineBarData,
                  0,
                  lineBarData.spots[index],
                ),
              ]);
            })
          ],
          lineBarsData: [
            // LineChartBarData(
            //   spots: _suggestedAmountToFlSpots(waterHistory),
            //   color: context.colors.primary,
            //   belowBarData: BarAreaData(
            //     show: false,
            //     // gradient: LinearGradient(
            //     //   begin: Alignment.topCenter,
            //     //   end: Alignment.bottomCenter,
            //     //   colors: [
            //     //     context.colors.primaryLight.withOpacity(.33),
            //     //     context.colors.primaryLight,
            //     //   ],
            //     // ),
            //   ),
            // ),
            lineBarData,
            lineBarDataSuggested,
          ],
        ),
      ),
    );
  }

  List<FlSpot> _amountHistoryToFlSpots(List<model.WaterHistory> waterHistory) {
    return waterHistory
        .map(
          (e) => FlSpot(
            e.datetime.millisecondsSinceEpoch.toDouble(),
            e.amount?.toDouble() ?? 0,
          ),
        )
        .toList();
  }

  List<BarChartGroupData> _amountHistoryToBarChartGroupData(
    List<model.WaterHistory> waterHistory,
  ) {
    return waterHistory.map(
      (e) {
        final amount = e.amount?.toDouble() ?? 0.0;
        final suggested = e.suggestedAmount.toDouble();

        return BarChartGroupData(
          x: e.datetime.millisecondsSinceEpoch,
          barRods: [
            BarChartRodData(
              toY: amount,
              color: amountColor,
              width: 5,
            ),
            BarChartRodData(
              toY: suggested,
              color: suggestedColor,
              width: 5,
            ),
          ],
          // showingTooltipIndicators: [0],
          // groupVertically: true,
        );
      },
    ).toList();
  }

  List<FlSpot> _suggestedAmountToFlSpots(
      List<model.WaterHistory> waterHistory) {
    return waterHistory
        .map(
          (e) => FlSpot(
            e.datetime.millisecondsSinceEpoch.toDouble(),
            e.suggestedAmount.toDouble(),
          ),
        )
        .toList();
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      _loadOlderDateHistoryStore.run(),
      _loadWaterHistoryStore.run(
        date: _selectedDate,
        force: true,
      ),
    ]);
  }

  // Widget _buildBarChart(List<model.WaterHistory> waterHistory) {
  //   return BarChart(
  //     BarChartData(
  //       barGroups: _amountHistoryToBarChartGroupData(waterHistory),
  //       borderData: FlBorderData(show: false),
  //       barTouchData: BarTouchData(enabled: false),
  //       titlesData: FlTitlesData(
  //         leftTitles: const AxisTitles(),
  //         topTitles: const AxisTitles(),
  //         rightTitles: const AxisTitles(),
  //         bottomTitles: AxisTitles(
  //           sideTitles: SideTitles(
  //             showTitles: true,
  //             getTitlesWidget: (value, meta) => Text(
  //               DateTime.fromMillisecondsSinceEpoch(value.toInt()).toTime,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double aspectRatio = 21 / 9;
    final double screenWidth = context.screenWidth;

    switch (screenWidth) {
      case > 1600:
        aspectRatio = 51 / 9;
        break;
      case > 1360:
        aspectRatio = 42 / 9;
        break;
      case > 1200:
        aspectRatio = 33 / 9;
        break;
      case > 1000:
        aspectRatio = 29 / 9;
        break;
    }

    return Observer(
      builder: (_) {
        final waterHistory = _loadWaterHistoryStore.waterHistory;
        final firstDate = _loadOlderDateHistoryStore.date;

        // DEFINIR ALTURA NA ROW MAIS EXTERNA POSSÍVEL, DE MODO QUE ESSE WIDGET SE AJUSTE AO MÁXIMO DE TAMANHO DISPONÍVEL
        return SizedBox(
          height: widget.toBreak ? null : 285,
          child: Visibility(
            visible: _loadWaterHistoryStore.loading,
            replacement: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Histórico',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Visibility(
                      visible: _loadOlderDateHistoryStore.loading,
                      replacement: (firstDate != null)
                          ? TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              onPressed: () async {
                                final newDate = await showDatePicker(
                                  context: context,
                                  firstDate: firstDate,
                                  lastDate: DateTime.now(),
                                  currentDate: _selectedDate,
                                );

                                if (newDate != null) {
                                  await _loadWaterHistoryStore.run(
                                    date: newDate,
                                    force: true,
                                  );
                                  setState(() => _selectedDate = newDate);
                                }
                              },
                              child: Text(_selectedDate.toDateBRL),
                            )
                          : const SizedBox.shrink(),
                      child: const CircularProgressIndicator(),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: _onRefresh,
                          // label: const Text('ATUALIZAR'),
                          tooltip: 'Atualizar',
                          icon: const Icon(Icons.refresh),
                        ),
                        IconButton(
                          onPressed: () {},
                          // label: const Text('EXPORTAR'),
                          tooltip: 'Baixar dados',
                          icon: const Icon(Icons.download),
                        ),
                      ],
                    ),
                  ],
                ),
                if (!widget.toBreak) const Spacer(),
                if (waterHistory.isNotEmpty) ...[
                  LegendsListWidget(
                    legends: [
                      Legend('Dose ingerida', amountColor),
                      Legend('Sugestão', suggestedColor),
                    ],
                  ),
                  AspectRatio(
                    aspectRatio: aspectRatio,
                    child: _buildLineChart(waterHistory),
                  )
                ] else ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.show_chart_rounded,
                        size: context.isMobile ? 45 : 72,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      Text(
                        'Sem dados',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ],
                if (!widget.toBreak) const Spacer(flex: 2),
              ],
            ),
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
