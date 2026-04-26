import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_cubit.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_state.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_cubit.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_state.dart';
import 'package:motor_main/features/water_storage/presentation/widgets/fill_time_formatter.dart';

class ControlsPage extends StatelessWidget {
  const ControlsPage({super.key});

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
        child: BlocBuilder<WaterPumpCubit, WaterPumpState>(
          builder: (context, pumpState) {
            final isOn = pumpState.maybeWhen(
              loaded: (pump, _) => pump.isOn,
              error: (_, fallbackPump) => fallbackPump.isOn,
              orElse: () => false,
            );

            final isBusy = pumpState.maybeWhen(
              loading: () => true,
              loaded: (_, isOptimisticUpdate) => isOptimisticUpdate,
              orElse: () => false,
            );

            return BlocBuilder<WaterStorageCubit, WaterStorageState>(
              builder: (context, storageState) {
                final fillTimeText = storageState.maybeWhen(
                  loaded: (storage, fillTimeMinutes) =>
                      formatFillTime(fillTimeMinutes),
                  error: (_, lastKnownStorage) => '--:--',
                  orElse: () => '--:--',
                );

                final flowLabel = isOn ? 'High Flow (Strong)' : 'No Flow';
                final flowLevel = isOn ? 0.9 : 0.2;

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SYSTEM STATUS: ${isOn ? 'ACTIVE' : 'IDLE'}',
                            style: textTheme.labelSmall?.copyWith(
                              letterSpacing: 1,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const Gap(10),
                          Text(
                            'Estimated Time\nto Full',
                            style: textTheme.headlineMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              height: 1.1,
                            ),
                          ),
                          const Gap(8),
                          Text(
                            fillTimeText,
                            style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(18),
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 22),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: colorScheme.primaryContainer,
                                child: Icon(
                                  Icons.settings_input_component,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pump Power',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Main External Unit',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 19,
                                backgroundColor: colorScheme.surface,
                                child: Icon(
                                  isOn
                                      ? Icons.power_settings_new
                                      : Icons.power_off,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const Gap(24),
                          Semantics(
                            button: true,
                            toggled: isOn,
                            enabled: !isBusy,
                            label: 'Pump power control',
                            value: isOn ? 'On' : 'Off',
                            child: InkWell(
                              borderRadius: BorderRadius.circular(999),
                              onTap: isBusy
                                  ? null
                                  : () => context
                                        .read<WaterPumpCubit>()
                                        .togglePump(),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 260),
                                width: 128,
                                height: 128,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isOn
                                      ? colorScheme.primary
                                      : colorScheme.surfaceContainerHighest,
                                  border: Border.all(
                                    color: colorScheme.surface,
                                    width: 10,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colorScheme.primary.withAlpha(
                                        isOn ? 70 : 20,
                                      ),
                                      blurRadius: 24,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.power_settings_new,
                                      size: 38,
                                      color: isOn
                                          ? colorScheme.onPrimary
                                          : colorScheme.onSurfaceVariant,
                                    ),
                                    const Gap(4),
                                    if (isBusy)
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: isOn
                                              ? colorScheme.onPrimary
                                              : colorScheme.primary,
                                        ),
                                      )
                                    else
                                      Text(
                                        isOn ? 'ON' : 'OFF',
                                        style: textTheme.labelMedium?.copyWith(
                                          color: isOn
                                              ? colorScheme.onPrimary
                                              : colorScheme.onSurfaceVariant,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: colorScheme.primaryContainer,
                            child: Icon(
                              Icons.waves,
                              color: colorScheme.primary,
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FLOW STRENGTH',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                const Gap(3),
                                Text(
                                  flowLabel,
                                  style: textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Gap(8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    minHeight: 5,
                                    value: flowLevel,
                                    backgroundColor: colorScheme.surface,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
