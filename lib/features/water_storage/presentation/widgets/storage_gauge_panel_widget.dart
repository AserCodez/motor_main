import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_cubit.dart';
import 'package:motor_main/features/water_pump/presentation/widgets/pump_power_button_widget.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';
import 'package:motor_main/features/water_storage/presentation/widgets/fill_time_formatter.dart';
import 'package:motor_main/features/water_storage/presentation/widgets/water_level_gauge_widget.dart';

class StorageGaugePanelWidget extends StatelessWidget {
  const StorageGaugePanelWidget({
    super.key,
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
              child: WaterLevelGaugeWidget(
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
                  label: Text('Fill time: ${formatFillTime(fillTimeMinutes)}'),
                ),
              ],
            ),
            const Gap(16),
            PumpPowerButtonWidget(
              isOn: pump.isOn,
              isBusy: isPumpBusy,
              onToggle: () => context.read<WaterPumpCubit>().togglePump(),
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
