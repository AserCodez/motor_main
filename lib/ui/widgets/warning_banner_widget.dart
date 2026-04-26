import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WarningBannerWidget extends StatelessWidget {
  const WarningBannerWidget({super.key, required this.message});

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
