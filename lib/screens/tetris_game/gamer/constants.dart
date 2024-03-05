import 'dart:math';

import 'package:growtopia/models/spelling_game/spelling_game_model.dart';
import 'package:growtopia/utils/utils.dart';
import 'package:flutter/material.dart';
import 'utils.dart' as game_utils;

class GameConstants {
  GameConstants._();

  ///the height of game pad
  static final GAME_PAD_MATRIX_H = Utils.isSmallDevice() ? 14 : 16;

  ///the width of game pad
  static const GAME_PAD_MATRIX_W = 8;

  static List<String> LIST_WORDS = [];

  static SpellingGameModel? currentGame;

  ///duration for show a line when reset
  static const REST_LINE_DURATION = Duration(milliseconds: 50);

  static const LEVEL_MAX = 6;

  static const LEVEL_MIN = 1;

  static const POINT_PER_LEVEL = 50;

  static const GAME_PAD_WIDTH_RATIO = 1.0;

  static const SWIPE_DOWN_THRESHOLD = 80;

  static const SPEED = [
    Duration(milliseconds: 1000),
    Duration(milliseconds: 850),
    Duration(milliseconds: 600),
    Duration(milliseconds: 500),
    Duration(milliseconds: 250),
    Duration(milliseconds: 160),
  ];

  static const CLEAR_VALUE = 1000;

  static const kSingleBlockRate = 5; // 1/5 chance to generate single block

  static double getGameCellWidth(BuildContext context) {
    return getGamePadWidth(context) / GAME_PAD_MATRIX_W;
  }

  static double getGamePadWidth(BuildContext context) {
    final screenW = getGameScreenWidth(context) * 0.8;
    return screenW * GAME_PAD_WIDTH_RATIO;
  }

  static double getGameScreenWidth(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final minSize = min(size.width, size.height);
    // final maxSize = max(size.width, size.height);
    final padHeight = size.height - 130;
    final gwidth =
        min(size.width, padHeight * GAME_PAD_MATRIX_W / GAME_PAD_MATRIX_H);
    return gwidth;
  }

  static List<String> wordParts = [];
  static List<String> listCharacters = [];

  static List<String> _getSortedWords(List<String> words) {
    final list = [...words];
    list.sort((a, b) => a.toString().length.compareTo(b.toString().length));
    if (list.length < 4) {
      return list;
    }
    return list.sublist(0, 4);
  }

  static void genWordParts(SpellingGameModel game) {
    List<String> words = _getSortedWords(game.words ?? []);
    currentGame = game;
    wordParts.clear();
    listCharacters.clear();
    LIST_WORDS = words;
    for (int i = 0; i < 4; i++) {
      for (int l = 0; l < words.length; l++) {
        var word = words[l];

        while (word.isNotEmpty) {
          int len = min(
              i == 0
                  ? 2
                  : (i == 1 ? 3 : (i == 2 ? 4 : Random().nextInt(1) + 2)),
              word.length);
          wordParts.add(word.substring(0, len));
          word = word.substring(len);
        }
      }
    }
    for (int i = 0; i < words.length; i++) {
      for (int j = 0; j < words[i].length; j++) {
        final char = words[i].substring(j, j + 1);
        if (!listCharacters.contains(char)) {
          listCharacters.add(char);
        }
      }
    }
  }

  static String getRandomWordPart({length = -1}) {
    String word = wordParts[Random().nextInt(wordParts.length)];
    if (length == -1) return word;
    while (word.length != length) {
      word = wordParts[Random().nextInt(wordParts.length)];
    }
    return word;
  }

  static int getRandomCharacterCode() {
    bool shouldRandom = Random().nextBool();
    if (shouldRandom) {
      return game_utils.Utils.getRandomCharacterCode(listCharacters);
    }
    final word = GameConstants.getRandomWordPart(length: 1);
    return game_utils.Utils.getCharCode(word);
  }
}
