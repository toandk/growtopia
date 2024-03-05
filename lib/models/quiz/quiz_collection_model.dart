import 'package:growtopia/models/quiz/quiz_model.dart';

class QuizCollectionModel {
  String? id;
  String? name;
  String? cover;
  String? description;
  bool? isPremium;
  int? numberOfQuestions;
  List<QuizModel> quizzes = [];

  QuizCollectionModel(
      {this.id,
      this.name,
      this.cover,
      this.description,
      this.isPremium,
      this.numberOfQuestions});

  QuizCollectionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    cover = json['cover'];
    description = json['description'];
    isPremium = json['is_premium'];
    numberOfQuestions = json['number_of_questions'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['cover'] = cover;
    data['description'] = description;
    data['is_premium'] = isPremium;
    data['number_of_questions'] = numberOfQuestions;
    return data;
  }
}
