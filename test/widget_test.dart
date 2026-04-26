import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motor_main/core/theme/app_theme.dart';
import 'package:motor_main/ui/atoms/water_level_gauge_atom.dart';

void main() {
  testWidgets('Water level gauge renders current liters', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Center(
            child: WaterLevelGaugeAtom(
              currentLiters: 650,
              capacityLiters: 1000,
            ),
          ),
        ),
      ),
    );

    expect(find.text('650'), findsOneWidget);
    expect(find.text('LITERS'), findsOneWidget);
  });
}
