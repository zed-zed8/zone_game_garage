enum GameState {
  running('running'),
  win('win'),
  lose('lose'),
  loading('loading');

  GameState(this.string);
  final String string;
}

class BlankFillState {
  final String hiddenWord;
  final List<String> word;
  final List<String> guesses;
  final GameState gameState;

  const BlankFillState({
    required this.hiddenWord,
    required this.word,
    required this.guesses,
    required this.gameState,
  });

  BlankFillState copyWith({
    String? hiddenWord,
    List<String>? word,
    List<String>? guesses,
    GameState? gameState,
  }) {
    return BlankFillState(
      hiddenWord: hiddenWord ?? this.hiddenWord,
      word: word ?? this.word,
      guesses: guesses ?? this.guesses,
      gameState: gameState ?? this.gameState,
    );
  }
}
