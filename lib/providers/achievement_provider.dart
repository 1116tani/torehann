// lib/providers/achievement_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/achievement_model.dart';
import 'auth_provider.dart';

/// ── 💡 ユーザーの生の統計データをFirestoreから引いてくるStreamProvider ──
final userStatsProvider = StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  final userId = user?.uid ?? 'dummy_user_123';
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('stats')
      .doc('counters')
      .snapshots()
      .map((doc) => doc.data() ?? {});
});

/// ── 💡 生データと実績マスタをマージして、UI用の【厳選9種】の実績リストに仕立てるProvider ──
final achievementListProvider = Provider.autoDispose<List<AchievementModel>>((ref) {
  // 生データを監視
  final statsAsync = ref.watch(userStatsProvider);
  final stats = statsAsync.value ?? {};
  final unlockedMap = stats['unlockedAchievements'] as Map<String, dynamic>? ?? {};

  DateTime? getUnlockDate(String id) {
    final val = unlockedMap[id];
    if (val == null) return null;
    if (val is Timestamp) return val.toDate();
    if (val is String) return DateTime.tryParse(val);
    return null;
  }

  return [
    // ── 【移動・継続】 ──
    AchievementModel(
      id: 'shoyo_mujin',
      title: '逍遥無尽（しょうようむじん）',
      description: '歩いた距離は、地図に残る。1kmも、50kmも、あなたの足が実際にそこを踏んだという事実は消えない。',
      currentCount: (stats['totalDistance'] ?? 0.0).toDouble(),
      copperValue: 1.0,
      silverValue: 15.0,
      goldValue: 50.0,
      unit: 'km',
      unlockedAt: getUnlockDate('shoyo_mujin'),
    ),
    AchievementModel(
      id: 'manyu_sokyu',
      title: '漫遊蒼穹（まんゆうそうきゅう）',
      description: '1回目は「試しに」だったかもしれない。10回を超えたころ、気づけばこの街の歩き方が変わっている。',
      currentCount: (stats['adventureCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 10.0,
      goldValue: 30.0,
      unit: '回',
      unlockedAt: getUnlockDate('manyu_sokyu'),
    ),
    AchievementModel(
      id: 'remmen_fuzetsu',
      title: '連綿不絶（れんめんふぜつ）',
      description: '毎日じゃなくていい。歩きたいと思った日に歩いた。その積み重ねが、いつの間にかこんなに続いている。',
      currentCount: (stats['loginDaysCount'] ?? 0).toDouble(),
      copperValue: 3.0,
      silverValue: 15.0,
      goldValue: 50.0,
      unit: '日',
      unlockedAt: getUnlockDate('remmen_fuzetsu'),
    ),

    // ── 【寄り道・探索】 ──
    AchievementModel(
      id: 'itsuro_tankyu',
      title: '逸路探求（いつろたんきゅう）',
      description: '誰も到達していない未開の地を開拓する者。荒野な場所には新たな出会いがある。',
      currentCount: (stats['newWayCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 10.0,
      goldValue: 30.0,
      unit: '回',
      unlockedAt: getUnlockDate('itsuro_tankyu'),
    ),
    AchievementModel(
      id: 'ukai_mukyu',
      title: '迂回無窮（うかいむきゅう）',
      description: 'ルートの途中に、ちょっと気になる場所があった。立ち寄った。それだけで、その冒険は少し豊かになった。',
      currentCount: (stats['spotVisitCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 15.0,
      goldValue: 40.0,
      unit: '回',
      unlockedAt: getUnlockDate('ukai_mukyu'),
    ),
    AchievementModel(
      id: 'dokuo_danko',
      title: '独往断行（どくおうだんこう）',
      description: '「ルートを外れています」——そのメッセージを見て、あなたはなおも直進した。その判断は、たぶん正しかった。',
      currentCount: (stats['ignoreNaviCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 15.0,
      unit: '回',
      unlockedAt: getUnlockDate('dokuo_danko'),
    ),

    // ── 【コレクション】 ──
    AchievementModel(
      id: 'shushu_temmo',
      title: '蒐集天網（しゅうしゅうてんもう）',
      description: '街を歩くと、何かが手元に残る。集めているわけじゃないのに、気づけばこんなに揃っていた。',
      currentCount: (stats['treasureKindsCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 6.0,
      goldValue: 12.0,
      unit: '種',
      unlockedAt: getUnlockDate('shushu_temmo'),
    ),
    AchievementModel(
      id: 'tsuioku_hensan',
      title: '追憶編纂（ついおくへんさん）',
      description: '同じ場所に何度も足を運んで、やっと見えてくるものがある。それをちゃんと読んだ人だけが知っている話が、ここにある。',
      currentCount: (stats['fullyUnlockedFragmentsCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 3.0,
      goldValue: 6.0,
      unit: '種',
      unlockedAt: getUnlockDate('tsuioku_hensan'),
    ),
    AchievementModel(
      id: 'saikei_setsuna',
      title: '採景刹那（さいけいせつな）',
      description: '立ち止まって、シャッターを切った。文字には書けない、その瞬間の色と光が、地図の上にピンとして刺さっている。',
      currentCount: (stats['photoPinCount'] ?? 0).toDouble(),
      copperValue: 1.0,
      silverValue: 5.0,
      goldValue: 10.0,
      unit: '枚',
      unlockedAt: getUnlockDate('saikei_setsuna'),
    ),
  ];
});