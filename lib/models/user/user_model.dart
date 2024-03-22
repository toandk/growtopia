class UserModel {
  String? id;
  String? name;
  String? avatarUrl;
  bool? isTeacher;
  String? email;
  bool? havePassword;
  int waters = 0;
  int fruits = 0;

  UserModel(
      {this.id,
      this.name,
      this.avatarUrl,
      this.isTeacher,
      this.email,
      this.havePassword,
      this.waters = 0,
      this.fruits = 0});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    avatarUrl = json['avatar_url'];
    isTeacher = json['is_teacher'];
    email = json['email'];
    havePassword = json['have_password'];
    waters = json['drops'] ?? 0;
    fruits = json['fruits'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar_url'] = avatarUrl;
    data['is_teacher'] = isTeacher;
    data['email'] = email;
    data['have_password'] = havePassword;
    data['drops'] = waters;
    data['fruits'] = fruits;
    return data;
  }
}
