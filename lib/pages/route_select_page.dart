// lib/pages/route_select_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../models/route_model.dart';
import '../providers/navigation_provider.dart';
import '../providers/route_provider.dart';
import '../router/route_names.dart';
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

  static const _carouselHeight = 340.0;
  static const _buttonAreaHeight = 92.0;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
  }

  Future<void> _loadMapStyle() async {
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
    final state = ref.watch(routeSelectProvider);
    final notifier = ref.read(routeSelectProvider.notifier);
    final spots = ref.watch(generatedSpotsProvider);
    final routes = state.routes;
    final hasRoutes = routes.isNotEmpty;
    final selectedRoute = _selectedRoute(routes, state.selectedRouteId);
    final bottomInset = _carouselHeight + _buttonAreaHeight;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (hasRoutes)
            RouteSelectMap(
              key: ValueKey(routes.map((r) => r.id).join(',')),
              routes: routes,
              spots: spots,
              selectedRouteId: state.selectedRouteId ?? routes.first.id,
              mapStyle: _mapStyle,
              bottomInset: bottomInset,
              onRouteTapped: notifier.selectRoute,
            )
          else
            const ColoredBox(color: AppColors.background),

          if (state.isLoading && !hasRoutes)
            ColoredBox(
              color: AppColors.background.withValues(alpha: 0.88),
              child: const RouteLoadingOverlay(),
            ),

          if (!state.isLoading && !hasRoutes)
            ColoredBox(
              color: AppColors.background.withValues(alpha: 0.92),
              child: RouteEmptyState(
                onGenerate: () => notifier.generateRoutes(),
              ),
            ),

          if (state.isLoading && hasRoutes)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 64,
              left: 0,
              right: 0,
              child: const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),

          SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: AppSizes.p16),
                      child: _FloatingBackButton(
                        onPressed: () => _handleBack(context),
                      ),
                    ),
                  ),
                  if (hasRoutes) _RouteSelectTitle(),
                ],
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
                selectedRouteId: state.selectedRouteId ?? routes.first.id,
                onRouteSelected: notifier.selectRoute,
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
    );
  }
}

class _RouteBottomCarousel extends StatefulWidget {
  final List<RouteModel> routes;
  final String selectedRouteId;
  final ValueChanged<String> onRouteSelected;
  final VoidCallback? onStart;

  const _RouteBottomCarousel({
    required this.routes,
    required this.selectedRouteId,
    required this.onRouteSelected,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: _carouselHeight,
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
        if (widget.onStart != null) RouteSelectButton(onStart: widget.onStart!),
      ],
    );
  }
}

class _FloatingBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _FloatingBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.4),
      shape: const CircleBorder(
        side: BorderSide(color: AppColors.glassBorder, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _RouteSelectTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: const Text(
        'ルート選択',
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
