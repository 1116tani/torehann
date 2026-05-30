// lib/models/rank_definition.dart
import 'package:flutter/material.dart';

class RankDefinition {
  final int minLevel;
  final int maxLevel;
  final String icon;
  final String nameJa;
  final String nameEn;
  final List<Color> colors; // 🌟グラデーションもできるように複数色対応！
  final String description;

  const RankDefinition({
    required this.minLevel,
    required this.maxLevel,
    required this.icon,
    required this.nameJa,
    required this.nameEn,
    required this.colors,
    required this.description,
  });
}

// 📜 みぃくんが考えてくれた最高のランク一覧データ
const List<RankDefinition> appRanks = [
  RankDefinition(
    minLevel: 1,
    maxLevel: 9,
    icon: '🪶',
    nameJa: '見習い巡記官',
    nameEn: 'Apprentice Chronicler',
    colors: [Color(0xFFCD7F32), Color(0xFFCD7F32)], // ブロンズ調
    description: 'まだ街の囁きは聞こえない。だが彼らは歩き始めた。すべての物語は、最初の一歩から始まる。',
  ),
  RankDefinition(
    minLevel: 10,
    maxLevel: 19,
    icon: '🧭',
    nameJa: '路地の探索兵',
    nameEn: 'Alley Explorer',
    colors: [Color(0xFFC5A059), Color(0xFF8B7355)], // セピアゴールド
    description: '人々が見落とす小さな路地にも物語が眠ることを知った者。足跡は少しずつ地図になっていく。',
  ),
  RankDefinition(
    minLevel: 20,
    maxLevel: 29,
    icon: '📖',
    nameJa: '古跡の読解者',
    nameEn: 'Interpreter',
    colors: [Color(0xFF50C878), Color(0xFF006400)], // エメラルド
    description: '現実の日常の中に隠された物語の予兆を読み解ける者。街の沈黙は、彼らにだけ言葉を返す。',
  ),
  RankDefinition(
    minLevel: 30,
    maxLevel: 39,
    icon: '📜',
    nameJa: '霧境の開拓騎士',
    nameEn: 'Mist Pathfinder',
    colors: [Color(0xFF1F4E79), Color(0xFF0F2042)], // 深青
    description: 'まだ誰も気づいていない街の断片を集める旅人。霧の向こうへ進む資格を得た。',
  ),
  RankDefinition(
    minLevel: 40,
    maxLevel: 49,
    icon: '⭐',
    nameJa: '星図の先導者',
    nameEn: 'Starmap Guide',
    colors: [Color(0xFFE5E4E2), Color(0xFF7F8C8D)], // プラチナホワイト
    description: '街の記憶を結び、新たな道を示す者。歩いた軌跡は誰かの冒険になる。',
  ),
  RankDefinition(
    minLevel: 50,
    maxLevel: 59,
    icon: '👑',
    nameJa: '神話編纂卿',
    nameEn: 'Myth Compiler',
    colors: [Color(0xFFFFD700), Color(0xFFFF8C00)], // 発光ゴールド
    description: '街の歴史を紡ぎ、物語として残す存在。もはや旅人ではなく、語り部である。',
  ),
  RankDefinition(
    minLevel: 60,
    maxLevel: 69,
    icon: '🌙',
    nameJa: '夢路の継承者',
    nameEn: 'Dreamkeeper',
    colors: [Color(0xFFE6E6FA), Color(0xFF778899)], // ムーンシルバー
    description: '人々が忘れた記憶さえ拾い集めることができる。夜の街は彼らを覚えている。',
  ),
  RankDefinition(
    minLevel: 70,
    maxLevel: 79,
    icon: '🏛️',
    nameJa: '都市神話の守人',
    nameEn: 'Urban Myth Warden',
    colors: [Color(0xFF4682B4), Color(0xFFFFD700)], // 蒼金
    description: '街に宿る神話を守る者。伝説は語られることで生き続ける。',
  ),
  RankDefinition(
    minLevel: 80,
    maxLevel: 89,
    icon: '🌌',
    nameJa: '境界の観測者',
    nameEn: 'Boundary Observer',
    colors: [Color(0xFF7FFFD4), Color(0xFFDA70D6)], // オーロラ（アクア＆オーキッド）
    description: '現実と物語の境界を見つめる者。その瞳には、誰も知らない景色が映る。',
  ),
  RankDefinition(
    minLevel: 90,
    maxLevel: 99,
    icon: '🪽',
    nameJa: '街律の翻訳官',
    nameEn: 'City Lore Interpreter',
    colors: [Color(0xFFE0FFFF), Color(0xFFFFD700)], // 虹白金
    description: '街が語る律を理解し、人へ伝えられる者。その歩みは、すでに伝説となっている。',
  ),
  RankDefinition(
    minLevel: 100,
    maxLevel: 999, // カンスト用だよ
    icon: '✨',
    nameJa: '永遠の巡記者',
    nameEn: 'Eternal Chronicler',
    colors: [Color(0xFFFF007F), Color(0xFFFFD700)], // レインボーゴールド
    description: '終わりなき旅を続ける者。街の物語も、旅人の物語も、すべてを記録し続ける。',
  ),
];
