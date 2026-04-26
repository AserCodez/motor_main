import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_cubit.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_state.dart';

class WaterPumpStateListenerWidget extends StatelessWidget {
  const WaterPumpStateListenerWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<WaterPumpCubit, WaterPumpState>(
      listenWhen: (previous, next) {
        return next.maybeWhen(
          error: (message, fallbackPump) => true,
          orElse: () => false,
        );
      },
      listener: (context, state) {
        state.whenOrNull(
          error: (message, fallbackPump) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          },
        );
      },
      child: child,
    );
  }
}
