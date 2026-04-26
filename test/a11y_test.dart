import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motor_main/core/theme/app_theme.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_request_model.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';
import 'package:motor_main/features/water_pump/domain/repositories/water_pump_repository.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_cubit.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_request_model.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';
import 'package:motor_main/features/water_storage/domain/repositories/water_storage_repository.dart';
import 'package:motor_main/features/water_storage/domain/usecases/calculate_fill_time_usecase.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_cubit.dart';
import 'package:motor_main/ui/organisms/smart_water_dashboard_organism.dart';

void main() {
  testWidgets('Dashboard follows core accessibility guidelines', (
    WidgetTester tester,
  ) async {
    final semanticsHandle = tester.ensureSemantics();

    final storageCubit = WaterStorageCubit(
      repository: _FakeWaterStorageRepository(),
      requestModel: const WaterStorageRequestModel(
        tankId: 'main_tank',
        capacityLiters: 1000,
        flowRateLitersPerMinute: 10,
      ),
      calculateFillTimeUseCase: const CalculateFillTimeUseCase(),
    )..startMonitoring();

    final pumpCubit = WaterPumpCubit(
      repository: _FakeWaterPumpRepository(),
      waterStorageCubit: storageCubit,
    )..startMonitoring();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<WaterStorageCubit>.value(value: storageCubit),
          BlocProvider<WaterPumpCubit>.value(value: pumpCubit),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const SmartWaterDashboardOrganism(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    await expectLater(tester, meetsGuideline(textContrastGuideline));

    await pumpCubit.close();
    await storageCubit.close();
    semanticsHandle.dispose();
  });
}

class _FakeWaterStorageRepository implements WaterStorageRepository {
  const _FakeWaterStorageRepository();

  @override
  Future<WaterStorageResponseModel> fetchStorageSnapshot(
    WaterStorageRequestModel request,
  ) {
    return Future<WaterStorageResponseModel>.value(_fixtureStorage);
  }

  @override
  Stream<WaterStorageResponseModel> watchStorage(
    WaterStorageRequestModel request,
  ) {
    return Stream<WaterStorageResponseModel>.value(_fixtureStorage);
  }
}

class _FakeWaterPumpRepository implements WaterPumpRepository {
  bool _isOn = false;

  @override
  Future<WaterPumpResponseModel> setPumpStatus(WaterPumpRequestModel request) {
    _isOn = request.desiredOn;
    return Future<WaterPumpResponseModel>.value(
      WaterPumpResponseModel(
        isOn: _isOn,
        lastUpdated: DateTime(2026, 4, 26),
        source: 'test',
      ),
    );
  }

  @override
  Stream<WaterPumpResponseModel> watchPumpStatus() {
    return Stream<WaterPumpResponseModel>.value(
      WaterPumpResponseModel(
        isOn: _isOn,
        lastUpdated: DateTime(2026, 4, 26),
        source: 'test',
      ),
    );
  }
}

final WaterStorageResponseModel _fixtureStorage = WaterStorageResponseModel(
  currentLiters: 680,
  capacityLiters: 1000,
  flowRateLitersPerMinute: 10,
  lastUpdated: DateTime(2026, 4, 26),
  history: [
    DailyWaterLevelPoint(date: DateTime(2026, 4, 20), levelPercentage: 28),
    DailyWaterLevelPoint(date: DateTime(2026, 4, 21), levelPercentage: 32),
    DailyWaterLevelPoint(date: DateTime(2026, 4, 22), levelPercentage: 40),
    DailyWaterLevelPoint(date: DateTime(2026, 4, 23), levelPercentage: 45),
    DailyWaterLevelPoint(date: DateTime(2026, 4, 24), levelPercentage: 52),
    DailyWaterLevelPoint(date: DateTime(2026, 4, 25), levelPercentage: 60),
    DailyWaterLevelPoint(date: DateTime(2026, 4, 26), levelPercentage: 68),
  ],
);
