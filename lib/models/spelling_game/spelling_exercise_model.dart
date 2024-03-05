class SpellingExerciseModel {
  int? id;
  String? spellingGameId;
  String? word;
  String? photo;
  String? voice;
  List<String>? answers;
  int? correctAnswer;
  int? missingIndex;
  int? missingLength;
  int? time;

  SpellingExerciseModel(
      {this.id,
      this.spellingGameId,
      this.word,
      this.photo,
      this.voice,
      this.answers,
      this.correctAnswer,
      this.missingIndex,
      this.missingLength,
      this.time});

  SpellingExerciseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    spellingGameId = json['spelling_game_id'];
    word = json['word'];
    photo = json['photo'];
    voice = json['voice'];
    answers = json['answers'].cast<String>();
    correctAnswer = json['correct_answer'];
    missingIndex = json['missing_index'];
    missingLength = json['missing_length'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['spelling_game_id'] = spellingGameId;
    data['word'] = word;
    data['photo'] = photo;
    data['voice'] = voice;
    data['answers'] = answers;
    data['correct_answer'] = correctAnswer;
    data['missing_index'] = missingIndex;
    data['missing_length'] = missingLength;
    data['time'] = time;
    return data;
  }
}
