// lib/constants/app_ranks.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

class RankData {
  final String title;
  final String description;
  final Color color;
  final IconData icon;

  const RankData({
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
  });

  static RankData getRankData(int level) {
    if (level >= 50) {
      return const RankData(
        title: '終焉なき神話の著者',
        description: 'その歩みは紡がれ、世界の創世から終焉を記す叙事詩となる',
        color: AppColors.gold,
        icon: Icons.auto_awesome_rounded,
      );
    }
    if (level >= 40) {
      return const RankData(
        title: '天球の編纂賢者',
        description: '観測した世界のすべての断片（テール）を読み解き、真理へと編纂する賢者',
        color: Color(0xFFD7DDE8),
        icon: Icons.menu_book_rounded,
      );
    }
    if (level >= 30) {
      return const RankData(
        title: '叙事詩を紡ぎし者',
        description: '数多の歩みと足跡を重ね、忘れ去られた街の記憶を美しき詩へと変える語り部',
        color: Color(0xFF7FA8D1),
        icon: Icons.history_edu_rounded,
      );
    }
    if (level >= 20) {
      return const RankData(
        title: '迷宮街律の解読官',
        description: '入り組んだ路地と石畳に秘められた、古代の契約と法則（ルール）を解読する者',
        color: Color(0xFF7BC6B8),
        icon: Icons.travel_explore_rounded,
      );
    }
    if (level >= 10) {
      return const RankData(
        title: '常闇街影の追跡者',
        description: '日の届かぬ街の裏路地や影に隠された、失われた謎と痕跡を追う狩人',
        color: AppColors.secondary,
        icon: Icons.explore_rounded,
      );
    }
    return const RankData(
      title: '白紙より踏み出す者',
      description: 'まだ何一つとして記されていない白紙の羊皮紙を手に、最初の一歩を踏み出した旅人',
      color: Color(0xFFB58A5A),
      icon: Icons.edit_note_rounded,
    );
  }
}
