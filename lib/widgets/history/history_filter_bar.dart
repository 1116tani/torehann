// lib/widgets/history/history_filter_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';
import '../../providers/history_provider.dart';
import 'filter_bottom_sheet.dart';

class HistoryFilterBar extends ConsumerWidget {
  HistoryFilterBar({super.key});

  final GlobalKey _sortOrderKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左側: 絞り込みボタンとフィルターチップ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterButton(context, state.activeFilters.length),
                if (state.activeFilters.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.start,
                    children: state.activeFilters.map((filter) {
                      return _buildFilterChip(
                        context: context,
                        filter: filter,
                        onRemove: () => notifier.toggleFilter(filter),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 右側: 並び順
          _buildSortOrderRow(context, state, notifier),
        ],
      ),
    );
  }

  Widget _buildSortOrderRow(
    BuildContext context,
    HistoryState state,
    HistoryNotifier notifier,
  ) {
    final colors = AppColors.of(context);
    return GestureDetector(
      key: _sortOrderKey,
      onTap: () => _showSortOrderMenu(context, state, notifier),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _getSortOrderLabel(state.sortOrder),
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.expand_more, size: 20, color: colors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required FilterTag filter,
    required VoidCallback onRemove,
  }) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getFilterLabel(filter),
            style: TextStyle(
              color: colors.background,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 16,
              color: colors.background,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, int filterCount) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: () => _showFilterBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.tune_rounded, size: 20, color: colors.primary),
            const SizedBox(width: 8),
            Text(
              filterCount > 0 ? '絞り込み($filterCount)' : '絞り込み',
              style: TextStyle(
                color: colors.primary,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOrderMenu(
    BuildContext context,
    HistoryState state,
    HistoryNotifier notifier,
  ) {
    final colors = AppColors.of(context);
    final RenderBox button =
        _sortOrderKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);
    final RelativeRect position = RelativeRect.fromLTRB(
      offset.dx,
      offset.dy + button.size.height,
      offset.dx + button.size.width,
      offset.dy + button.size.height + 200,
    );

    showMenu(
      context: context,
      position: position,
      color: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        _buildSortMenuItem(
          context,
          SortOrder.newestFirst,
          '新しい順',
          state.sortOrder == SortOrder.newestFirst,
          notifier,
        ),
        _buildSortMenuItem(
          context,
          SortOrder.oldestFirst,
          '古い順',
          state.sortOrder == SortOrder.oldestFirst,
          notifier,
        ),
        _buildSortMenuItem(
          context,
          SortOrder.longestDistance,
          '距離順',
          state.sortOrder == SortOrder.longestDistance,
          notifier,
        ),
        _buildSortMenuItem(
          context,
          SortOrder.mostExperience,
          '獲得経験値順',
          state.sortOrder == SortOrder.mostExperience,
          notifier,
        ),
      ],
    );
  }

  PopupMenuItem<dynamic> _buildSortMenuItem(
    BuildContext context,
    SortOrder order,
    String label,
    bool isSelected,
    HistoryNotifier notifier,
  ) {
    final colors = AppColors.of(context);
    return PopupMenuItem(
      value: order,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? colors.primary
                  : colors.textPrimary,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check_rounded, size: 16, color: colors.primary),
          ],
        ],
      ),
      onTap: () => notifier.setSortOrder(order),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  String _getSortOrderLabel(SortOrder order) {
    return switch (order) {
      SortOrder.newestFirst => '新しい順',
      SortOrder.oldestFirst => '古い順',
      SortOrder.longestDistance => '距離順',
      SortOrder.longestDuration => '時間順',
      SortOrder.mostExperience => '獲得経験値順',
    };
  }

  String _getFilterLabel(FilterTag filter) {
    return switch (filter) {
      FilterTag.completedOnly => '完走のみ',
      FilterTag.withAbandoned => '中断あり',
      FilterTag.withPhotos => '写真あり',
      FilterTag.morning => '朝の冒険',
      FilterTag.afternoon => '昼の冒険',
      FilterTag.night => '夜の冒険',
      FilterTag.sunny => '晴れ',
      FilterTag.cloudy => '曇り',
      FilterTag.rainy => '雨',
    };
  }
}
