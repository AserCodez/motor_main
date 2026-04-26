import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';
import 'package:motor_main/ui/widgets/fill_time_formatter.dart';
import 'package:motor_main/ui/widgets/status_metric_card_widget.dart';

class StatusCardsWidget extends StatelessWidget {
  const StatusCardsWidget({
    super.key,
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
      StatusMetricCardWidget(
        title: 'Pump',
        value: pump.isOn ? 'Running' : 'Idle',
        supportingText: pump.isOn ? 'Water flow detected' : 'No water flow',
        icon: Icons.power_settings_new,
      ),
      StatusMetricCardWidget(
        title: 'Tank',
        value: '${storage.currentLiters.toStringAsFixed(0)} L',
        supportingText:
            'Capacity ${storage.capacityLiters.toStringAsFixed(0)} L • ${storage.levelPercentage.toStringAsFixed(1)}%',
        icon: Icons.water,
      ),
      StatusMetricCardWidget(
        title: 'Fill ETA',
        value: formatFillTime(fillTimeMinutes),
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
