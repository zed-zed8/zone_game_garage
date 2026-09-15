import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_event.dart';
import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_state.dart';
import 'package:zone_game_garage/models/games/blank_fill.dart';

import 'package:zone_game_garage/repositories/games/blank_fill_repository.dart';
import 'package:zone_game_garage/services/databases/app_database.dart';

class BlankFillBloc extends Bloc<BlankFillEvent, BlankFillState> {
  // option :
  int? timer;
  int? revealedLetterAmount;
  int? length;
  int? difficulty;

  // repository
  final BlankFillRepository _repository = BlankFillRepository(
    AppDatabase.instance,
  );

  BlankFillBloc({
    this.timer,
    this.revealedLetterAmount,
    this.length = 5,
    this.difficulty = 1,
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
    on<BlankFillEnd>(_onLoss);
  }

  /// Returns the starting hidden word for a new round.
  Future<String> _createHiddenWord() async {
    // use an API for random words
    String randomWord = await _repository.randomWord(
      length: length,
      diff: difficulty,
    );

    return randomWord;
  }

  /// Returns the starting hidden word for a new round.
  List<String> _wordHide(String hiddenWord) {
    List<String> letters = hiddenWord.split('');

    // get revealed letter amount and hidden letter amount
    int? revealedLetter = revealedLetterAmount;
    int hiddenNumber;
    if (revealedLetter == null || revealedLetter < 1) {
      hiddenNumber = math.Random().nextInt(letters.length);
      if (hiddenNumber < letters.length - 1) {
        hiddenNumber++;
      }
      revealedLetter = letters.length - hiddenNumber;
    } else {
      hiddenNumber = letters.length - revealedLetter;
    }

    // algorithm for hiding letter
    for (var i = 0; i < letters.length; i++) {
      if (hiddenNumber < 1) {
        break;
      }
      if (letters.length - i <= hiddenNumber) {
        letters[i] = '-';
        hiddenNumber--;
        continue;
      }
      if (math.Random().nextDouble() * hiddenNumber < hiddenNumber * 0.8) {
        letters[i] = '-';
        hiddenNumber--;
      }
    }

    return letters;
  }

  void _onInitial(BlankFillInitial event, Emitter<BlankFillState> emit) async {
    emit(state.copyWith(gameState: GameState.loading));

    String hiddenWord = await _createHiddenWord();
    developer.log('hidden word get');

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

  void _end(
    Emitter<BlankFillState> emit, {
    required GameState gameState,
    required String hiddenWord,
    required List<String> guesses,
  }) {
    if (gameState == GameState.win) {
      developer.log('WIN');
      print('WIN');
    } else if (gameState == GameState.lose) {
      developer.log('lose');
      print('lose');
    }
    // handle ending
    try {
      _repository.save(
        gameName: BlankFill.specification().gameName,
        blankFill: BlankFill(
          hiddenWord: hiddenWord,
          guesses: guesses,
          gameResult: gameState.string,
          playedAt: DateTime.now(),
          timer: timer,
          revealedLetterAmount: revealedLetterAmount,
          length: length,
          difficulty: difficulty,
        ),
      );
    } on Exception catch (e) {
      developer.log('Exception: $e');
    }
    emit(state.copyWith(gameState: gameState));
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
      _end(
        emit,
        gameState: GameState.win,
        hiddenWord: hiddenWord,
        guesses: guesses,
      );
    }
    developer.inspect(state);
  }

  void _onLoss(BlankFillEnd event, Emitter<BlankFillState> emit) {
    final String hiddenWord = state.hiddenWord;
    final List<String> guesses = List.from(state.guesses);

    _end(
      emit,
      gameState: GameState.lose,
      hiddenWord: hiddenWord,
      guesses: guesses,
    );
  }
}
