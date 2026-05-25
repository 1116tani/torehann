// lib/models/result_model.dart

class AdventureResult {
  // ── 基本情報 ──────────────────────────
  final String id;
  final String title;
  final String subTitle;
  final DateTime completedAt;

  // ── AI冒険譚 ─────────────────────────
  final String aiStory;
  final String closingMessage;

  // ── ステータス ───────────────────────
  final double distanceKm;
  final int steps;
  final int calories;
  final int durationMinutes;
  final int fragmentCount;
  final int expGained;

  // ── 表示用データ ─────────────────────
  final String weather;
  final String themeIcon;

  // ── 写真・マップ ─────────────────────
  final String routeMapImageUrl;
  final List<ResultPhoto> photos;

  // ── フレンド ─────────────────────────
  final List<ResultFriend> friends;

  const AdventureResult({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.completedAt,
    required this.aiStory,
    required this.closingMessage,
    required this.distanceKm,
    required this.steps,
    required this.calories,
    required this.durationMinutes,
    required this.fragmentCount,
    required this.expGained,
    required this.weather,
    required this.themeIcon,
    required this.routeMapImageUrl,
    required this.photos,
    required this.friends,
  });

  // ── ダミーデータ生成用 ─────────────────
  factory AdventureResult.dummy() {
    return AdventureResult(
      id: 'result_001',

      title: '星灯りの古書街探索録',

      subTitle: '雨上がりの路地に眠る、静かな記憶を辿った。',

      completedAt: DateTime.now(),

      aiStory:
          '''
雨の止んだ石畳には、
まだ夜の気配が少し残っていた。

君たちは古いランプの灯りを辿りながら、
静かな古書街を歩いていく。

小さなパン屋から漂う香り。
閉じかけた喫茶店。
細い路地に咲く紫陽花。

寄り道ばかりの旅だったけれど、
それでも確かに、
今日だけの物語がそこにあった。
''',

      closingMessage: '「寄り道は、きっと無駄じゃない。」',

      distanceKm: 4.2,

      steps: 8421,

      calories: 221,

      durationMinutes: 68,

      fragmentCount: 3,

      expGained: 120,

      weather: '☔ 雨上がり',

      themeIcon: '📚',

      routeMapImageUrl:
          'https://images.unsplash.com/photo-1526772662000-3f88f10405ff',

      photos: [
        ResultPhoto(
          imageUrl:
              'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee',
          caption: '古いランプが静かに灯っていた。',
        ),

        ResultPhoto(
          imageUrl:
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085',
          caption: '雨上がりのパン屋から、甘い香りがした。',
        ),

        ResultPhoto(
          imageUrl:
              'https://images.unsplash.com/photo-1511920170033-f8396924c348',
          caption: '最後に立ち寄った小さな喫茶店。',
        ),
      ],

      friends: const [
        ResultFriend(
          id: 'friend_001',
          name: 'ユナ',
        ),

        ResultFriend(
          id: 'friend_002',
          name: 'レオ',
        ),
      ],
    );
  }
}

// ─────────────────────────────────────
// 📸 写真モデル
// ─────────────────────────────────────

class ResultPhoto {
  final String imageUrl;
  final String caption;

  const ResultPhoto({
    required this.imageUrl,
    required this.caption,
  });
}

// ─────────────────────────────────────
// 👥 フレンドモデル
// ─────────────────────────────────────

class ResultFriend {
  final String id;
  final String name;
  final String? avatarUrl;

  const ResultFriend({
    required this.id,
    required this.name,
    this.avatarUrl,
  });
}