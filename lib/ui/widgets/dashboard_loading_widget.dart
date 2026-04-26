import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:motor_main/ui/widgets/shimmer_block_widget.dart';

class DashboardLoadingWidget extends StatelessWidget {
  const DashboardLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth >= 900;

        final gaugePlaceholder = const ShimmerBlockWidget(
          height: 380,
          borderRadius: 24,
        );

        final detailsPlaceholder = Column(
          children: const [
            ShimmerBlockWidget(height: 150, borderRadius: 20),
            Gap(12),
            ShimmerBlockWidget(height: 150, borderRadius: 20),
            Gap(12),
            ShimmerBlockWidget(height: 300, borderRadius: 20),
          ],
        );

        final content = isLargeScreen
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 5,
                    child: ShimmerBlockWidget(height: 560),
                  ),
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
