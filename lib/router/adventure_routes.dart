//lib/router/adventure_routes.dart
import 'package:go_router/go_router.dart';

import '../pages/adventure_setting_page.dart';
import '../pages/route_select_page.dart';
import '../pages/navigation_page.dart';
import '../pages/result_page.dart';

import '../pages/party/party_mode_page.dart';
import '../pages/party/party_host_page.dart';
import '../pages/party/party_join_page.dart';

import 'route_names.dart';

final adventureRoutes = [
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

  // Party
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
];