// lib/constants/app_ranks.dart

import 'package:flutter/material.dart';

class RankData {
  final String title;
  final String englishTitle;
  final String description;
  final String colorName;
  final Color color;
  final List<Color> gradientColors;
  final String icon;

  const RankData({
    required this.title,
    required this.englishTitle,
    required this.description,
    required this.colorName,
    required this.color,
    required this.gradientColors,
    required this.icon,
  });

  static RankData getRankData(int level) {
    if (level >= 100) {
      return const RankData(
        title: '永遠の巡記者',
        englishTitle: 'Eternal Chronicler',
        description: '終わりなき旅を続ける者。街の物語も、旅人の物語も、すべてを記録し続ける。',
        colorName: 'レインボーゴールド',
        color: Color(0xFFFFD54A),
        gradientColors: [
          Color(0xFFFF3D9A),
          Color(0xFFFFD54A),
          Color(0xFF8AF7FF),
        ],
        icon: '✨',
      );
    }
    if (level >= 90) {
      return const RankData(
        title: '街律の翻訳官',
        englishTitle: 'City Lore Interpreter',
        description: '街が語る律を理解し、人へ伝えられる者。その歩みは、すでに伝説となっている。',
        colorName: '虹白金',
        color: Color(0xFFE9F9FF),
        gradientColors: [
          Color(0xFFE9F9FF),
          Color(0xFFFFD54A),
          Color(0xFFB794F6),
        ],
        icon: '🪽',
      );
    }
    if (level >= 80) {
      return const RankData(
        title: '境界の観測者',
        englishTitle: 'Boundary Observer',
        description: '現実と物語の境界を見つめる者。その瞳には、誰も知らない景色が映る。',
        colorName: 'オーロラ',
        color: Color(0xFF7FFFD4),
        gradientColors: [
          Color(0xFF7FFFD4),
          Color(0xFFDA70D6),
          Color(0xFF7AA7FF),
        ],
        icon: '🌌',
      );
    }
    if (level >= 70) {
      return const RankData(
        title: '都市神話の守人',
        englishTitle: 'Urban Myth Warden',
        description: '街に宿る神話を守る者。伝説は語られることで生き続ける。',
        colorName: '蒼金',
        color: Color(0xFF5EA8D8),
        gradientColors: [Color(0xFF4682B4), Color(0xFFFFD700)],
        icon: '🏛️',
      );
    }
    if (level >= 60) {
      return const RankData(
        title: '夢路の継承者',
        englishTitle: 'Dreamkeeper',
        description: '人々が忘れた記憶さえ拾い集めることができる。夜の街は彼らを覚えている。',
        colorName: 'ムーンシルバー',
        color: Color(0xFFE6E6FA),
        gradientColors: [Color(0xFFE6E6FA), Color(0xFF9AA7B8)],
        icon: '🌙',
      );
    }
    if (level >= 50) {
      return const RankData(
        title: '神話編纂卿',
        englishTitle: 'Myth Compiler',
        description: '街の歴史を紡ぎ、物語として残す存在。もはや旅人ではなく、語り部である。',
        colorName: '発光ゴールド',
        color: Color(0xFFFFD700),
        gradientColors: [
          Color(0xFFFFF1A8),
          Color(0xFFFFD700),
          Color(0xFFFF8C00),
        ],
        icon: '👑',
      );
    }
    if (level >= 40) {
      return const RankData(
        title: '星図の先導者',
        englishTitle: 'Starmap Guide',
        description: '街の記憶を結び、新たな道を示す者。歩いた軌跡は誰かの冒険になる。',
        colorName: 'プラチナホワイト',
        color: Color(0xFFE5E4E2),
        gradientColors: [
          Color(0xFFFFFFFF),
          Color(0xFFE5E4E2),
          Color(0xFF9FA8B2),
        ],
        icon: '⭐',
      );
    }
    if (level >= 30) {
      return const RankData(
        title: '霧境の開拓騎士',
        englishTitle: 'Mist Pathfinder',
        description: 'まだ誰も気づいていない街の断片を集める旅人。霧の向こうへ進む資格を得た。',
        colorName: '深青',
        color: Color(0xFF4C7FB0),
        gradientColors: [Color(0xFF1F4E79), Color(0xFF0F2042)],
        icon: '📜',
      );
    }
    if (level >= 20) {
      return const RankData(
        title: '古跡の読解者',
        englishTitle: 'Interpreter',
        description: '現実の日常の中に隠された物語の予兆を読み解ける者。街の沈黙は、彼らにだけ言葉を返す。',
        colorName: 'エメラルド',
        color: Color(0xFF50C878),
        gradientColors: [Color(0xFF50C878), Color(0xFF0E7A4F)],
        icon: '📖',
      );
    }
    if (level >= 10) {
      return const RankData(
        title: '路地の探索兵',
        englishTitle: 'Alley Explorer',
        description: '人々が見落とす小さな路地にも物語が眠ることを知った者。足跡は少しずつ地図になっていく。',
        colorName: 'セピアゴールド',
        color: Color(0xFFC5A059),
        gradientColors: [Color(0xFFD5B36A), Color(0xFF8B7355)],
        icon: '🧭',
      );
    }
    return const RankData(
      title: '見習い巡記官',
      englishTitle: 'Apprentice Chronicler',
      description: 'まだ街の囁きは聞こえない。だが彼らは歩き始めた。すべての物語は、最初の一歩から始まる。',
      colorName: 'ブロンズ',
      color: Color(0xFFB58A5A),
      gradientColors: [Color(0xFFCD7F32), Color(0xFF8F5A2A)],
      icon: '🪶',
    );
  }
}
