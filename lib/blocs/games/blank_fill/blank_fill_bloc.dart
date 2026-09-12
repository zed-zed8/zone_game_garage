import 'dart:developer';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_event.dart';
import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_state.dart';

class BlankFillBloc extends Bloc<BlankFillEvent, BlankFillState> {
  // option :
  int? timer; // TODO implements timer
  int? revealedLetterAmount; // TODO implements Letter amount
  int? lenght; // TODO implements lenght
  int? difficulty;

  BlankFillBloc({
    this.timer,
    this.revealedLetterAmount,
    this.lenght,
    this.difficulty,
  }) : super(
         const BlankFillState(
           hiddenWord: '',
           word: [],
           guesses: [],
           gameState: GameState.running,
         ),
       ) {
    on<BlankFillInitial>(_onInitial);
    on<BlankFillGuess>(_onGuessed);
  }

  /// Returns the starting hidden word for a new round.
  String _createHiddenWord() {
    // use an API for random words
    String randomWord = 'brain';

    return randomWord;
  }

  /// Returns the starting hidden word for a new round.
  List<String> _wordHide(String hiddenWord) {
    List<String> letters = hiddenWord.split('');

    while (!letters.contains('-')) {
      for (var i = 0; i < letters.length; i++) {
        if (Random().nextInt(9) > 1) {
          letters[i] = '-';
        }
      }
    }

    return letters;
  }

  void _onInitial(BlankFillInitial event, Emitter<BlankFillState> emit) {
    String hiddenWord = _createHiddenWord();
    List<String> word = _wordHide(hiddenWord);
    emit(
      BlankFillState(
        hiddenWord: hiddenWord,
        word: word,
        guesses: [],
        gameState: GameState.running,
      ),
    );
  }

  void _onGuessed(BlankFillGuess event, Emitter<BlankFillState> emit) {
    final String hiddenWord = state.hiddenWord;
    final List<String> word = state.word;
    final List<String> guesses = state.guesses;

    String guess = event.guess;
    guesses.add(guess);

    List<String> inputLetters = guess.split('');
    List<String> hiddenLetters = hiddenWord.split('');

    print(
      'Are they equal: ${word.length}, ${guess.length}, ${inputLetters.length}, ${word.length == guess.length}',
    );
    print(
      'Are they equal: ${word}, ${guess}, ${inputLetters}, ${word == guess}',
    );

    for (var i = 0; i < word.length; i++) {
      if (word[i] != '-') {
        continue;
      }
      if (inputLetters[i] == hiddenLetters[i]) {
        word[i] = inputLetters[i];
      }
    }

    emit(state.copyWith(word: word, guesses: guesses));

    // check if win or not
    if (!word.contains('-')) {
      print('WIN');
      // handle win
      emit(state.copyWith(gameState: GameState.win));
    }
    print('butt');
    print(state);
    inspect(state);
  }
}
