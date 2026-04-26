import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PumpPowerButtonWidget extends StatelessWidget {
  const PumpPowerButtonWidget({
    super.key,
    required this.isOn,
    required this.isBusy,
    required this.onToggle,
  });

  final bool isOn;
  final bool isBusy;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      toggled: isOn,
      enabled: !isBusy,
      label: 'Water pump control switch',
      value: isOn ? 'Running' : 'Stopped',
      child: FilledButton.icon(
        onPressed: isBusy ? null : onToggle,
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          backgroundColor: isOn
              ? colorScheme.primary
              : colorScheme.secondaryContainer,
          foregroundColor: isOn
              ? colorScheme.onPrimary
              : colorScheme.onSecondaryContainer,
        ),
        icon: const Icon(Icons.power_settings_new),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isOn ? 'Pump ON' : 'Pump OFF'),
            if (isBusy) ...[
              const Gap(8),
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isOn ? colorScheme.onPrimary : colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
