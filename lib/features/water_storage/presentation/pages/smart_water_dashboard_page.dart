import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_main/features/water_pump/presentation/widgets/water_pump_state_listener_widget.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_cubit.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_state.dart';
import 'package:motor_main/features/water_storage/presentation/widgets/water_storage_dashboard_content_widget.dart';
import 'package:motor_main/features/water_storage/presentation/widgets/water_storage_error_widget.dart';
import 'package:motor_main/features/water_storage/presentation/widgets/water_storage_loading_widget.dart';

class SmartWaterDashboardPage extends StatelessWidget {
  const SmartWaterDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WaterPumpStateListenerWidget(
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.cloud,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: const Text('MOTORLIO'),
          actions: [
            IconButton(
              onPressed: () => context.read<WaterStorageCubit>().refresh(),
              tooltip: 'Refresh telemetry',
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<WaterStorageCubit, WaterStorageState>(
            builder: (context, storageState) {
              final content = storageState.when(
                initial: () => const WaterStorageLoadingWidget(
                  key: ValueKey('dashboard_initial'),
                ),
                loading: () => const WaterStorageLoadingWidget(
                  key: ValueKey('dashboard_loading'),
                ),
                loaded: (storage, fillTimeMinutes) {
                  return WaterStorageDashboardContentWidget(
                    key: const ValueKey('dashboard_loaded'),
                    storage: storage,
                    fillTimeMinutes: fillTimeMinutes,
                  );
                },
                error: (message, lastKnownStorage) {
                  if (lastKnownStorage != null) {
                    return WaterStorageDashboardContentWidget(
                      key: const ValueKey('dashboard_stale'),
                      storage: lastKnownStorage,
                      fillTimeMinutes: double.infinity,
                      warningMessage: message,
                    );
                  }

                  return WaterStorageErrorWidget(
                    key: const ValueKey('dashboard_error'),
                    message: message,
                    onRetry: () => context.read<WaterStorageCubit>().refresh(),
                  );
                },
              );

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: content,
              );
            },
          ),
        ),
      ),
    );
  }
}
