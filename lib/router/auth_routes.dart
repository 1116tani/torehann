import 'package:go_router/go_router.dart';

import '../pages/auth_gate.dart';
import '../pages/title_page.dart';
import 'route_names.dart';

final authRoutes = [
  GoRoute(
    path: AppRoutes.auth,
    builder: (context, state) => const AuthGate(),
  ),

  GoRoute(
    path: AppRoutes.title,
    builder: (context, state) => const TitlePage(),
  ),
];