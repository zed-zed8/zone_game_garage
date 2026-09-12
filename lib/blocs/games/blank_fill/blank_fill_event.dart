sealed class BlankFillEvent {}

class BlankFillInitial extends BlankFillEvent {}

class BlankFillGuess extends BlankFillEvent {
  final String guess;

  BlankFillGuess(this.guess);
}

class BlankFillEnd extends BlankFillEvent {}
