// lib/utils/date_utils.dart

import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  /// 2026/05/25
  static String formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  /// 2026/05/25 18:30
  static String formatDateTime(DateTime date) {
    return DateFormat('yyyy/MM/dd HH:mm').format(date);
  }

  /// 18:30
  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// 5月25日
  static String formatShort(DateTime date) {
    return DateFormat('M月d日').format(date);
  }

  /// 「3分前」「2時間前」
  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}秒前';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}分前';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours}時間前';
    }

    if (diff.inDays < 7) {
      return '${diff.inDays}日前';
    }

    return formatDate(date);
  }

  /// 朝・昼・夜 判定
  static String timeZoneLabel(DateTime date) {
    final hour = date.hour;

    if (hour >= 5 && hour < 11) {
      return '朝';
    }

    if (hour >= 11 && hour < 17) {
      return '昼';
    }

    if (hour >= 17 && hour < 22) {
      return '夜';
    }

    return '深夜';
  }

  /// 今日かどうか
  static bool isToday(DateTime date) {
    final now = DateTime.now();

    return now.year == date.year &&
        now.month == date.month &&
        now.day == date.day;
  }

  /// 昨日かどうか
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(
      const Duration(days: 1),
    );

    return yesterday.year == date.year &&
        yesterday.month == date.month &&
        yesterday.day == date.day;
  }
}