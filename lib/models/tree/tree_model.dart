class TreeModel {
  int? id;
  String? name;
  int? itemId;
  String? userId;
  List? photos;
  String? rarity;
  int? level;
  int? health;
  int? growTime;
  String? plantedAt;
  List? waterList;
  List? levelUpTimes;
  DateTime? levelUpTime;
  int waterCount = 0;
  String? rewardCard;

  TreeModel(
      {this.id,
      this.name,
      this.itemId,
      this.userId,
      this.photos,
      this.rarity,
      this.level,
      this.health,
      this.growTime,
      this.plantedAt,
      this.waterList,
      this.levelUpTimes,
      this.levelUpTime,
      this.waterCount = 0,
      this.rewardCard});

  TreeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    itemId = json['item_id'];
    userId = json['user_id'];
    photos = json['photos'];
    rarity = json['rarity'];
    level = json['level'];
    health = json['health'];
    growTime = json['grow_time'];
    plantedAt = json['planted_at'];
    waterList = json['water_list'];
    levelUpTimes = json['level_up_times'];
    levelUpTime = json['level_up_time'] != null
        ? DateTime.tryParse(json['level_up_time'] ?? '')
        : DateTime.now();
    waterCount = json['water_count'] ?? 0;
    rewardCard = json['reward_card'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photos'] = photos;
    data['rarity'] = rarity;
    data['grow_time'] = growTime;
    data['health'] = health;
    data['level'] = level;
    data['user_id'] = userId;
    data['item_id'] = itemId;
    data['planted_at'] = plantedAt;
    data['water_list'] = waterList;
    data['level_up_times'] = levelUpTimes;
    data['level_up_time'] = levelUpTime;
    data['water_count'] = waterCount;
    data['reward_card'] = rewardCard;

    return data;
  }

  void levelUp(int waters) {
    level = level! + 1;
    health = health! + 1;
    waterCount = waterCount + waters;
  }

  String getPhoto(int lv) {
    final photos = this.photos ?? [];
    return isLevelingUp() && lv > 0
        ? photos[lv - 1]
        : (lv - 1 < photos.length
            ? photos[lv - 1]
            : (photos.isEmpty ? '' : photos.last));
  }

  bool isLevelingUp() {
    final now = DateTime.now();
    return levelUpTime != null && levelUpTime!.isAfter(now);
  }

  int getActualLevel() {
    return isLevelingUp() && level! > 0 ? level! - 1 : level!;
  }
}
