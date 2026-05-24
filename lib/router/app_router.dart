// lib/router/app_router.dart

import 'package:go_router/go_router.dart';

import '../pages/auth_gate.dart';
import '../pages/title_page.dart';
import '../pages/home_page.dart';
import '../pages/adventure_setting_page.dart';
import '../pages/route_select_page.dart';
import '../pages/navigation_page.dart';
import '../pages/result_page.dart';
import '../pages/settings_page.dart';
import '../pages/history_page.dart';
import '../pages/achievement_page.dart';
import '../pages/collection_page.dart';
import '../pages/party/party_host_page.dart';
import '../pages/party/party_join_page.dart';
import '../pages/party/party_mode_page.dart';
import '../pages/friend_page.dart';
import '../pages/health_page.dart';
import '../pages/mission_page.dart';

// ── パス定数 ──────────────────────────────────
class AppRoutes {
  static const auth = '/'; // AuthGate（起点）
  static const title = '/title'; // タイトル画面
  static const home = '/home'; // ホーム画面
  static const adventureSetting = '/adventure-setting';
  static const routeSelect = '/route-select';
  static const navigation = '/navigation';
  static const result = '/result';
  static const settings = '/settings';
  static const history = '/history';
  static const achievement = '/achievement';
  static const collection = '/collection';
  static const party = '/party';
  static const partyHost = '/party/host';
  static const partyJoin = '/party/join';
  static const friends = '/friends';
  static const health = '/health';
  static const mission = '/mission';
}

// ── ルーター本体 ──────────────────────────────
final appRouter = GoRouter(
  initialLocation: AppRoutes.auth,
  routes: [
    // ── 認証ゲート（起点） ──
    GoRoute(
      path: AppRoutes.auth,
      builder: (context, state) => const AuthGate(),
    ),

    // ── タイトル画面 ──
    GoRoute(
      path: AppRoutes.title,
      builder: (context, state) => const TitlePage(),
    ),

    // ── ホーム画面 ──
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),

    // ── 冒険セッティング ──
    GoRoute(
      path: AppRoutes.adventureSetting,
      builder: (context, state) => const AdventureSettingPage(),
    ),

    // ── ルート選択 ──
    GoRoute(
      path: AppRoutes.routeSelect,
      builder: (context, state) => const RouteSelectPage(),
    ),

    // ── ナビゲーション ──
    GoRoute(
      path: AppRoutes.navigation,
      builder: (context, state) => const NavigationPage(),
    ),

    // ── リザルト ──
    GoRoute(
      path: AppRoutes.result,
      builder: (context, state) => const ResultPage(),
    ),

    // ── 設定 ──
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),

    // ── 履歴 ──
    GoRoute(
      path: AppRoutes.history,
      builder: (context, state) => const HistoryPage(),
    ),

    // ── Tier B以降（グレーアウト） ──
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
      builder: (context, state) => const PartyModePage(),
    ),
    GoRoute(
      path: AppRoutes.partyHost,
      builder: (context, state) => const PartyHostPage(),
    ),
    GoRoute(
      path: AppRoutes.partyJoin,
      builder: (context, state) => const PartyJoinPage(),
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
  ],
);
