import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:motor_main/core/theme/app_theme.dart';
import 'package:motor_main/features/water_pump/presentation/widgets/pump_power_button_widget.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';
import 'package:motor_main/features/water_storage/presentation/widgets/water_history_chart_widget.dart';
import 'package:motor_main/features/water_storage/presentation/widgets/water_level_gauge_widget.dart';

@Preview(name: 'Water Gauge', group: 'Widgets')
Widget waterGaugePreview() {
  return MaterialApp(
    theme: AppTheme.light(),
    home: const Scaffold(
      body: Center(
        child: WaterLevelGaugeWidget(currentLiters: 742, capacityLiters: 1000),
      ),
    ),
  );
}

@Preview(name: 'Pump Toggle ON', group: 'Widgets')
Widget pumpToggleOnPreview() {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      body: Center(
        child: PumpPowerButtonWidget(
          isOn: true,
          isBusy: false,
          onToggle: () {},
        ),
      ),
    ),
  );
}

@Preview(name: 'Analytics Card', group: 'Widgets', size: Size(900, 600))
Widget analyticsCardPreview() {
  return MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: WaterHistoryChartWidget(history: _sampleHistory),
      ),
    ),
  );
}

final List<DailyWaterLevelPoint> _sampleHistory = [
  DailyWaterLevelPoint(date: DateTime(2026, 4, 20), levelPercentage: 28),
  DailyWaterLevelPoint(date: DateTime(2026, 4, 21), levelPercentage: 35),
  DailyWaterLevelPoint(date: DateTime(2026, 4, 22), levelPercentage: 41),
  DailyWaterLevelPoint(date: DateTime(2026, 4, 23), levelPercentage: 52),
  DailyWaterLevelPoint(date: DateTime(2026, 4, 24), levelPercentage: 58),
  DailyWaterLevelPoint(date: DateTime(2026, 4, 25), levelPercentage: 64),
  DailyWaterLevelPoint(date: DateTime(2026, 4, 26), levelPercentage: 71),
];
