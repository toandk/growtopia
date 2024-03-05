import 'package:get/get.dart';
import 'package:growtopia/generated/locales.g.dart';

class ShopItemModel {
  int? id;
  String? name;
  String? description;
  List? photos;
  String? rarity;
  int? price;
  int? growTime;

  ShopItemModel(
      {this.id,
      this.name,
      this.description,
      this.photos,
      this.rarity,
      this.price,
      this.growTime});

  ShopItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    photos = json['photos'];
    rarity = json['rarity'];
    price = json['price'];
    growTime = json['grow_time'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['photos'] = photos;
    data['rarity'] = rarity;
    data['price'] = price;
    data['grow_time'] = growTime;

    return data;
  }

  String priceString() {
    return price == 0 ? LocaleKeys.shop_free.tr : '💧${price ?? 0}';
  }
}
