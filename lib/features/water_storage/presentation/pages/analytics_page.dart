import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_cubit.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_state.dart';
import 'package:motor_main/features/water_storage/presentation/widgets/water_history_chart_widget.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.cloud_outlined, color: colorScheme.primary),
        title: Text(
          'Liquid Precision',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Alerts',
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<WaterStorageCubit, WaterStorageState>(
          builder: (context, storageState) {
            return storageState.maybeWhen(
              loaded: (storage, fillTimeMinutes) {
                final maxVolume = storage.capacityLiters.toInt();
                var refillTotal = 0;
                for (var index = 1; index < storage.history.length; index++) {
                  final prev = storage.history[index - 1].levelPercentage;
                  final curr = storage.history[index].levelPercentage;
                  final delta = curr - prev;
                  if (delta > 0) {
                    refillTotal += ((delta / 100) * storage.capacityLiters)
                        .round();
                  }
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    Text(
                      'Water Usage History',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Gap(4),
                    Text(
                      'ANALYTICS OVERVIEW',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                    ),
                    const Gap(14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WEEKLY RANGE',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    letterSpacing: 0.9,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  'Mon - Sun',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'PEAK VOLUME',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    letterSpacing: 0.9,
                                  ),
                                ),
                                const Gap(4),
                                Text(
                                  '${maxVolume}L',
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(14),
                    WaterHistoryChartWidget(history: storage.history),
                    const Gap(14),
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.opacity,
                            color: colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.calendar_month,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ],
                    ),
                    const Gap(14),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL WEEKLY REFILL',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 1,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            '${refillTotal}L',
                            style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              orElse: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
