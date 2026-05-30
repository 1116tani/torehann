// lib/utils/exp_utils.dart
import 'dart:math' as math;
import '../models/rank_definition.dart';

class ExpUtils {
  static const int maxLevel = 100;

  // Lv10/20/30/40/50 が約 4,000/15,000/35,000/65,000/100,000EXP になる累積式。
  static int totalXpForLevel(int level) {
    if (level <= 1) return 0;
    final cappedLevel = level.clamp(1, maxLevel).toInt();
    return (40 * math.pow(cappedLevel, 2)).floor();
  }

  static int getLevelFromXp(int totalXp) {
    if (totalXp <= 0) return 1;
    return math.sqrt(totalXp / 40).floor().clamp(1, maxLevel).toInt();
  }

  static int xpToNextLevel(int level) {
    if (level >= maxLevel) return 0;
    return totalXpForLevel(level + 1) - totalXpForLevel(level);
  }

  static int adventureXp({
    required double distanceKm,
    required int reachedSpotCount,
    required int firstVisitSpotCount,
    required int photoCount,
    int missionXp = 0,
  }) {
    return (distanceKm * 20).round() +
        reachedSpotCount * 15 +
        firstVisitSpotCount * 30 +
        photoCount * 10 +
        missionXp;
  }

  static RankDefinition getRank(int level) {
    return appRanks.firstWhere(
      (rank) => level >= rank.minLevel && level <= rank.maxLevel,
      orElse: () => appRanks.last,
    );
  }
}
