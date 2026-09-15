import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_bloc.dart';
import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_event.dart';
import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_state.dart';
import 'package:zone_game_garage/screens/games/blank_fill/result_screen.dart';
import 'package:zone_game_garage/widgets/timer/timer_widget.dart';

class BlankFillScreen extends StatefulWidget {
  const BlankFillScreen({
    super.key,
    required this._timerSecond,
    required this._revealedLetterAmount,
    required this._length,
    required this._difficulty,
  });
  final int _timerSecond;
  final int _revealedLetterAmount;
  final int _length;
  final int _difficulty;

  @override
  State<BlankFillScreen> createState() => _BlankFillScreenState();
}

class _BlankFillScreenState extends State<BlankFillScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  late List<String> _words;

  @override
  void initState() {
    super.initState();
    _words = [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlankFillBloc(
        timer: widget._timerSecond,
        revealedLetterAmount: widget._revealedLetterAmount,
        length: widget._length,
        difficulty: widget._difficulty,
      )..add(BlankFillInitial()),
      child: BlocBuilder<BlankFillBloc, BlankFillState>(
        builder: (context, state) {
          if (state.gameState == GameState.loading) {
            log('before state');
            inspect(state);
            return const Center(child: CircularProgressIndicator());
          }
          if (state.gameState == GameState.win) {
            return ResultScreen(
              gameResult: 'win',
              hiddenWord: state.hiddenWord,
            );
          }
          if (state.gameState == GameState.lose) {
            return ResultScreen(
              gameResult: 'lose',
              hiddenWord: state.hiddenWord,
            );
          }
          if (state.gameState == GameState.running) {
            log('running app: ');
            inspect(state);
            print(state.hiddenWord);
            return Center(
              child: SizedBox(
                width: 1000,
                child: Form(
                  key: _formGlobalKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // timer
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TimerWidget(
                          durationSecond: widget._timerSecond,
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          onTimerCompleted: () {
                            context.read<BlankFillBloc>().add(BlankFillEnd());
                          },
                        ),
                      ),

                      // word
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 5.0,
                          alignment: WrapAlignment.center,
                          children: [
                            for (final letter in state.word)
                              Tile(
                                letter,
                                onSaved: (value) {
                                  _words.add(value!);
                                },
                              ),
                          ],
                        ),
                      ),

                      // submit button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          onPressed: () {
                            if (_formGlobalKey.currentState!.validate()) {
                              _formGlobalKey.currentState!.save();

                              context.read<BlankFillBloc>().add(
                                BlankFillGuess(_words.join('').toLowerCase()),
                              );

                              _formGlobalKey.currentState!.reset();
                            }
                            _words = [];
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Text('nothing');
        },
      ),
    );
  }
}

class Tile extends StatefulWidget {
  const Tile(this.letter, {super.key, required this.onSaved});

  final String letter;
  final Function(String?)? onSaved;

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the controller once when the widget enters the tree
    _controller = TextEditingController(
      text: widget.letter != '-' ? widget.letter.toUpperCase() : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Always dispose controllers to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController(
      text: widget.letter != '-' ? widget.letter.toUpperCase() : '',
    );

    // 1. Dapatkan tinggi layar HP saat ini
    final double _screenHeight = MediaQuery.of(context).size.height;
    // final double screenWidth = MediaQuery.of(context).size.width;

    // 2. Hitung padding vertikal responsif (contoh: 2% dari tinggi layar)
    // Berikan batas minimal (clamp) agar tidak terlalu tipis di HP jadul
    final double _responsivePadding = (_screenHeight * 0.02).clamp(12.0, 20.0);

    // 3. Hitung ukuran font responsif (contoh: 1.8% dari tinggi layar)
    // final double responsiveFontSize = (screenHeight * 0.018).clamp(14.0, 18.0);

    return SizedBox(
      width: 100,
      height: 100,
      child: TextFormField(
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        // 2. Remove the default Flutter styling
        decoration: InputDecoration(
          border:
              InputBorder.none, // Removes the default underline/outline border
          disabledBorder: InputBorder.none, // Removes the disabled border
          hintText: '',
          hintStyle: TextStyle(color: Colors.grey),

          // 1. AKTIFKAN & ATUR WARNA BACKGROUND
          filled: true,
          fillColor: Color.lerp(Colors.grey[100], Colors.amberAccent, 0.3),

          // 👈 TAMBAHKAN PADDING DI SINI

          // 4. Pasang padding responsif
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: _responsivePadding, // 👈 Tinggi input akan menyesuaikan layar HP
          ),

          // Border Normal & Fokus (Oranye Tebal)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orangeAccent, width: 5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orangeAccent, width: 5),
          ),

          // Border otomatis berubah Merah saat Validasi Error
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 5),
          ),

          // Gaya teks error di bawah kotak
          errorStyle: const TextStyle(fontSize: 12, color: Colors.red),
        ),
        // 3. Style the actual input text
        style: TextStyle(color: Colors.black),
        maxLength: 1,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Empty';
          }
          return null;
        },
        inputFormatters: [UpperCaseTextFormatter()],
        onSaved: widget.onSaved,
        controller: _controller,
        enabled: widget.letter == '-',
        textInputAction: TextInputAction.next,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection, // Keeps the cursor in the correct position
    );
  }
}
