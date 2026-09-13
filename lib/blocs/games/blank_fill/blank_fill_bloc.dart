import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_event.dart';
import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_state.dart';

import 'package:zone_game_garage/repositories/games/blank_fill_repository.dart';
import 'package:zone_game_garage/services/databases/app_database.dart';
import 'package:zone_game_garage/services/databases/game_database.dart';

class BlankFillBloc extends Bloc<BlankFillEvent, BlankFillState> {
  // option :
  int? timer; // TODO implements timer
  int? revealedLetterAmount; // TODO implements Letter amount
  int? lenght; // TODO implements lenght
  int? difficulty;

  // repository
  BlankFillRepository _repository = BlankFillRepository(
    GameDatabase(AppDatabase.instance),
  );

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
  Future<String> _createHiddenWord() async {
    // TODO use an API for random words
    String randomWord = await _repository.randomWord();

    return randomWord;
  }

  /// Returns the starting hidden word for a new round.
  List<String> _wordHide(String hiddenWord) {
    List<String> letters = hiddenWord.split('');

    // while (!letters.contains('-')) {
    for (var i = 0; i < letters.length; i++) {
      // if (Random().nextInt(9) > 1) {
      //   letters[i] = '-';
      // }
      if (i % 2 == 0) {
        letters[i] = '-';
      }
    }
    // }

    return letters;
  }

  void _onInitial(BlankFillInitial event, Emitter<BlankFillState> emit) async {
    emit(state.copyWith(gameState: GameState.loading));
    String hiddenWord = await _createHiddenWord();
    print('hidden word get');
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
    final List<String> word = List.from(state.word);
    final List<String> guesses = List.from(state.guesses);

    String guess = event.guess;
    guesses.add(guess);

    List<String> inputLetters = guess.split('');
    List<String> hiddenLetters = hiddenWord.split('');

    // log('Are they equal: ${word.length}, ${guess.length}, ${inputLetters.length}, ${word.length == guess.length}');
    // log('Are they equal: ${word}, ${guess}, ${inputLetters}, ${word == guess}');

    for (var i = 0; i < word.length; i++) {
      if (word[i] != '-') {
        continue;
      }
      if (inputLetters[i] == hiddenLetters[i]) {
        word[i] = inputLetters[i];
      }
    }
    // inspect(word);
    // inspect(inputLetters);
    // inspect(hiddenLetters);

    emit(
      state.copyWith(
        word: word,
        guesses: guesses,
        gameState: GameState.running,
      ),
    );

    // check if win or not
    // log((!word.contains('-')).toString());
    if (!word.contains('-')) {
      log('WIN');
      // handle win
      emit(state.copyWith(gameState: GameState.win));
    }
    inspect(state);
  }
}
