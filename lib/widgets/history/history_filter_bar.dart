// lib/widgets/history/history_filter_bar.dart

import 'package:flutter/material.dart';
import '../../providers/history_provider.dart';

class HistoryFilterBar extends StatefulWidget {
  final Set<FilterTag> activeFilters;
  final Function(FilterTag) onToggle;

  const HistoryFilterBar({
    super.key,
    required this.activeFilters,
    required this.onToggle,
  });

  @override
  State<HistoryFilterBar> createState() =>
      _HistoryFilterBarState();
}

class _HistoryFilterBarState
    extends State<HistoryFilterBar> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.8,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ── 上段チップ ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: [
                ..._quickFilters.map(
                  (tag) => Padding(
                    padding:
                        const EdgeInsets.only(
                      right: 8,
                    ),

                    child: _buildChip(tag),
                  ),
                ),

                // 詳細検索ボタン
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded =
                          !isExpanded;
                    });
                  },

                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    decoration: BoxDecoration(
                      color:
                          const Color(
                        0xFF3D2B1F,
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),

                      border: Border.all(
                        color:
                            const Color(
                          0xFF5C4033,
                        ),
                      ),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.tune_rounded,
                          size: 16,
                          color: Color(
                            0xFFC8A97A,
                          ),
                        ),

                        const SizedBox(
                          width: 6,
                        ),

                        Text(
                          isExpanded
                              ? '閉じる'
                              : '詳細検索',

                          style:
                              const TextStyle(
                            color: Color(
                              0xFFC8A97A,
                            ),
                            fontSize: 11,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── アコーディオン ──
          AnimatedCrossFade(
            duration:
                const Duration(
              milliseconds: 220,
            ),

            crossFadeState:
                isExpanded
                    ? CrossFadeState
                        .showSecond
                    : CrossFadeState
                        .showFirst,

            firstChild:
                const SizedBox(),

            secondChild: Padding(
              padding:
                  const EdgeInsets.only(
                top: 18,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  const Text(
                    '絞り込み',

                    style: TextStyle(
                      color: Color(
                        0xFFC8A97A,
                      ),
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,

                    children:
                        _detailFilters.map(
                      (tag) {
                        return _buildChip(
                          tag,
                        );
                      },
                    ).toList(),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  const Text(
                    '並び替え',

                    style: TextStyle(
                      color: Color(
                        0xFFC8A97A,
                      ),
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xFF3D2B1F,
                      ),

                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),

                      border: Border.all(
                        color:
                            const Color(
                          0xFF5C4033,
                        ),
                      ),
                    ),

                    child:
                        DropdownButtonHideUnderline(
                      child:
                          DropdownButton<
                              String>(
                        dropdownColor:
                            const Color(
                          0xFF2C2318,
                        ),

                        value:
                            'newest',

                        items: const [
                          DropdownMenuItem(
                            value:
                                'newest',
                            child: Text(
                              '新しい順',
                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFFF5EDD8,
                                ),
                              ),
                            ),
                          ),

                          DropdownMenuItem(
                            value:
                                'oldest',
                            child: Text(
                              '古い順',
                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFFF5EDD8,
                                ),
                              ),
                            ),
                          ),

                          DropdownMenuItem(
                            value:
                                'distance',
                            child: Text(
                              '距離順',
                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xFFF5EDD8,
                                ),
                              ),
                            ),
                          ),
                        ],

                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────

  Widget _buildChip(FilterTag tag) {
    final isSelected =
        widget.activeFilters.contains(tag);

    return ChoiceChip(
      label: Text(
        _filterLabel(tag),

        style: TextStyle(
          fontSize: 11,

          fontWeight:
              FontWeight.bold,

          color: isSelected
              ? const Color(
                  0xFF1C1610)
              : const Color(
                  0xFFDCC8A0),
        ),
      ),

      selected: isSelected,

      onSelected: (_) =>
          widget.onToggle(tag),

      selectedColor:
          const Color(0xFFC8A97A),

      backgroundColor:
          const Color(0xFF3D2B1F),

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),

        side: BorderSide(
          color: isSelected
              ? const Color(
                  0xFFC8A97A)
              : const Color(
                  0xFF5C4033),
        ),
      ),
    );
  }

  // ─────────────────────

  String _filterLabel(
    FilterTag filter,
  ) {
    return switch (filter) {
      FilterTag.completedOnly =>
        '完走のみ',

      FilterTag.withAbandoned =>
        '中断あり',

      FilterTag.withPhotos =>
        '写真あり',

      FilterTag.morning =>
        '朝の冒険',

      FilterTag.night =>
        '夜の冒険',

      FilterTag.rainy =>
        '雨の日',
    };
  }

  // ─────────────────────

  final List<FilterTag>
      _quickFilters = [
    FilterTag.withPhotos,
    FilterTag.completedOnly,
    FilterTag.night,
  ];

  final List<FilterTag>
      _detailFilters = [
    FilterTag.withAbandoned,
    FilterTag.morning,
    FilterTag.rainy,
  ];
}