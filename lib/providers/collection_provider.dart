// lib/providers/collection_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fragment_model.dart';
import '../repositories/fragment_repository.dart';
import 'auth_provider.dart';

final fragmentRepositoryProvider = Provider<FragmentRepository>((ref) {
  return FragmentRepository();
});

/// ── 💡 ユーザーのFirestore所持データ（スタック数）を監視するStreamProvider ──
final userInventoryProvider = StreamProvider.autoDispose<Map<String, FragmentModel>>((ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  final userId = user?.uid ?? 'dummy_user_123';
  return ref.watch(fragmentRepositoryProvider).watchFragments(userId).map((list) {
    return {for (final f in list) f.itemMasterId: f};
  });
});

/// ── 💡 17種類の宝物マスタデータ＆ユーザーの所持状況を完全統合するProvider ──
final collectionListProvider = Provider.autoDispose<List<CollectionItemUIModel>>((ref) {
  final inventoryAsync = ref.watch(userInventoryProvider);
  final inventory = inventoryAsync.value ?? const <String, FragmentModel>{};

  // 17種類のテキストデータ！
  return [
    // 🟢 ノーマル（6種：1 / 3 / 5 解放）
    _buildNormal('item_01', '始まりの木の枝', [
      '公園の片隅に落ちていた、何の変哲もない小さな枝。それでも、拾い上げた理由はあるはずだ。',
      '手に持つと、今日歩いた距離のぶんだけ、ほんのり温もりを感じる気がする。',
      '地図に載っていない路地を指し示し、「こっちも悪くないよ」と背中を押してくれる、小さな道標。'
    ], inventory),
    _buildNormal('item_02', '幸運の10円硬貨', [
      '自販機の下や、歩いている途中にポロッと落ちていた古い銅貨。磨けばきっと平等院が見える。',
      '街の灯りや月明かりの下で、鈍い金色の輝きを放っている。誰かが落とし、誰かに拾われる——街をめぐるささやかな縁。',
      '右か左か迷ったとき、いつも正しい方向へ導いてくれる気がする。ルートの分岐点で、そっと背中を押す通貨。'
    ], inventory),
    _buildNormal('item_03', '迷い鳥の羽', [
      '通学路や見慣れた道で見つけた、どこかの鳥が落としていった軽やかな一枚。',
      '空の高さを知る者だけが持てる、地上の「別のルート」を感じ取る嗅覚。',
      '「今日はここじゃないかも」という直感を、ちゃんと信じさせてくれる羽根。日常から抜け出す最初の一歩を後押しする。'
    ], inventory),
    _buildNormal('item_04', '奇跡のレシート', [
      'ポケットの奥でくしゃくしゃになっていた、小さなお店のレシート。日付と金額しか読めない。',
      '偶然立ち寄った場所の記憶が、数字と文字で静かに刻まれている。レシートは、ちゃんとそこにいた証拠だ。',
      '「寄り道してよかった」という小さな確信を積み重ねるほど、次の寄り道への一歩が軽くなる護符。'
    ], inventory),
    _buildNormal('item_05', '破られた白地図', [
      'ノートの端切れのような紙片。走り書きがあって、もう読めない。',
      'よく見ると、この街のどこかの路地裏の形に似ている気がする。誰かが歩いた跡かもしれない。',
      'まだ誰にも歩かれていない場所が、この街には必ずある。空白は、まだ書かれていないルートの余白だ。'
    ], inventory),
    _buildNormal('item_06', '絆のウォーキングシューズ', [
      'ソールが少しすり減った、履き慣れたスニーカー。見た目よりずっと頼りになる。',
      '今日まで何万歩も一緒に歩いてくれた。すり減ったぶんだけ、この街を知っている。',
      '「もう一駅手前で降りてみよう」そう思わせてくれるのは、いつもこの靴だ。歩き続けるための、いちばん身近な相棒。'
    ], inventory),

    // 🔵 レア（8種：1 / 2 / 3 解放 / スポット・条件連動）
    _buildRare('item_07', '社の御守札', '神社・寺', [
      '境内の片隅で見つけた、古びた小さな守り札。誰かが結んで、そのまま忘れていったのかもしれない。',
      'ここを訪れた人の数だけ、祈りが染み込んでいる。歩いてここまで来たこと自体が、ひとつの参拝だ。',
      '神域の静けさを携えて歩く者に、迷いのない足取りを与える。どんな路地も、恐れずに踏み込める。'
    ], inventory),
    _buildRare('item_08', '転移切符', '駅・交通', [
      '改札の隅に落ちていた、行き先が滲んで読めなくなった古い切符。',
      '乗り換え案内に従わなかった日の記憶が、じわりと浮かぶ。あの駅で降りなければ、あの路地は知らなかった。',
      '「ひとつ手前で降りる」——それだけで街は別の顔を見せる。どこへでも繋がる、最短ルートを外す自由の切符。'
    ], inventory),
    _buildRare('item_09', '迷宮の魔導書', '本屋・図書館', [
      '棚の奥で埃をかぶっていた、タイトルも著者も消えかけた薄い本。',
      '開いてみると、この街の地名がちらほら出てくる。誰かがここを舞台に、物語を書いていたのかもしれない。',
      'AIが紡ぐ冒険譚の源泉。街を歩くことと物語を読むことは、本来おなじ行為だったのかもしれない。'
    ], inventory),
    _buildRare('item_10', 'カフェのスタンプカード', 'カフェ・喫茶', [
      'お気に入りの寄り道先で手に入れた、端が折れた紙のカード。スタンプが半分ほど埋まっている。',
      'スタンプひとつが「また来た」の証だ。歩いた回数が増えるほど、この街に居場所が増えていく。',
      '疲れたとき「あそこに寄ろう」と思える場所がある。それだけで、もう少し歩き続けられる。旅人の、心の補給ポイント。'
    ], inventory),
    _buildRare('item_11', '黄昏の硝子玉', '夕方17時以降', [
      '道端で見つけた、夕日に透かすと薄紫に輝くガラスの欠片。誰かが落としたものだろう。',
      '17時以降の光の角度でしか見えない色がある。この街は、夕方にだけ別の顔を見せる。',
      '昼間には気づかなかった看板、路地、にじむネオン。夕暮れに歩く者だけが見つけられる、街の隠れた表情を映す結晶。'
    ], inventory),
    _buildRare('item_12', '雨粒の小瓶', '雨天', [
      '雨の日にだけ現れる、小さな透明の小瓶。中に雨粒がひとつ、揺れている。',
      '雨に濡れた石畳、軒先のにおい、傘の隙間から見える空。雨の街は、晴れの街とは違う物語を持っている。',
      '「雨だから家にいよう」ではなく「雨だから出かけよう」に変えてしまう、ちょっとおかしな小瓶。雨天限定の街の顔を、閉じ込めている。'
    ], inventory),
    _buildRare('item_13', '商店街の福引券', '商店・小売', [
      'シャッターが半分閉まった商店街で、風に飛ばされてきた古い福引券。',
      'かつてここは賑やかだった。その記憶が、アーケードの空気にうっすら残っている。',
      '人が歩くことで街は生きる。通り過ぎるだけでいい。それだけで、この場所の物語は続いていく。'
    ], inventory),
    _buildRare('item_14', '公園の夕暮れ石', '公園・緑地', [
      'ベンチの下に転がっていた、丸みを帯びた小さな石。誰かが持ち込んで、そのまま置いていったのかも。',
      '公園にはいつも誰かがいる。犬を連れた老人、本を読む学生、ぼんやりする会社員。みんなここで少し、立ち止まっていく。',
      '急がなくていい場所が、街にはある。この石を持つ者はなぜか、ルートの途中でちゃんと休める。'
    ], inventory),

    // 🟡 レジェンド（3種：1回で全文解放）
    _buildLegend('item_15', '絆の編纂珠', 
      'それはデータや数値では測れない、あなたの「歩みと出会い」が結晶化したもの。\n今日まで踏んだ一歩一歩が光の軌跡として映し出され、この世界にただひとつの輝きを放つ。\nこれを手にしたとき、この街はただの背景ではなく——あなただけが知っている、特別な「記憶の地図」になる。', 
      inventory),
    _buildLegend('item_16', '境界のスマートフォン', 
      '現実の街と、AIが紡ぎだす冒険の物語をつなぐ、出所不明の不思議なデバイス。\n画面に触れるたびに、それは地図にも、コンパスにも、日記にも姿を変える。\nありふれた帰り道を大冒険に変え、通り過ぎるだけだった景色に名前と物語を与える——これがなければ、Tale Trace はただの移動だった。', 
      inventory),
    _buildLegend('item_17', 'この街の記憶地図', 
      '誰かが長い年月をかけて歩き、書き足し続けた地図。印刷された道路ではなく、足で刻んだ記憶で描かれている。\n色付いた道、立ち止まった場所、写真を撮った瞬間——それがそのまま、あなただけの地図になっていく。\nどんな地図アプリにも載っていない「あなたの街」が、ここにある。', 
      inventory),
  ];
});

