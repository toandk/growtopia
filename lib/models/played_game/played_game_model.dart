import 'package:growtopia/models/user/user_model.dart';

class PlayedGameModel {
  int? id;
  int? score;
  String? type;
  int? level;
  UserModel? user;
  int? rank = 0;

  PlayedGameModel(
      {this.id, this.score, this.type, this.level, this.user, this.rank});

  PlayedGameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    score = json['score'];
    type = json['type'];
    level = json['level'];
    user = json['user_info'] != null
        ? UserModel.fromJson(json['user_info'])
        : null;
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['score'] = score;
    data['type'] = type;
    data['level'] = level;
    data['user_info'] = user?.toJson();
    data['rank'] = rank;
    return data;
  }
}
