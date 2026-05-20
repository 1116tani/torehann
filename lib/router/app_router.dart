// lib/router/app_router.dart
import 'package:go_router/go_router.dart';

// 相対パスでインポートすれば安全安心だよ
import '../pages/home_page.dart';
import '../pages/adventure_setting_page.dart';
import '../pages/route_select_page.dart';
import '../pages/navigation_page.dart';
import '../pages/result_page.dart';
import '../pages/settings_page.dart';
import '../pages/history_page.dart';
import '../pages/achievement_page.dart';
import '../pages/collection_page.dart';
import '../pages/party_page.dart';
import '../pages/health_page.dart';
import '../pages/mission_page.dart';

class AppRoutes {
  static const home = '/';
  static const adventureSetting = '/adventure-setting';
  static const routeSelect = '/route-select';
  static const navigation = '/navigation';
  static const result = '/result';
  static const settings = '/settings';
  static const history = '/history';
  static const achievement = '/achievement';
  static const collection = '/collection';
  static const party = '/party';
  static const health = '/health';
  static const mission = '/mission';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.adventureSetting,
      builder: (context, state) => const AdventureSettingPage(),
    ),
    GoRoute(
      path: AppRoutes.routeSelect,
      builder: (context, state) => const RouteSelectPage(),
    ),
    GoRoute(
      path: AppRoutes.navigation,
      builder: (context, state) => const NavigationPage(),
    ),
    GoRoute(
      path: AppRoutes.result,
      builder: (context, state) => const ResultPage(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
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
      path: AppRoutes.party,
      builder: (context, state) => const PartyPage(),
    ),
    GoRoute(
      path: AppRoutes.health,
      builder: (context, state) => const HealthPage(),
    ),
    GoRoute(
      path: AppRoutes.mission,
      builder: (context, state) => const MissionPage(),
    ),
  ],
);
