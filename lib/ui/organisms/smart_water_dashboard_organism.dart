import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_cubit.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_state.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_cubit.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_state.dart';
import 'package:motor_main/ui/atoms/pump_power_button_atom.dart';
import 'package:motor_main/ui/atoms/shimmer_block_atom.dart';
import 'package:motor_main/ui/atoms/water_level_gauge_atom.dart';
import 'package:motor_main/ui/molecules/analytics_card_molecule.dart';
import 'package:motor_main/ui/molecules/status_metric_card_molecule.dart';

class SmartWaterDashboardOrganism extends StatelessWidget {
  const SmartWaterDashboardOrganism({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WaterPumpCubit, WaterPumpState>(
      listenWhen: (previous, next) {
        return next.maybeWhen(
          error: (message, fallbackPump) => true,
          orElse: () => false,
        );
      },
      listener: (context, state) {
        state.whenOrNull(
          error: (message, fallbackPump) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Water Storage & Pump'),
          actions: [
            IconButton(
              onPressed: () => context.read<WaterStorageCubit>().refresh(),
              tooltip: 'Refresh telemetry',
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<WaterStorageCubit, WaterStorageState>(
            builder: (context, storageState) {
              final content = storageState.when(
                initial: () =>
                    const _DashboardLoading(key: ValueKey('dashboard_initial')),
                loading: () =>
                    const _DashboardLoading(key: ValueKey('dashboard_loading')),
                loaded: (storage, fillTimeMinutes) {
                  return _DashboardContent(
                    key: const ValueKey('dashboard_loaded'),
                    storage: storage,
                    fillTimeMinutes: fillTimeMinutes,
                  );
                },
                error: (message, lastKnownStorage) {
                  if (lastKnownStorage != null) {
                    return _DashboardContent(
                      key: const ValueKey('dashboard_stale'),
                      storage: lastKnownStorage,
                      fillTimeMinutes: double.infinity,
                      warningMessage: message,
                    );
                  }

                  return _DashboardError(
                    key: const ValueKey('dashboard_error'),
                    message: message,
                  );
                },
              );

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: content,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    super.key,
    required this.storage,
    required this.fillTimeMinutes,
    this.warningMessage,
  });

  final WaterStorageResponseModel storage;
  final double fillTimeMinutes;
  final String? warningMessage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterPumpCubit, WaterPumpState>(
      builder: (context, pumpState) {
        final pump = pumpState.maybeWhen(
          loaded: (pump, _) => pump,
          error: (_, fallbackPump) => fallbackPump,
          orElse: WaterPumpResponseModel.initial,
        );

        final isPumpBusy = pumpState.maybeWhen(
          loading: () => true,
          loaded: (_, isOptimisticUpdate) => isOptimisticUpdate,
          orElse: () => false,
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            final isLargeScreen = constraints.maxWidth >= 900;

            final gaugePanel = _GaugePanel(
              storage: storage,
              fillTimeMinutes: fillTimeMinutes,
              pump: pump,
              isPumpBusy: isPumpBusy,
            );

            final detailsPanel = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatusCards(
                  storage: storage,
                  pump: pump,
                  fillTimeMinutes: fillTimeMinutes,
                  isLargeScreen: isLargeScreen,
                ),
                const Gap(16),
                AnalyticsCardMolecule(history: storage.history),
              ],
            );

            final contentBody = isLargeScreen
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(flex: 5, child: gaugePanel),
                      const Gap(20),
                      Flexible(flex: 7, child: detailsPanel),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [gaugePanel, const Gap(16), detailsPanel],
                  );

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1220),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (warningMessage != null) ...[
                        _WarningBanner(message: warningMessage!),
                        const Gap(16),
                      ],
                      contentBody,
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _GaugePanel extends StatelessWidget {
  const _GaugePanel({
    required this.storage,
    required this.fillTimeMinutes,
    required this.pump,
    required this.isPumpBusy,
  });

  final WaterStorageResponseModel storage;
  final double fillTimeMinutes;
  final WaterPumpResponseModel pump;
  final bool isPumpBusy;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: WaterLevelGaugeAtom(
                currentLiters: storage.currentLiters,
                capacityLiters: storage.capacityLiters,
              ),
            ),
            const Gap(16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.water_drop),
                  label: Text(
                    '${storage.levelPercentage.toStringAsFixed(1)}% full',
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.schedule),
                  label: Text('Fill time: ${_formatFillTime(fillTimeMinutes)}'),
                ),
              ],
            ),
            const Gap(16),
            PumpPowerButtonAtom(
              isOn: pump.isOn,
              isBusy: isPumpBusy,
              onToggle: () {
                context.read<WaterPumpCubit>().togglePump();
              },
            ),
            if (storage.levelPercentage >= 100) ...[
              const Gap(10),
              Text(
                'Auto-switch safeguard is active. Pump will stay OFF at 100%.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusCards extends StatelessWidget {
  const _StatusCards({
    required this.storage,
    required this.pump,
    required this.fillTimeMinutes,
    required this.isLargeScreen,
  });

  final WaterStorageResponseModel storage;
  final WaterPumpResponseModel pump;
  final double fillTimeMinutes;
  final bool isLargeScreen;

  @override
  Widget build(BuildContext context) {
    final cards = [
      StatusMetricCardMolecule(
        title: 'Pump',
        value: pump.isOn ? 'Running' : 'Idle',
        supportingText: pump.isOn ? 'Water flow detected' : 'No water flow',
        icon: Icons.power_settings_new,
      ),
      StatusMetricCardMolecule(
        title: 'Tank',
        value: '${storage.currentLiters.toStringAsFixed(0)} L',
        supportingText:
            'Capacity ${storage.capacityLiters.toStringAsFixed(0)} L • ${storage.levelPercentage.toStringAsFixed(1)}%',
        icon: Icons.water,
      ),
      StatusMetricCardMolecule(
        title: 'Fill ETA',
        value: _formatFillTime(fillTimeMinutes),
        supportingText: 'Formula: (Capacity - Current) / FlowRate',
        icon: Icons.timer,
      ),
    ];

    if (isLargeScreen) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: cards[0]),
          const Gap(12),
          Expanded(child: cards[1]),
          const Gap(12),
          Expanded(child: cards[2]),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [cards[0], const Gap(12), cards[1], const Gap(12), cards[2]],
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: colorScheme.onTertiaryContainer,
          ),
          const Gap(8),
          Expanded(
            child: Text(
              'Showing last known telemetry. $message',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardLoading extends StatelessWidget {
  const _DashboardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth >= 900;

        final gaugePlaceholder = const ShimmerBlockAtom(
          height: 380,
          borderRadius: 24,
        );

        final detailsPlaceholder = Column(
          children: const [
            ShimmerBlockAtom(height: 150, borderRadius: 20),
            Gap(12),
            ShimmerBlockAtom(height: 150, borderRadius: 20),
            Gap(12),
            ShimmerBlockAtom(height: 300, borderRadius: 20),
          ],
        );

        final content = isLargeScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 5, child: ShimmerBlockAtom(height: 560)),
                  const Gap(20),
                  Expanded(flex: 7, child: detailsPlaceholder),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [gaugePlaceholder, const Gap(16), detailsPlaceholder],
              );

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1220),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: content,
            ),
          ),
        );
      },
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.wifi_off, size: 42, color: colorScheme.error),
                const Gap(12),
                Text(
                  'Unable to load water telemetry',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                FilledButton.icon(
                  onPressed: () => context.read<WaterStorageCubit>().refresh(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatFillTime(double fillTimeMinutes) {
  if (fillTimeMinutes.isInfinite || fillTimeMinutes.isNaN) {
    return 'Unavailable';
  }

  if (fillTimeMinutes <= 0) {
    return 'Tank Full';
  }

  final roundedMinutes = fillTimeMinutes.round();
  if (roundedMinutes >= 60) {
    final duration = Duration(minutes: roundedMinutes);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours h $minutes m';
  }

  return '${fillTimeMinutes.toStringAsFixed(1)} min';
}
