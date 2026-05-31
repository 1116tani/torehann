// lib/widgets/history/filter_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/history_provider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late Set<FilterTag> _tempFilters;

  @override
  void initState() {
    super.initState();
    final state = ref.read(historyProvider);
    _tempFilters = Set<FilterTag>.from(state.activeFilters);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFF1C1610),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          _buildHandleBar(),

          // Header
          _buildHeader(),

          // Filter options
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('状態', _buildStatusFilters()),
                  const SizedBox(height: 24),
                  _buildSection('時間帯', _buildTimeOfDayFilters()),
                  const SizedBox(height: 24),
                  _buildSection('天候', _buildWeatherFilters()),
                  const SizedBox(height: 24),
                  _buildSection('写真', _buildPhotoFilters()),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Bottom buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFF5C4033),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.tune_rounded, color: Color(0xFFC8A97A), size: 24),
          const SizedBox(width: 12),
          const Text(
            'フィルター設定',
            style: TextStyle(
              color: Color(0xFFF5EDD8),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFC8A97A),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildStatusFilters() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildFilterChip(FilterTag.completedOnly, '完走のみ'),
        _buildFilterChip(FilterTag.withAbandoned, '中断あり'),
      ],
    );
  }

  Widget _buildTimeOfDayFilters() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildFilterChip(FilterTag.morning, '朝の冒険'),
        _buildFilterChip(FilterTag.afternoon, '昼の冒険'),
        _buildFilterChip(FilterTag.night, '夜の冒険'),
      ],
    );
  }

  Widget _buildWeatherFilters() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildFilterChip(FilterTag.sunny, '晴れ'),
        _buildFilterChip(FilterTag.cloudy, '曇り'),
        _buildFilterChip(FilterTag.rainy, '雨'),
      ],
    );
  }

  Widget _buildPhotoFilters() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [_buildFilterChip(FilterTag.withPhotos, '写真あり')],
    );
  }

  Widget _buildFilterChip(FilterTag filter, String label) {
    final isSelected = _tempFilters.contains(filter);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _tempFilters.remove(filter);
          } else {
            _tempFilters.add(filter);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC8A97A) : const Color(0xFF2C2318),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC8A97A)
                : const Color(0xFF5C4033),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF1C1610)
                : const Color(0xFFF5EDD8),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1610),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _handleReset,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2318),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF5C4033), width: 1),
                ),
                child: const Text(
                  'リセット',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC8A97A),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: _handleApply,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFC8A97A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '適用',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1C1610),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleReset() {
    setState(() {
      _tempFilters.clear();
    });
  }

  void _handleApply() {
    final notifier = ref.read(historyProvider.notifier);
    notifier.clearFilters();
    for (final filter in _tempFilters) {
      notifier.toggleFilter(filter);
    }
    Navigator.pop(context);
  }
}
