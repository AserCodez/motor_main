import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';

class WaterHistoryChartWidget extends StatelessWidget {
  const WaterHistoryChartWidget({super.key, required this.history});

  final List<DailyWaterLevelPoint> history;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sortedHistory = [...history]
      ..sort((a, b) => a.date.compareTo(b.date));
    final sevenDayHistory = sortedHistory.length <= 7
        ? sortedHistory
        : sortedHistory.sublist(sortedHistory.length - 7);

    return Semantics(
      label: 'Seven day water level analytics chart',
      readOnly: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '7-Day Water History',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Gap(4),
              Text(
                'Level percentage trend from telemetry snapshots',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Gap(20),
              SizedBox(
                height: 250,
                child: sevenDayHistory.isEmpty
                    ? Center(
                        child: Text(
                          'No history available yet.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 100,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 25,
                            getDrawingHorizontalLine: (_) => FlLine(
                              color: colorScheme.outlineVariant.withAlpha(120),
                              strokeWidth: 1,
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 42,
                                interval: 25,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}%',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 ||
                                      index >= sevenDayHistory.length) {
                                    return const SizedBox.shrink();
                                  }

                                  final dayLabel = DateFormat.E().format(
                                    sevenDayHistory[index].date,
                                  );
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      dayLabel,
                                      style: textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List<FlSpot>.generate(
                                sevenDayHistory.length,
                                (index) => FlSpot(
                                  index.toDouble(),
                                  sevenDayHistory[index].levelPercentage,
                                ),
                              ),
                              isCurved: true,
                              barWidth: 3,
                              color: colorScheme.primary,
                              belowBarData: BarAreaData(
                                show: true,
                                color: colorScheme.primary.withAlpha(35),
                              ),
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, bar, index) {
                                  return FlDotCirclePainter(
                                    radius: 4,
                                    color: colorScheme.primary,
                                    strokeColor: colorScheme.surface,
                                    strokeWidth: 2,
                                  );
                                },
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: true,
                            touchTooltipData: LineTouchTooltipData(
                              fitInsideHorizontally: true,
                              fitInsideVertically: true,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  final levelValue = spot.y.round();
                                  return LineTooltipItem(
                                    '$levelValue%',
                                    textTheme.titleSmall?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.w700,
                                        ) ??
                                        TextStyle(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
