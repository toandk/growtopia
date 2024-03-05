class QuizModel {
  int? id;
  String? question;
  String? photo;
  String? voice;
  String? collectionId;
  int? time;
  List<String>? answers;
  List? correctAnswers;
  bool? isPremium;
  bool isLongAnswer = false;

  QuizModel(
      {this.id,
      this.question,
      this.photo,
      this.voice,
      this.time,
      this.answers,
      this.collectionId,
      this.correctAnswers,
      this.isLongAnswer = false,
      this.isPremium});

  QuizModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    photo = json['photo'];
    voice = json['voice'];
    time = json['time'];
    collectionId = json['quiz_collection_id'];
    answers = json['answers']?.cast<String>();
    correctAnswers = json['correct_answers']
        ?.cast<String>()
        ?.map((e) => int.parse(e))
        .toList();
    isPremium = json['is_premium'];
    isLongAnswer = json['is_long_answer'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['question'] = question;
    data['photo'] = photo;
    data['voice'] = voice;
    data['time'] = time;
    data['answers'] = answers;
    data['quiz_collection_id'] = collectionId;
    data['correct_answers'] = correctAnswers;
    data['is_premium'] = isPremium;
    data['is_long_answer'] = isLongAnswer;
    return data;
  }
}
