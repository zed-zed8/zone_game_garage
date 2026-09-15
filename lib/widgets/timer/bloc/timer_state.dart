class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(
      const Duration(seconds: 1),
      (x) => ticks - x - 1,
    ).take(ticks);
  }
}

sealed class TimerState {
  const TimerState(this.durationSecond);
  final int durationSecond;

  List<Object> get props => [durationSecond];
}

final class TimerInitial extends TimerState {
  const TimerInitial(super.durationSecond);

  @override
  String toString() => 'TimerInitial { duration: $durationSecond }';
}

final class TimerRunPause extends TimerState {
  const TimerRunPause(super.durationSecond);

  @override
  String toString() => 'TimerRunPause { duration: $durationSecond }';
}

final class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.durationSecond);

  @override
  String toString() => 'TimerRunInProgress { duration: $durationSecond }';
}

final class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}
