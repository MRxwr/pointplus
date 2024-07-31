abstract class TimerState {}

class TimerInitial extends TimerState {}

class TimerRunInProgress extends TimerState {
  final int duration;
  TimerRunInProgress(this.duration);
}

class TimerRunComplete extends TimerState {}

class TimerStopped extends TimerState {
  final int elapsedTime;
  TimerStopped(this.elapsedTime);
}
