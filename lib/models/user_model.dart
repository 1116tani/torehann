//lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final int level;
  final int exp;
  final String rank;
  final List<String> hobbyTags; // 趣味タグ（AIプロンプトに使う）

  const UserModel({
    required this.id,
    required this.name,
    this.level = 1,
    this.exp = 0,
    this.rank = '見習い冒険者',
    this.hobbyTags = const [],
  });

  // FirestoreのMapからUserModelを作る
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      level: map['level'] ?? 1,
      exp: map['exp'] ?? 0,
      rank: map['rank'] ?? '見習い冒険者',
      hobbyTags: List<String>.from(map['hobbyTags'] ?? []),
    );
  }

  // FirestoreにMapとして保存する
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'exp': exp,
      'rank': rank,
      'hobbyTags': hobbyTags,
    };
  }
}
