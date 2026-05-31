// lib/widgets/history/history_filter_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/history_provider.dart';
import 'filter_bottom_sheet.dart';

class HistoryFilterBar extends ConsumerWidget {
  const HistoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 並び順表示
          _buildSortOrderRow(context, state, notifier),
          
          const SizedBox(height: 12),
          
          // フィルターチップ（適用中のみ）
          if (state.activeFilters.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.activeFilters.map((filter) {
                return _buildFilterChip(
                  filter: filter,
                  onRemove: () => notifier.toggleFilter(filter),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
          
          // 絞り込みボタン
          _buildFilterButton(context, state.activeFilters.length),
        ],
      ),
    );
  }

  Widget _buildSortOrderRow(
    BuildContext context,
    HistoryState state,
    HistoryNotifier notifier,
  ) {
    return GestureDetector(
      onTap: () => _showSortOrderMenu(context, state, notifier),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF3D2B1F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF5C4033)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sort_rounded,
              size: 16,
              color: Color(0xFFC8A97A),
            ),
            const SizedBox(width: 6),
            Text(
              _getSortOrderLabel(state.sortOrder),
              style: const TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.expand_more,
              size: 16,
              color: Color(0xFFC8A97A),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required FilterTag filter,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFC8A97A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getFilterLabel(filter),
            style: const TextStyle(
              color: Color(0xFF1C1610),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: Color(0xFF1C1610),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, int filterCount) {
    return GestureDetector(
      onTap: () => _showFilterBottomSheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF3D2B1F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF5C4033)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.tune_rounded,
              size: 18,
              color: Color(0xFFC8A97A),
            ),
            const SizedBox(width: 8),
            Text(
              filterCount > 0 ? '絞り込み（$filterCount）' : '絞り込み',
              style: const TextStyle(
                color: Color(0xFFC8A97A),
                fontSize: 13,
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
    final RenderBox button = context.findRenderObject() as RenderBox;
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
      color: const Color(0xFF2C2318),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      items: [
        _buildSortMenuItem(
          SortOrder.newestFirst,
          '新しい順',
          state.sortOrder == SortOrder.newestFirst,
          notifier,
        ),
        _buildSortMenuItem(
          SortOrder.oldestFirst,
          '古い順',
          state.sortOrder == SortOrder.oldestFirst,
          notifier,
        ),
        _buildSortMenuItem(
          SortOrder.longestDistance,
          '距離順',
          state.sortOrder == SortOrder.longestDistance,
          notifier,
        ),
        _buildSortMenuItem(
          SortOrder.mostExperience,
          '獲得経験値順',
          state.sortOrder == SortOrder.mostExperience,
          notifier,
        ),
      ],
    );
  }

  PopupMenuItem<dynamic> _buildSortMenuItem(
    SortOrder order,
    String label,
    bool isSelected,
    HistoryNotifier notifier,
  ) {
    return PopupMenuItem(
      value: order,
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFC8A97A) : const Color(0xFFF5EDD8),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            const Icon(
              Icons.check_rounded,
              size: 16,
              color: Color(0xFFC8A97A),
            ),
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