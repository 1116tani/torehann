// lib/providers/achievement_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ── 実績の達成ランク ──
enum AchievementRank { none, copper, silver, gold }

/// ── 実績のデータ構造モデル ──
class AchievementModel {
  final String id;
  final String title;
  final String description;
  final double currentCount; // 進捗数値
  final double copperValue; // 銅の基準
  final double silverValue; // 銀の基準
  final double goldValue; // 金の基準
  final String unit; // 単位（km, 回, 個）

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.currentCount,
    required this.copperValue,
    required this.silverValue,
    required this.goldValue,
    required this.unit,
  });

  // 現在どのランクにいるかを判定するよ
  AchievementRank get currentRank {
    if (currentCount >= goldValue) return AchievementRank.gold;
    if (currentCount >= silverValue) return AchievementRank.silver;
    if (currentCount >= copperValue) return AchievementRank.copper;
    return AchievementRank.none;
  }

  // 次の目標値を設定するよ
  double get nextThreshold {
    switch (currentRank) {
      case AchievementRank.none:
        return copperValue;
      case AchievementRank.copper:
        return silverValue;
      case AchievementRank.silver:
        return goldValue;
      case AchievementRank.gold:
        return goldValue;
    }
  }

  // 進捗バー用の割合（0.0 〜 1.0）を計算するよ
  double get progressRatio {
    if (currentCount >= goldValue) return 1.0;
    return (currentCount / nextThreshold).clamp(0.0, 1.0);
  }
}

/// ── 💡 ユーザーの生の統計データをFirestoreから引いてくるStreamProvider ──
final userStatsProvider = StreamProvider.autoDispose<Map<String, dynamic>>((
  ref,
) {
  // 本来は認証されたUIDを使うけど、デモ用に固定値にしておくね
  const dummyUserId = 'dummy_user_123';
  return FirebaseFirestore.instance
      .collection('users')
      .doc(dummyUserId)
      .collection('stats')
      .doc('counters')
      .snapshots()
      .map((doc) => doc.data() ?? {});
});

/// ── 💡 生データと実績マスタをマージして、UI用の15種の実績リストに仕立てるProvider ──
final achievementListProvider = Provider.autoDispose<List<AchievementModel>>((
  ref,
) {
  // 生データを監視
  final statsAsync = ref.watch(userStatsProvider);
  final stats = statsAsync.value ?? {};

  // 15種類の実績マスタデータ（みぃくんのリストだよ！）
  return [
    AchievementModel(
      id: 'shoyo_mujin',
      title: '逍遥無尽（しょうようむじん）',
      description: '距離を重ね、己の足跡を大地に刻む。',
      currentCount: (stats['totalDistance'] ?? 0.0).toDouble(),
      copperValue: 1.0,
      silverValue: 10.0,
      goldValue: 50.0,
      unit: 'km',
    ),
    AchievementModel(
      id: 'shushu_temmo',
      title: '蒐集天網（しゅうしゅうてんもう）',
      description: '散らばる秘宝を、余すことなく手中に収める。',
      currentCount: (stats['treasureCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 6.0,
      goldValue: 12.0,
      unit: '個',
    ),
    AchievementModel(
      id: 'manyu_sokyu',
      title: '漫遊蒼穹（まんゆうそうきゅう）',
      description: '世界を歩き、物語を紡ぎ続けた旅人。',
      currentCount: (stats['adventureCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 10.0,
      goldValue: 30.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'itsuro_tankyu',
      title: '逸路探求（いつろたんきゅう）',
      description: '誰も選ばぬ道に、価値を見出す者。',
      currentCount: (stats['newWayCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 10.0,
      goldValue: 30.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'ukai_mukyu',
      title: '迂回無窮（うかいむきゅう）',
      description: '寄り道を重ね、世界の表情を集める。',
      currentCount: (stats['spotVisitCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 10.0,
      goldValue: 20.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'dokuo_danko',
      title: '独往断行（どくおうだんこう）',
      description: '示された道を離れ、自らの意志で歩む。その選択もまた、ひとつの“冒険”である。',
      currentCount: (stats['ignoreNaviCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 10.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'kyoki_reimei',
      title: '旭暉黎明（きょきれいめい）',
      description: '夜明けとともに歩き出した者に贈られる称号。',
      currentCount: (stats['morningAdventureCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 10.0,
      goldValue: 20.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'yoiyami_angya',
      title: '宵闇行脚（よいやみあんぎゃ）',
      description: '闇の中でも歩みを止めぬ冒険者。',
      currentCount: (stats['nightAdventureCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 10.0,
      goldValue: 20.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'tenkyu_dansho',
      title: '天泣断章（てんきゅうだんしょう）',
      description: '天の涙に打たれながらも、物語を紡いだ証。',
      currentCount: (stats['rainAdventureCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 10.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'hoko_koei',
      title: '彷徨孤影（ほうこうこえい）',
      description: '孤独に迷いし冒険者。',
      currentCount: (stats['lostWayCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 10.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'kyomei_rensa',
      title: '共鳴連鎖（きょうめいれんさ）',
      description: '言葉を交じらせ、絆を紡ぐ。',
      currentCount: (stats['shareCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 10.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'teikan_biko',
      title: '諦観微光（ていかんびこう）',
      description: '退く勇気もまた、冒険者には必要な資質。その微かな悔恨が、次なる歩みをより確かなものにする。',
      currentCount: (stats['giveUpCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 10.0,
      unit: '回',
    ),
    AchievementModel(
      id: 'shimpu_funjin',
      title: '神風奮迅（しんぷうふんじん）',
      description: '地を蹴り、風を追い越し、瞬きの間に目的地へと至る。その勢いは、誰にも止めることはできない。',
      currentCount: (stats['earlyArrivalCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 10.0,
      unit: '回',
    ),

    AchievementModel(
      id: 'renshin_kyomei',
      title: '聯心共鳴（れんしんきょうめい）',
      description: '誰かの要請に応え、戦杯を交わす。見知らぬ誰かと想いが重なり、世界は少しだけ優しくなる。',
      currentCount: (stats['guildMissionCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 10.0,
      unit: '回',
    ),

    AchievementModel(
      id: 'rikukon_soheki',
      title: '勠魂双璧（りくこんそうへき）',
      description: '同じ歩調で、同じ景色を見つめて。過酷な旅路も、信頼する片翼がいれば、そこは至高の楽園となる。',
      currentCount: (stats['friendWalkCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 10.0,
      unit: '回',
    ),
  ];
});
