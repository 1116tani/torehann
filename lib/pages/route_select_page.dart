// lib/pages/route_select_page.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_sizes.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';
import '../providers/route_provider.dart';
import '../providers/navigation_provider.dart';
import '../router/route_names.dart';
import '../widgets/common/custom_header.dart';
import '../widgets/route/ai_route_banner.dart';
import '../widgets/route/route_card.dart';
import '../widgets/route/route_empty_state.dart';
import '../widgets/route/route_loading_overlay.dart';
import '../widgets/route/route_select_button.dart';

class RouteSelectPage extends ConsumerWidget {
  const RouteSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routeSelectProvider);
    final notifier = ref.read(routeSelectProvider.notifier);
    final spots = ref.watch(generatedSpotsProvider);

    final selectedRoute = _selectedRoute(state.routes, state.selectedRouteId);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1610), // 統一感のある深いダークブラウン
      body: SafeArea(
        child: Column(
          children: [
            // ── 共通ヘッダー ──
            CustomHeader(
              title: 'ルート選択',
              subtitle: 'ROUTE SELECT',
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.adventureSetting);
                }
              },
            ),

            // ── メイン表示領域 ──
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: state.isLoading
                    ? const RouteLoadingOverlay()
                    : state.routes.isEmpty
                        ? RouteEmptyState(
                            onGenerate: () => notifier.generateRoutes(),
                          )
                        : _buildRouteChoicesView(
                            context,
                            state.routes,
                            selectedRoute,
                            spots,
                            notifier.selectRoute,
                          ),
              ),
            ),

            // ── 下部固定ボタン ──
            if (!state.isLoading && selectedRoute != null)
              RouteSelectButton(
                onStart: () {
                  notifier.selectRoute(selectedRoute.id);
                  // 冒険を開始する
                  ref.read(navigationProvider.notifier).startAdventure(selectedRoute);
                  context.go(AppRoutes.navigation);
                },
              ),
          ],
        ),
      ),
    );
  }

  RouteModel? _selectedRoute(List<RouteModel> routes, String? selectedRouteId) {
    if (routes.isEmpty) return null;

    for (final route in routes) {
      if (route.id == selectedRouteId) return route;
    }

    return routes.first;
  }

  Widget _buildRouteChoicesView(
    BuildContext context,
    List<RouteModel> routes,
    RouteModel? selectedRoute,
    Map<String, SpotModel> spots,
    ValueChanged<String> onSelect,
  ) {
    final selected = selectedRoute ?? routes.first;

    return Column(
      key: const ValueKey('route-choices'),
      children: [
        // ── バナー ──
        const Padding(
          padding: EdgeInsets.fromLTRB(AppSizes.p16, AppSizes.p16, AppSizes.p16, 0),
          child: AiRouteBanner(),
        ),
        
        // ── カードリスト (横スクロール) ──
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = math.min(340.0, constraints.maxWidth * 0.84);

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(AppSizes.p16),
                itemCount: routes.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppSizes.p12),
                itemBuilder: (context, index) {
                  final route = routes[index];
                  final isSelected = route.id == selected.id;

                  return SizedBox(
                    width: cardWidth,
                    child: RouteCard(
                      route: route,
                      spots: spots,
                      isSelected: isSelected,
                      onTap: () => onSelect(route.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
