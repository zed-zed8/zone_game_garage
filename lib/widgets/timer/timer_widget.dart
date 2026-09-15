import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zone_game_garage/widgets/timer/bloc/timer_bloc.dart';
import 'package:zone_game_garage/widgets/timer/bloc/timer_event.dart';
import 'package:zone_game_garage/widgets/timer/bloc/timer_state.dart';

class TimerWidget extends StatelessWidget {
  final int durationSecond;
  final TextStyle? textStyle;
  final Function()? onStart;
  final Function()? onTimerCompleted;

  const TimerWidget({
    super.key,
    required this.durationSecond,
    this.textStyle,
    this.onStart,
    this.onTimerCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          TimerBloc(ticker: Ticker(), durationSecond: durationSecond),
      child: BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
        builder: (context, state) {
          final duration = context.select(
            (TimerBloc bloc) => bloc.state.durationSecond,
          );
          final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(
            2,
            '0',
          );
          final secondsStr = (duration % 60).toString().padLeft(2, '0');

          switch (state) {
            case TimerInitial():
              context.read<TimerBloc>().add(
                TimerStarted(durationSecond: state.durationSecond),
              );
              onStart;
              break;
            case TimerRunComplete():
              onTimerCompleted == null ? onTimerCompleted : onTimerCompleted!();
              break;
            default:
          }
          return Text('$minutesStr:$secondsStr', style: textStyle);
        },
      ),
    );
  }
}
