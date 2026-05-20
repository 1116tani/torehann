// lib/pages/route_select_page.dart

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_sizes.dart';
import '../models/route_model.dart';
import '../models/spot_model.dart';
import '../providers/route_provider.dart';
import '../router/app_router.dart';
import '../widgets/route/route_preview_map.dart';
import '../widgets/route/route_tag.dart';

class RouteSelectPage extends ConsumerWidget {
  const RouteSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routeSelectProvider);
    final notifier = ref.read(routeSelectProvider.notifier);
    final spots = ref.watch(dummySpotsProvider);

    final selectedRoute = _selectedRoute(state.routes, state.selectedRouteId);

    return Scaffold(
      backgroundColor: const Color(0xFF2C2318),
      body: SafeArea(
        child: Column(
          children: [
            _RouteSelectHeader(
              onBack: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go(AppRoutes.adventureSetting);
                }
              },
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                child: state.isLoading
                    ? const _GeneratingView()
                    : state.routes.isEmpty
                    ? _EmptyRoutesView(
                        onGenerate: () => notifier.generateRoutes(),
                      )
                    : _RouteChoicesView(
                        routes: state.routes,
                        selectedRoute: selectedRoute,
                        spots: spots,
                        onSelect: notifier.selectRoute,
                      ),
              ),
            ),
            if (!state.isLoading && selectedRoute != null)
              _StartNavigationBar(
                onStart: () {
                  notifier.selectRoute(selectedRoute.id);
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
}

class _RouteSelectHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _RouteSelectHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: const BoxDecoration(
        color: Color(0xFF4A3728),
        border: Border(
          bottom: BorderSide(color: Color(0xFFC8A97A), width: 0.5),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'ルート選択',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF5EDD8),
                ),
              ),
              Text(
                'ROUTE SELECT',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFFC8A97A),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFFC8A97A)),
              onPressed: onBack,
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneratingView extends StatelessWidget {
  const _GeneratingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: ValueKey('generating-routes'),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                color: Color(0xFFB8860B),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: AppSizes.p24),
            Text(
              '冒険ルートを編纂中...',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppSizes.p8),
            Text(
              '今日の気分に合う寄り道を探しています',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFC8A97A), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyRoutesView extends StatelessWidget {
  final VoidCallback onGenerate;

  const _EmptyRoutesView({required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('empty-routes'),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              color: Color(0xFFC8A97A),
              size: AppSizes.iconL,
            ),
            const SizedBox(height: AppSizes.p16),
            const Text(
              'まだ候補がありません',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            const Text(
              'ルートを生成すると候補がここに並びます',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFC8A97A), fontSize: 12),
            ),
            const SizedBox(height: AppSizes.p24),
            ElevatedButton.icon(
              onPressed: onGenerate,
              icon: const Icon(Icons.route),
              label: const Text('ルートを生成する'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB8860B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.p24,
                  vertical: AppSizes.p12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteChoicesView extends StatelessWidget {
  final List<RouteModel> routes;
  final RouteModel? selectedRoute;
  final Map<String, SpotModel> spots;
  final ValueChanged<String> onSelect;

  const _RouteChoicesView({
    required this.routes,
    required this.selectedRoute,
    required this.spots,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedRoute ?? routes.first;
    final selectedSpots = _spotsForRoute(selected, spots);

    return ListView(
      key: const ValueKey('route-choices'),
      padding: const EdgeInsets.symmetric(vertical: AppSizes.p16),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.p16),
          child: _RouteIntroPanel(),
        ),
        const SizedBox(height: AppSizes.p16),
        SizedBox(
          height: 372,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = math.min(340.0, constraints.maxWidth * 0.84);

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
                itemCount: routes.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSizes.p12),
                itemBuilder: (context, index) {
                  final route = routes[index];
                  final isSelected = route.id == selected.id;

                  return SizedBox(
                    width: cardWidth,
                    child: _RouteChoiceCard(
                      route: route,
                      spots: _spotsForRoute(route, spots),
                      isSelected: isSelected,
                      onTap: () => onSelect(route.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: AppSizes.p16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
          child: _SelectedRouteDetail(route: selected, spots: selectedSpots),
        ),
      ],
    );
  }
}

class _RouteIntroPanel extends StatelessWidget {
  const _RouteIntroPanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Row(
          children: [
            Icon(Icons.travel_explore, color: Color(0xFFC8A97A)),
            SizedBox(width: AppSizes.p12),
            Expanded(
              child: Text(
                'AIが今日の冒険候補を用意しました',
                style: TextStyle(
                  color: Color(0xFFF5EDD8),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteChoiceCard extends StatelessWidget {
  final RouteModel route;
  final Map<String, SpotModel> spots;
  final bool isSelected;
  final VoidCallback onTap;

  const _RouteChoiceCard({
    required this.route,
    required this.spots,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSizes.p12),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2318),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFB8860B)
                : const Color(0xFF7A5C3A),
            width: isSelected ? 2 : 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? const Color(0xFFB8860B).withValues(alpha: 0.24)
                  : Colors.black.withValues(alpha: 0.32),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoutePreviewMap(route: route, spots: spots, isSelected: isSelected),
            const SizedBox(height: AppSizes.p12),
            Text(
              route.themeName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFFF5EDD8),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.p8),
            Text(
              route.themeDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isSelected ? Colors.white70 : const Color(0xFFC8A97A),
                fontSize: 12,
                height: 1.4,
              ),
            ),
            const SizedBox(height: AppSizes.p12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: route.tags.map((tag) => RouteTag(label: tag)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedRouteDetail extends StatelessWidget {
  final RouteModel route;
  final Map<String, SpotModel> spots;

  const _SelectedRouteDetail({required this.route, required this.spots});

  @override
  Widget build(BuildContext context) {
    final routeSpots = route.spotIds
        .map((spotId) => spots[spotId])
        .whereType<SpotModel>()
        .toList(growable: false);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.flag_circle,
                  color: Color(0xFFC8A97A),
                  size: AppSizes.iconS,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    route.themeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFF5EDD8),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p12),
            Wrap(
              spacing: AppSizes.p8,
              runSpacing: AppSizes.p8,
              children: [
                _RouteMetric(
                  icon: Icons.schedule,
                  label: '約${route.estimatedTime}分',
                ),
                _RouteMetric(
                  icon: Icons.route,
                  label: '${route.totalDistance.toStringAsFixed(1)}km',
                ),
                _RouteMetric(
                  icon: Icons.place_outlined,
                  label: '${route.spotIds.length}スポット',
                ),
              ],
            ),
            const SizedBox(height: AppSizes.p16),
            ...routeSpots.take(3).map((spot) => _SpotRow(spot: spot)),
          ],
        ),
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RouteMetric({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF7A5C3A), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFC8A97A), size: 13),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFC8A97A),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotRow extends StatelessWidget {
  final SpotModel spot;

  const _SpotRow({required this.spot});

  @override
  Widget build(BuildContext context) {
    final title = spot.aiStoryName.isEmpty ? spot.name : spot.aiStoryName;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.p8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFB8860B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSizes.p8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 12),
            ),
          ),
          if (spot.category.isNotEmpty)
            Text(
              spot.category,
              style: const TextStyle(color: Color(0xFF7A5C3A), fontSize: 11),
            ),
        ],
      ),
    );
  }
}

