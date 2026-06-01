// lib/pages/route_select_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../models/route_model.dart';
import '../providers/navigation_provider.dart';
import '../providers/route_provider.dart';
import '../providers/settings_provider.dart';
import '../router/route_names.dart';
import '../widgets/common/custom_header.dart';
import '../widgets/route/route_card.dart';
import '../widgets/route/route_empty_state.dart';
import '../widgets/route/route_loading_overlay.dart';
import '../widgets/route/route_select_button.dart';
import '../widgets/route/route_select_map.dart';

class RouteSelectPage extends ConsumerStatefulWidget {
  const RouteSelectPage({super.key});

  @override
  ConsumerState<RouteSelectPage> createState() => _RouteSelectPageState();
}

class _RouteSelectPageState extends ConsumerState<RouteSelectPage> {
  String? _mapStyle;
  bool _isRouteSheetExpanded = true;

  static const _carouselHeight = 340.0;
  static const _collapsedSheetHeight = 86.0;
  static const _buttonAreaHeight = 92.0;
  static const _headerHeight = 88.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeMode = ref.read(settingsProvider).themeMode;
      _loadMapStyle(themeMode);
    });
  }

  Future<void> _loadMapStyle(String themeMode) async {
    if (themeMode == 'daylight') {
      if (mounted) {
        setState(() => _mapStyle = null);
      }
      return;
    }
    try {
      final style = await rootBundle.loadString(
        'assets/map_styles/dark_fantasy_map.json',
      );
      if (mounted) setState(() => _mapStyle = style);
    } catch (e) {
      debugPrint('Error loading map style: $e');
    }
  }

  RouteModel? _selectedRoute(List<RouteModel> routes, String? selectedRouteId) {
    if (routes.isEmpty) return null;
    for (final route in routes) {
      if (route.id == selectedRouteId) return route;
    }
    return routes.first;
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.adventureSetting);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final state = ref.watch(routeSelectProvider);
    final notifier = ref.read(routeSelectProvider.notifier);
    final spots = ref.watch(generatedSpotsProvider);
    final routes = state.routes;
    final hasRoutes = routes.isNotEmpty;
    final selectedRoute = _selectedRoute(routes, state.selectedRouteId);
    final bottomInset =
        (_isRouteSheetExpanded ? _carouselHeight : _collapsedSheetHeight) +
        _buttonAreaHeight;

    ref.listen<String>(settingsProvider.select((s) => s.themeMode), (prev, next) {
      if (prev != next) {
        _loadMapStyle(next);
      }
    });

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            CustomHeader(
              title: 'ルート選択',
              subtitle: 'ROUTE SELECT',
              onBack: () => _handleBack(context),
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (hasRoutes)
                    RouteSelectMap(
                      key: ValueKey(routes.map((r) => r.id).join(',')),
                      routes: routes,
                      spots: spots,
                      selectedRouteId: state.selectedRouteId ?? routes.first.id,
                      mapStyle: _mapStyle,
                      topInset: _headerHeight,
                      bottomInset: bottomInset,
                      onRouteTapped: notifier.selectRoute,
                    )
                  else
                    ColoredBox(color: colors.background),

                  if (state.isLoading && !hasRoutes)
                    ColoredBox(
                      color: colors.background.withValues(alpha: 0.88),
                      child: const RouteLoadingOverlay(),
                    ),

                  if (!state.isLoading && !hasRoutes)
                    ColoredBox(
                      color: colors.background.withValues(alpha: 0.92),
                      child: RouteEmptyState(
                        onGenerate: () => notifier.generateRoutes(),
                      ),
                    ),

                  if (state.isLoading && hasRoutes)
                    Center(
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          color: colors.secondary,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),

                  if (hasRoutes)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _RouteBottomCarousel(
                        routes: routes,
                        selectedRouteId:
                            state.selectedRouteId ?? routes.first.id,
                        onRouteSelected: notifier.selectRoute,
                        isExpanded: _isRouteSheetExpanded,
                        onExpandedChanged: (value) {
                          setState(() {
                            _isRouteSheetExpanded = value;
                          });
                        },
                        onStart: selectedRoute == null
                            ? null
                            : () {
                                notifier.selectRoute(selectedRoute.id);
                                ref
                                    .read(navigationProvider.notifier)
                                    .startAdventure(selectedRoute);
                                context.go(AppRoutes.navigation);
                              },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteBottomCarousel extends StatefulWidget {
  final List<RouteModel> routes;
  final String selectedRouteId;
  final ValueChanged<String> onRouteSelected;
  final bool isExpanded;
  final ValueChanged<bool> onExpandedChanged;
  final VoidCallback? onStart;

  const _RouteBottomCarousel({
    required this.routes,
    required this.selectedRouteId,
    required this.onRouteSelected,
    required this.isExpanded,
    required this.onExpandedChanged,
    required this.onStart,
  });

  @override
  State<_RouteBottomCarousel> createState() => _RouteBottomCarouselState();
}

class _RouteBottomCarouselState extends State<_RouteBottomCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isAnimating = false;

  static const _carouselHeight = 340.0;
  static const _collapsedHeight = 86.0;

  @override
  void initState() {
    super.initState();
    _currentPage = _indexForRoute(widget.selectedRouteId);
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: 0.92,
    );
  }

  @override
  void didUpdateWidget(covariant _RouteBottomCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.routes.length != widget.routes.length) {
      _pageController.dispose();
      _currentPage = _indexForRoute(widget.selectedRouteId);
      _pageController = PageController(
        initialPage: _currentPage,
        viewportFraction: 0.92,
      );
      return;
    }

    if (oldWidget.selectedRouteId != widget.selectedRouteId) {
      final index = _indexForRoute(widget.selectedRouteId);
      if (index != _currentPage && !_isAnimating) {
        _animateToPage(index);
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _indexForRoute(String routeId) {
    final index = widget.routes.indexWhere((route) => route.id == routeId);
    return index >= 0 ? index : 0;
  }

  Future<void> _animateToPage(int index) async {
    if (!_pageController.hasClients) return;

    _isAnimating = true;
    await _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
    if (mounted) {
      setState(() {
        _isAnimating = false;
        _currentPage = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedRoute = widget.routes[_indexForRoute(widget.selectedRouteId)];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          height: widget.isExpanded ? _carouselHeight : _collapsedHeight,
          child: widget.isExpanded
              ? Column(
                  children: [
                    _RouteSheetHandle(
                      isExpanded: true,
                      onTap: () => widget.onExpandedChanged(false),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.routes.length,
                        onPageChanged: (index) {
                          if (_isAnimating) return;
                          _currentPage = index;
                          widget.onRouteSelected(widget.routes[index].id);
                        },
                        itemBuilder: (context, index) {
                          final route = widget.routes[index];
                          final isSelected = route.id == widget.selectedRouteId;
                          return RouteCard(
                            route: route,
                            isSelected: isSelected,
                          );
                        },
                      ),
                    ),
                  ],
                )
              : _CollapsedRouteSummary(
                  route: selectedRoute,
                  onTap: () => widget.onExpandedChanged(true),
                ),
        ),
        if (widget.onStart != null) RouteSelectButton(onStart: widget.onStart!),
      ],
    );
  }
}

class _RouteSheetHandle extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _RouteSheetHandle({required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: colors.border),
            ),
            child: Icon(
              isExpanded
                  ? Icons.keyboard_arrow_down_rounded
                  : Icons.keyboard_arrow_up_rounded,
              color: colors.secondary,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapsedRouteSummary extends StatelessWidget {
  final RouteModel route;
  final VoidCallback onTap;

  const _CollapsedRouteSummary({required this.route, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: colors.secondary, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.route_rounded,
                color: colors.secondary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      route.themeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${route.totalDistance.toStringAsFixed(1)}km / ${route.estimatedTime}分 / ${route.generatedSpots.length}スポット',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.keyboard_arrow_up_rounded,
                color: colors.secondary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
