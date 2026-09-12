import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_bloc.dart';
import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_event.dart';
import 'package:zone_game_garage/blocs/games/blank_fill/blank_fill_state.dart';
import 'package:zone_game_garage/screens/games/blank_fill/result_screen.dart';
import 'package:zone_game_garage/screens/gaming_screen.dart';

class BlankFillScreen extends StatefulWidget {
  const BlankFillScreen({super.key});

  @override
  State<BlankFillScreen> createState() => _BlankFillScreenState();
}

class _BlankFillScreenState extends State<BlankFillScreen> {
  final _formGlobalKey = GlobalKey<FormState>();

  late List<String> _words;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _words = [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlankFillBloc()..add(BlankFillInitial()),
      child: BlocConsumer<BlankFillBloc, BlankFillState>(
        listener: (context, state) {
          if (state.gameState == GameState.win) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute<void>(
                builder: (context) =>
                    GamingScreen(gameScreen: ResultScreen(gameResult: 'win')),
              ),
              (Route<dynamic> route) => false,
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Container(
              width: 500,
              child: Form(
                key: _formGlobalKey,
                child: Column(
                  children: [
                    // word
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        spacing: 5.0,
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

                            _words = [];
                            _formGlobalKey.currentState!.reset();
                          }
                        },
                        child: Text('Butt'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.letter, {super.key, required this.onSaved});

  final String letter;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: TextFormField(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          // 2. Remove the default Flutter styling
          decoration: InputDecoration(
            border: InputBorder
                .none, // Removes the default underline/outline border
            disabledBorder: InputBorder.none, // Removes the disabled border
            hintText: '',
            hintStyle: TextStyle(color: Colors.grey),

            // 1. AKTIFKAN & ATUR WARNA BACKGROUND
            filled: true,
            fillColor: Color.lerp(Colors.grey[100], Colors.amberAccent, 0.3),

            // 👈 TAMBAHKAN PADDING DI SINI
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0, // Jarak kiri dan kanan teks
              vertical:
                  30.0, // Jarak atas dan bawah teks (mengatur tinggi input)
            ),

            // Border Normal & Fokus (Oranye Tebal)
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.orangeAccent,
                width: 5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.orangeAccent,
                width: 5,
              ),
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
          style: const TextStyle(
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          maxLength: 1,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'cannot be empty';
            }
            return null;
          },
          inputFormatters: [UpperCaseTextFormatter()],
          onSaved: onSaved,
          controller: TextEditingController(
            text: letter == '-' ? '' : letter.toUpperCase(),
          ),
          enabled: letter == '-',
          textInputAction: TextInputAction.next,
        ),
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
