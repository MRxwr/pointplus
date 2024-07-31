import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TimerEvent {}

class StartTimer extends TimerEvent {}

class StopTimer extends TimerEvent {}

class Tick extends TimerEvent {
  final int duration;
  Tick(this.duration);
}

class ResetTimer extends TimerEvent {}


