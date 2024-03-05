import 'package:growtopia/models/spelling_game/spelling_exercise_model.dart';

class SpellingGameModel {
  String? id;
  String? name;
  String? description;
  String? cover;
  String? type;
  List<String>? words;
  List<SpellingExerciseModel>? exercises;
  bool? isPremium;

  SpellingGameModel(
      {this.id,
      this.name,
      this.description,
      this.cover,
      this.type,
      this.words,
      this.exercises,
      this.isPremium});

  SpellingGameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    cover = json['cover'];
    type = json['type'];
    words = json['words'].cast<String>();
    if (json['exercises'] != null) {
      exercises = <SpellingExerciseModel>[];
      json['exercises'].forEach((v) {
        exercises?.add(SpellingExerciseModel.fromJson(v));
      });
    }
    isPremium = json['is_premium'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['cover'] = cover;
    data['type'] = type;
    data['words'] = words;
    if (exercises != null) {
      data['exercises'] = exercises?.map((v) => v.toJson()).toList();
    }
    data['is_premium'] = isPremium;
    return data;
  }
}
