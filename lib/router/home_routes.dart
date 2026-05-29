//lib/router/home_routes.dart
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/settings/account_page.dart';
import '../pages/history_page.dart';
import '../pages/achievement_page.dart';
import '../pages/collection_page.dart';
import '../pages/friend_page.dart';
import '../pages/health_page.dart';
import '../pages/mission_page.dart';

import 'route_names.dart';

final homeRoutes = [
  GoRoute(
    path: AppRoutes.home,
    builder: (context, state) => const HomeScreen(),
  ),

  GoRoute(
    path: AppRoutes.settings,
    builder: (context, state) => const SettingsPage(),
  ),

  GoRoute(
    path: AppRoutes.account,
    builder: (context, state) => const AccountPage(),
  ),

  GoRoute(
    path: AppRoutes.history,
    builder: (context, state) => const HistoryPage(),
  ),

  GoRoute(
    path: AppRoutes.achievement,
    builder: (context, state) => const AchievementPage(),
  ),

  GoRoute(
    path: AppRoutes.collection,
    builder: (context, state) => const CollectionPage(),
  ),

  GoRoute(
    path: AppRoutes.friends,
    builder: (context, state) => const FriendPage(),
  ),

  GoRoute(
    path: AppRoutes.health,
    builder: (context, state) => const HealthPage(),
  ),

  GoRoute(
    path: AppRoutes.mission,
    builder: (context, state) => const MissionPage(),
  ),
];