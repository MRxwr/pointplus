import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/timer_event.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _duration = 30;
  Timer? _timer;

  TimerBloc() : super(TimerInitial()) {
    on<StartTimer>(_onStartTimer);
    on<StopTimer>(_onStopTimer);
    on<Tick>(_onTick);
    on<ResetTimer>(_onResetTimer);
  }

  void _onStartTimer(StartTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      add(Tick(_duration - timer.tick));
    });
    emit(TimerRunInProgress(_duration));
  }

  void _onStopTimer(StopTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(TimerStopped(_duration));
  }

  void _onTick(Tick event, Emitter<TimerState> emit) {
    if (event.duration > 0) {
      emit(TimerRunInProgress(event.duration));
    } else {
      _timer?.cancel();
      emit(TimerRunComplete());
    }
  }

  void _onResetTimer(ResetTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(TimerInitial());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}