/// ── 🎨 UI表示用に最適化したアイテム情報モデル ──
class CollectionItemUIModel {
  final String id;
  final String name;
  final FragmentRarity rarity;
  final String? conditionHint;
  final List<String> descriptions;
  final List<int> thresholds;
  final FragmentModel? userDate; // ユーザーが持っている場合、そのデータが入るよ

  CollectionItemUIModel({
    required this.id,
    required this.name,
    required this.rarity,
    this.conditionHint,
    required this.descriptions,
    required this.thresholds,
    this.userDate,
  });

  bool get isUnlocked => (userDate?.stackCount ?? 0) > 0;
  int get currentCount => userDate?.stackCount ?? 0;

  // 段階ごとのロック状態を判定するよ
  bool isStageUnlocked(int index) {
    if (rarity == FragmentRarity.legend) return isUnlocked;
    if (index >= thresholds.length) return false;
    return currentCount >= thresholds[index];
  }

  // UI用の進捗文字列（例: "2 / 5"）を生成
  String get progressString {
    if (rarity == FragmentRarity.legend) return isUnlocked ? '1 / 1' : '0 / 1';
    final maxTarget = thresholds.last;
    return '${currentCount.clamp(0, maxTarget)} / $maxTarget';
  }
}

// 以下、マスタからUIモデルを安全に組み立てるヘルパー関数たち
CollectionItemUIModel _buildNormal(String id, String name, List<String> descs, Map<String, FragmentModel> inv) {
  return CollectionItemUIModel(
    id: id, name: name, rarity: FragmentRarity.normal,
    descriptions: descs, thresholds: const [1, 3, 5], userDate: inv[id],
  );
}

CollectionItemUIModel _buildRare(String id, String name, String hint, List<String> descs, Map<String, FragmentModel> inv) {
  return CollectionItemUIModel(
    id: id, name: name, rarity: FragmentRarity.rare, conditionHint: hint,
    descriptions: descs, thresholds: const [1, 2, 3], userDate: inv[id],
  );
}

CollectionItemUIModel _buildLegend(String id, String name, String desc, Map<String, FragmentModel> inv) {
  return CollectionItemUIModel(
    id: id, name: name, rarity: FragmentRarity.legend,
    descriptions: [desc], thresholds: const [1], userDate: inv[id],
  );
}