class _StartNavigationBar extends StatelessWidget {
  final VoidCallback onStart;

  const _StartNavigationBar({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.p16),
      decoration: const BoxDecoration(
        color: Color(0xFF2C2318),
        border: Border(top: BorderSide(color: Color(0xFFC8A97A), width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onStart,
          icon: const Icon(Icons.navigation),
          label: const Text('このルートで出発する'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB8860B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(AppSizes.p16),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
          ),
        ),
      ),
    );
  }
}

Map<String, SpotModel> _spotsForRoute(
  RouteModel route,
  Map<String, SpotModel> sourceSpots,
) {
  final routeSpots = <String, SpotModel>{};
  final baseLat = sourceSpots.values.isEmpty
      ? 35.6812
      : sourceSpots.values.first.lat;
  final baseLng = sourceSpots.values.isEmpty
      ? 139.7671
      : sourceSpots.values.first.lng;

  for (var i = 0; i < route.spotIds.length; i++) {
    final spotId = route.spotIds[i];
    final existingSpot = sourceSpots[spotId];
    if (existingSpot != null) {
      routeSpots[spotId] = existingSpot;
      continue;
    }

    final offset = i - (route.spotIds.length - 1) / 2;
    routeSpots[spotId] = SpotModel(
      id: spotId,
      lat: baseLat + offset * 0.0012,
      lng: baseLng + math.sin(i + route.id.length) * 0.0014,
      name: '候補スポット${i + 1}',
      category: '探索',
      aiStoryName: '未踏の気配 ${i + 1}',
      aiFlavorText: 'AIが選んだ寄り道候補',
    );
  }

  return routeSpots;
}
