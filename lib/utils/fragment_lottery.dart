import 'dart:math';
import '../models/fragment_model.dart';

class FragmentLottery {
  static final Random _random = Random();

  /// 冒険の状況に応じて街の断片を抽選するよ
  static List<FragmentModel> draw({
    required String weather,
    required DateTime time,
    required List<String> visitedSpotCategories,
    required String lastLocationName,
  }) {
    final List<String> candidateIds = [];

    // 🟢 ノーマル枠（常に抽選対象）
    candidateIds.addAll([
      'item_01', // 始まりの木の枝
      'item_02', // 幸運の10円硬貨
      'item_03', // 迷い鳥の羽
      'item_04', // 奇跡のレシート
      'item_05', // 破られた白地図
      'item_06', // 絆のウォーキングシューズ
    ]);

    // 🔵 レア枠（条件に応じて追加）
    if (visitedSpotCategories.contains('神社') || visitedSpotCategories.contains('寺')) {
      candidateIds.add('item_07'); // 社の御守札
    }
    if (visitedSpotCategories.contains('駅') || visitedSpotCategories.contains('交通')) {
      candidateIds.add('item_08'); // 転移切符
    }
    if (visitedSpotCategories.contains('本屋') || visitedSpotCategories.contains('図書館')) {
      candidateIds.add('item_09'); // 迷宮の魔導書
    }
    if (visitedSpotCategories.contains('カフェ') || visitedSpotCategories.contains('喫茶')) {
      candidateIds.add('item_10'); // カフェのスタンプカード
    }
    if (time.hour >= 17 || time.hour < 5) {
      candidateIds.add('item_11'); // 黄昏の硝子玉
    }
    if (weather.contains('雨')) {
      candidateIds.add('item_12'); // 雨粒の小瓶
    }
    if (visitedSpotCategories.contains('商店街') || visitedSpotCategories.contains('店')) {
      candidateIds.add('item_13'); // 商店街の福引券
    }
    if (visitedSpotCategories.contains('公園') || visitedSpotCategories.contains('緑地')) {
      candidateIds.add('item_14'); // 公園の夕暮れ石
    }

    // 🟡 レジェンド枠（TODO: 実装のみ、条件は未定なので低確率で出現させるか、一旦除外）
    // 今回は抽選に含めない

    // 1〜3個をランダムに選択
    final count = _random.nextInt(3) + 1;
    final selectedIds = <String>{};
    
    // 候補が足りない場合は全部出す
    final targetCount = min(count, candidateIds.length);
    
    while (selectedIds.length < targetCount) {
      final id = candidateIds[_random.nextInt(candidateIds.length)];
      selectedIds.add(id);
    }

    return selectedIds.map((id) {
      final rarity = _getRarityFromId(id);
      return FragmentModel(
        id: 'drawn_${DateTime.now().millisecondsSinceEpoch}_$id',
        itemMasterId: id,
        rarity: rarity,
        locationName: lastLocationName,
        collectedAt: DateTime.now(),
      );
    }).toList();
  }

  static FragmentRarity _getRarityFromId(String id) {
    final index = int.tryParse(id.replaceFirst('item_', '')) ?? 0;
    if (index <= 6) return FragmentRarity.normal;
    if (index <= 14) return FragmentRarity.rare;
    return FragmentRarity.legend;
  }
}
