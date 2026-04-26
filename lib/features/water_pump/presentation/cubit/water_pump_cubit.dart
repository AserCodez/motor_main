import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'water_pump_state.dart';

class WaterPumpCubit extends Cubit<WaterPumpState> {
  WaterPumpCubit() : super(WaterPumpInitial());
}
