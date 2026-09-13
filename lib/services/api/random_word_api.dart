import 'dart:io';

import 'package:http/http.dart' as http;

enum EndPoints {
  word('/word'),
  all('/all'),
  languages('/languages');

  EndPoints(this.endPoint);

  final String endPoint;
}

class RandomWordApi {
  /// fetch random word from https://random-word-api.herokuapp.com/word
  ///
  /// [number] Sets the number of requested words.
  /// If it exceeds the maximum stored amount, it will just return all of them.
  ///
  /// [length] Sets the length of requested words.
  /// This will only return words that contain x amount of letters.
  ///
  /// [lang] Sets the language of requested words. Currently supported languages:
  ///
  /// - English (just don't provide the parameter)
  /// - Spanish (?lang=es)
  /// - Italian (?lang=it)
  /// - German (?lang=de)
  /// - French (?lang=fr)
  /// - Chinese (?lang=zh)
  /// - Brazilian Portuguese (?lang=pt-br)
  /// - Romanian (?lang=ro)
  ///
  /// [diff] Filters words by difficulty/commonality using Wikipedia word frequency data.
  /// ![Only works when requesting 5 or fewer words.]!
  ///
  /// - [1] = Easy - Very common words (e.g., "water", "house")
  /// - [2] = Medium-Easy - Common words
  /// - [3] = Medium - Moderately common words
  /// - [4] = Medium-Hard - Uncommon words
  /// - [5] = Hard - Rare words (e.g., "defenestration")
  ///
  /// return a json String
  static Future<String> randomWord({
    int? number,
    int? length,
    String? lang,
    int? diff,
  }) async {
    String baseUrl = 'random-word-api.herokuapp.com';

    final Map<String, String> queryParameters = {};
    if (number != null) queryParameters['number'] = number.toString();
    if (length != null) queryParameters['length'] = length.toString();
    if (lang != null) queryParameters['lang'] = lang;
    if (diff != null) queryParameters['diff'] = diff.toString();

    final uri = Uri.https(baseUrl, EndPoints.word.endPoint, queryParameters);
    print(uri);

    // WRAP ONLY THIS SECTION IN A TRY/CATCH SAFETY NET
    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));

      return response.body;
    } on SocketException catch (e) {
      // This catches the exact "Failed host lookup" error you saw
      print("Network/DNS Error (Device might be offline or blocked): $e");
      return '["garage"]';
    } on http.ClientException catch (e) {
      print("Flutter HTTP Client Error Hooked: $e");
      return '["garage"]';
    } catch (e, stackTrace) {
      // Catching Object guarantees Windows system/socket errors won't pass through
      print("Windows Native Network Error Hooked: $e");
      print(stackTrace); // This will tell us the EXACT network cause
      return '["garage"]';
    }
  }
}
