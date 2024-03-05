import 'package:flutter/material.dart';
import 'package:growtopia/base/networking/base/supabase_api.dart';
import 'package:growtopia/models/spelling_game/spelling_game_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighScores {
  static late final SharedPreferences prefs;
  static final highScores = List.filled(5, 0, growable: false);

  static Future<void> load() async {
    prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      int score = prefs.getInt('score$i') ?? 0;
      highScores[i] = score;
    }
  }

  static Future<void> saveNewScore(int score) async {
    final game = SpellingGameModel(id: 'doodle_jump', type: 'doodle_jump');
    try {
      await SupabaseAPI.querySql(functionName: 'update_played_game', params: {
        'points': score,
        'gtype': 'doodle_jump',
        'gid': 'doodle_jump'
      });
    } catch (error) {
      debugPrint('update score error $error');
    }
  }
}
