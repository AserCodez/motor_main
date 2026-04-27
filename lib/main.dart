import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_main/core/theme/app_theme.dart';
import 'package:motor_main/features/navigation/presentation/pages/main_tab_screen.dart';
import 'package:motor_main/features/water_pump/data/datasources/water_pump_remote_datasource.dart';
import 'package:motor_main/features/water_pump/data/repositories/water_pump_repository_impl.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_cubit.dart';
import 'package:motor_main/features/water_storage/data/datasources/water_storage_remote_datasource.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_request_model.dart';
import 'package:motor_main/features/water_storage/data/repositories/water_storage_repository_impl.dart';
import 'package:motor_main/features/water_storage/domain/usecases/calculate_fill_time_usecase.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Start Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MotorMainApp());

  if (kIsWeb) {
    SemanticsBinding.instance.ensureSemantics();
  }
}

class MotorMainApp extends StatefulWidget {
  const MotorMainApp({super.key});

  @override
  State<MotorMainApp> createState() => _MotorMainAppState();
}

class _MotorMainAppState extends State<MotorMainApp> {
  late final WaterStorageCubit _waterStorageCubit;
  late final WaterPumpCubit _waterPumpCubit;

  @override
  void initState() {
    super.initState();

    final realtimeDatabase = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: DefaultFirebaseOptions.currentPlatform.databaseURL,
    );

    final waterStorageRepository = WaterStorageRepositoryImpl(
      remoteDatasource: WaterStorageRemoteDatasource(
        database: realtimeDatabase,
      ),
    );

    _waterStorageCubit = WaterStorageCubit(
      repository: waterStorageRepository,
      requestModel: const WaterStorageRequestModel(
        tankId: 'main_tank',
        capacityLiters: 1000,
        flowRateLitersPerMinute: 15,
      ),
      calculateFillTimeUseCase: const CalculateFillTimeUseCase(),
    )..startMonitoring();

    final waterPumpRepository = WaterPumpRepositoryImpl(
      remoteDatasource: WaterPumpRemoteDatasource(database: realtimeDatabase),
    );

    _waterPumpCubit = WaterPumpCubit(
      repository: waterPumpRepository,
      waterStorageCubit: _waterStorageCubit,
    )..startMonitoring();
  }

  @override
  void dispose() {
    unawaited(_waterPumpCubit.close());
    unawaited(_waterStorageCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WaterStorageCubit>.value(value: _waterStorageCubit),
        BlocProvider<WaterPumpCubit>.value(value: _waterPumpCubit),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Water Storage & Pump',
        theme: AppTheme.light(),
        home: const MainTabScreen(),
      ),
    );
  }
}
