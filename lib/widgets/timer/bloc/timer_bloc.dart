import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zone_game_garage/widgets/timer/bloc/timer_event.dart';
import 'package:zone_game_garage/widgets/timer/bloc/timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc({required this._ticker, required this._durationSecond})
    : super(TimerInitial(_durationSecond)) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
  }

  final Ticker _ticker;
  final int _durationSecond;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.durationSecond));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.durationSecond)
        .listen(
          (durationSecond) => add(TimerTicked(durationSecond: durationSecond)),
        );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.durationSecond));
    }
  }

  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.durationSecond));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(TimerInitial(_durationSecond));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.durationSecond > 0
          ? TimerRunInProgress(event.durationSecond)
          : const TimerRunComplete(),
    );
  }
}
