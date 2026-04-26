import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WaterLevelGaugeWidget extends StatelessWidget {
  const WaterLevelGaugeWidget({
    super.key,
    required this.currentLiters,
    required this.capacityLiters,
  });

  final double currentLiters;
  final double capacityLiters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final percentage = capacityLiters <= 0
        ? 0.0
        : (currentLiters / capacityLiters).clamp(0.0, 1.0);

    return Semantics(
      readOnly: true,
      label:
          'Tank level ${(percentage * 100).toStringAsFixed(1)} percent, ${currentLiters.toStringAsFixed(0)} liters available',
      child: Container(
        width: 290,
        height: 290,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.surfaceContainerLowest,
          border: Border.all(color: colorScheme.primary, width: 4),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: percentage,
                strokeWidth: 14,
                strokeCap: StrokeCap.round,
                backgroundColor: colorScheme.primaryContainer,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentLiters.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'LITERS',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap(8),
                Text(
                  'Capacity ${capacityLiters.toStringAsFixed(0)} L',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
