// lib/providers/collection_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ── レアリティの定義 ──
enum ItemRarity { normal, rare, legend }

/// ── アイテムのデータ構造 ──
class CollectionItemModel {
  final String id;
  final String name;
  final ItemRarity rarity;
  final List<String> descriptions; // ノーマル・レアの段階テキスト
  final List<int> unlockThresholds; // 解放に必要なスタック数（例：[1, 3, 5]）
  final String? legendDescription; // レジェンド用の専用テキスト
  final int currentCount; // ユーザーが現在持っている数

  CollectionItemModel({
    required this.id,
    required this.name,
    required this.rarity,
    this.descriptions = const [],
    this.unlockThresholds = const [],
    this.legendDescription,
    required this.currentCount,
  });

  // 1個でも持っていれば取得済み
  bool get isUnlocked => currentCount > 0;

  // 段階解放の状況を判定するお助けメソッド
  bool isStageUnlocked(int stageIndex) {
    if (rarity == ItemRarity.legend) return isUnlocked;
    if (stageIndex >= unlockThresholds.length) return false;
    return currentCount >= unlockThresholds[stageIndex];
  }

  // 次の解放までに必要な数を計算するよ
  int? get nextTargetCount {
    if (rarity == ItemRarity.legend) return null;
    for (int threshold in unlockThresholds) {
      if (currentCount < threshold) return threshold;
    }
    return null; // 全部解放済みならnull
  }
}

/// ── 💡 ユーザーの所持アイテム数（スタック）を管理するダミーProvider ──
/// 本番はFirestoreのサブコレクションなどからStreamで取得してね！
final userInventoryProvider = Provider.autoDispose<Map<String, int>>((ref) {
  // みぃくんがテストしやすいように、いくつか持っている状態にしておくね！
  return {
    'item_branch': 4, // 古の枝を4つ（段階2まで解放！）
    'item_feather': 1, // 風読みの羽を1つ
    'item_coin': 2, // 月光のコインを2つ（レア、段階2まで解放！）
    'item_orb': 1, // 心の宝珠（レジェンド解放！）
  };
});

/// ── 💡 マスタデータと所持数を結びつける全知全能のProvider ──
final collectionListProvider = Provider.autoDispose<List<CollectionItemModel>>((
  ref,
) {
  final inventory = ref.watch(userInventoryProvider);

  // みぃくんが考えた最高にエモいアイテムたちだよ！
  return [
    // 🟢 ノーマル（6種）解放：1 / 3 / 5
    CollectionItemModel(
      id: 'item_branch',
      name: '古の枝',
      rarity: ItemRarity.normal,
      unlockThresholds: [1, 3, 5],
      descriptions: [
        '古びた枝。微かに温もりを感じる。',
        'かつて術者が手にしていたと伝わる枝。',
        '持つ者に知恵と導きを与える古代の遺物。',
      ],
      currentCount: inventory['item_branch'] ?? 0,
    ),
    CollectionItemModel(
      id: 'item_cloak',
      name: '旅人のマント',
      rarity: ItemRarity.normal,
      unlockThresholds: [1, 3, 5],
      descriptions: [
        '擦り切れたマント。風をよく通す。',
        '多くの旅路を越えてきた証が刻まれている。',
        '羽織る者をあらゆる地へ導く冒険者の象徴。',
      ],
      currentCount: inventory['item_cloak'] ?? 0,
    ),
    CollectionItemModel(
      id: 'item_feather',
      name: '風読みの羽',
      rarity: ItemRarity.normal,
      unlockThresholds: [1, 3, 5],
      descriptions: [
        '軽やかな羽。風に乗って揺れる。',
        '空を知る者が落としたと言われる羽根。',
        '風の流れを感じ取り、進むべき道を示す。',
      ],
      currentCount: inventory['item_feather'] ?? 0,
    ),
    CollectionItemModel(
      id: 'item_amulet',
      name: '小さな護符',
      rarity: ItemRarity.normal,
      unlockThresholds: [1, 3, 5],
      descriptions: ['手のひらサイズの古い護符。', '災いを遠ざける力が宿るとされる。', '見えぬ危機から持ち主を守るお守り。'],
      currentCount: inventory['item_amulet'] ?? 0,
    ),
    CollectionItemModel(
      id: 'item_document',
      name: '古文書の欠片',
      rarity: ItemRarity.normal,
      unlockThresholds: [1, 3, 5],
      descriptions: [
        '破れた紙片。文字は読めない。',
        '断片的に古い記録が残されている。',
        '失われた知識の一部。世界の秘密に繋がる。',
      ],
      currentCount: inventory['item_document'] ?? 0,
    ),
    CollectionItemModel(
      id: 'item_shoes',
      name: '旅路の靴',
      rarity: ItemRarity.normal,
      unlockThresholds: [1, 3, 5],
      descriptions: ['使い古された靴。歩きやすい。', '長い旅を支えてきた頑丈な作り。', 'どこまでも歩き続けられる意思の象徴。'],
      currentCount: inventory['item_shoes'] ?? 0,
    ),

    // 🔵 レア（4種）解放：1 / 2 / 3
    CollectionItemModel(
      id: 'item_crystal',
      name: '紫晶の欠片',
      rarity: ItemRarity.rare,
      unlockThresholds: [1, 2, 3],
      descriptions: ['紫に輝く小さな結晶。', '魔力を帯びているとされる鉱石。', '強い力を秘めた神秘の結晶体。'],
      currentCount: inventory['item_crystal'] ?? 0,
    ),
    CollectionItemModel(
      id: 'item_sword',
      name: '錆びた英雄剣',
      rarity: ItemRarity.rare,
      unlockThresholds: [1, 2, 3],
      descriptions: ['錆びついた古い剣。', 'かつて英雄が振るったと語られる。', '時を越えてもなお意志を宿す伝説の剣。'],
      currentCount: inventory['item_sword'] ?? 0,
    ),
    CollectionItemModel(
      id: 'item_coin',
      name: '月光のコイン',
      rarity: ItemRarity.rare,
      unlockThresholds: [1, 2, 3],
      descriptions: ['銀色に光る古いコイン。', '月明かりの下で輝きを増す。', '夜の導きを象徴する神秘の通貨。'],
      currentCount: inventory['item_coin'] ?? 0,
    ),
    CollectionItemModel(
      id: 'item_shield',
      name: '守りの盾',
      rarity: ItemRarity.rare,
      unlockThresholds: [1, 2, 3],
      descriptions: ['小ぶりな盾。傷が多い。', '多くの攻撃を受け止めてきた形跡。', 'あらゆる脅威から持ち主を守る堅牢な盾。'],
      currentCount: inventory['item_shield'] ?? 0,
    ),

    // 🟡 レジェンド（2種）解放：1回で全文
    CollectionItemModel(
      id: 'item_orb',
      name: '心の宝珠',
      rarity: ItemRarity.legend,
      legendDescription:
          'それは形を持たぬはずの“想い”が結晶化したもの。\n持つ者の歩みと記憶を映し出し、世界にただ一つの輝きを放つ。\nそれを見つけた者は、もはや旅人ではなく“物語そのもの”となる。',
      currentCount: inventory['item_orb'] ?? 0,
    ),
    CollectionItemModel(
      id: 'item_relic',
      name: '名もなき遺物',
      rarity: ItemRarity.legend,
      legendDescription:
          'どこで生まれ、誰が遺したのかすら分からない存在。\n触れた者によって意味を変え、その価値は無限に揺らぐ。\nそれは世界の理すら逸脱した、“名付けられなかった奇跡”。',
      currentCount: inventory['item_relic'] ?? 0,
    ),
  ];
});
