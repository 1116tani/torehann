// lib/models/fragment_model.dart

class FragmentModel {
  final String id;
  final String title; // 断片のタイトル（例：雨上がりの記憶、夕暮れの路地裏）
  final String content; // AIが書いたエモーショナルなフレーバーテキスト [cite: 93]
  final String locationName; // この断片を見つけた場所の名前
  final String? photoUrl; // 写真ピンとして撮影した画像のURL（ない場合もあるから ? をつけてnull許容）
  final String rarity; // レアリティ（'normal', 'rare', 'legend'）
  final DateTime? collectedAt; // この断片を手に入れた日時

  const FragmentModel({
    required this.id,
    required this.title,
    required this.content,
    required this.locationName,
    this.photoUrl,
    this.rarity = 'normal', // デフォルトはノーマルに設定
    this.collectedAt,
  });

  // FirestoreのMapからFragmentModelを作る
  factory FragmentModel.fromMap(Map<String, dynamic> map) {
    // 日付データの安全な変換
    DateTime? parsedDate;
    if (map['collectedAt'] != null) {
      parsedDate = (map['collectedAt'] as dynamic).toDate();
    }

    return FragmentModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '名もなき記憶',
      content: map['content'] ?? '',
      locationName: map['locationName'] ?? 'どこかの街角',
      photoUrl: map['photoUrl'], // nullが入ってきてもそのまま受け入れるよ
      rarity: map['rarity'] ?? 'normal',
      collectedAt: parsedDate,
    );
  }

  // FirestoreにMapとして保存する
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'locationName': locationName,
      'photoUrl': photoUrl,
      'rarity': rarity,
      'collectedAt': collectedAt,
    };
  }
}
