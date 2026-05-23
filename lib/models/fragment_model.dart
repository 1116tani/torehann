// lib/models/fragment_model.dart

/// 宝物のレアリティを定義する列挙型だよ
enum FragmentRarity { normal, rare, legend }

class FragmentModel {
  final String id;           // ユーザーが所持しているこのデータ自体の固有ID
  final String itemMasterId; // マスターデータ(item_01〜item_17)への紐付けID 👈 コレが超重要！
  final int stackCount;      // この宝物を何個拾ったか（スタック数） 👈 コレで段階解放を管理！
  final FragmentRarity rarity; // レアリティ
  final String locationName; // 初めて（または直近で）この断片を見つけた場所の名前
  final String? photoUrl;    // 写真ピンとして撮影した画像のURL
  final DateTime? collectedAt; // 最初に手に入れた日時

  const FragmentModel({
    required this.id,
    required this.itemMasterId,
    this.stackCount = 1,     // 最初に見つけたらカウントは 1 だよ
    required this.rarity,
    required this.locationName,
    this.photoUrl,
    this.collectedAt,
  });

  /// コピー用のメソッド（同じアイテムを拾ってスタック数を＋1するときに使うよ♡）
  FragmentModel copyWith({
    String? id,
    String? itemMasterId,
    int? stackCount,
    FragmentRarity? rarity,
    String? locationName,
    String? photoUrl,
    DateTime? collectedAt,
  }) {
    return FragmentModel(
      id: id ?? this.id,
      itemMasterId: itemMasterId ?? this.itemMasterId,
      stackCount: stackCount ?? this.stackCount,
      rarity: rarity ?? this.rarity,
      locationName: locationName ?? this.locationName,
      photoUrl: photoUrl ?? this.photoUrl,
      collectedAt: collectedAt ?? this.collectedAt,
    );
  }

  /// FirestoreのMapからFragmentModelを作る
  factory FragmentModel.fromMap(Map<String, dynamic> map) {
    DateTime? parsedDate;
    if (map['collectedAt'] != null) {
      // Timestamp型からの安全な変換
      parsedDate = (map['collectedAt'] as dynamic).toDate();
    }

    return FragmentModel(
      id: map['id'] ?? '',
      itemMasterId: map['itemMasterId'] ?? '', // 👈 安全に受け取るよ
      stackCount: map['stackCount'] ?? 1,      // 👈 データがない場合は1にするよ
      rarity: _parseRarity(map['rarity']),
      locationName: map['locationName'] ?? 'どこかの街角',
      photoUrl: map['photoUrl'],
      collectedAt: parsedDate,
    );
  }

  static FragmentRarity _parseRarity(dynamic value) {
    if (value is String) {
      return FragmentRarity.values.firstWhere(
        (rarity) => rarity.name == value,
        orElse: () => FragmentRarity.normal,
      );
    }
    return FragmentRarity.normal;
  }

  /// FirestoreにMapとして保存する
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemMasterId': itemMasterId, // 👈 忘れずに保存！
      'stackCount': stackCount,     // 👈 忘れずに保存！
      'rarity': rarity.name,        // 👈 レアリティを文字列で保存
      'locationName': locationName,
      'photoUrl': photoUrl,
      'collectedAt': collectedAt,
    };
  }
}