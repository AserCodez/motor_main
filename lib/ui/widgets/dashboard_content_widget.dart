import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_cubit.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_state.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';
import 'package:motor_main/ui/widgets/analytics_card_widget.dart';
import 'package:motor_main/ui/widgets/gauge_panel_widget.dart';
import 'package:motor_main/ui/widgets/status_cards_widget.dart';
import 'package:motor_main/ui/widgets/warning_banner_widget.dart';

class DashboardContentWidget extends StatelessWidget {
  const DashboardContentWidget({
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

            final gaugePanel = GaugePanelWidget(
              storage: storage,
              fillTimeMinutes: fillTimeMinutes,
              pump: pump,
              isPumpBusy: isPumpBusy,
            );

            final detailsPanel = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StatusCardsWidget(
                  storage: storage,
                  pump: pump,
                  fillTimeMinutes: fillTimeMinutes,
                  isLargeScreen: isLargeScreen,
                ),
                const Gap(16),
                AnalyticsCardWidget(history: storage.history),
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
                        WarningBannerWidget(message: warningMessage!),
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
