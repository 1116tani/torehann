// lib/widgets/history/history_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../models/adventure_history_model.dart';

class HistoryCard extends StatelessWidget {
  final AdventureHistoryModel history;
  final VoidCallback onTap;

  const HistoryCard({
    super.key,
    required this.history,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(
          bottom: AppSizes.p16,
        ),

        decoration: BoxDecoration(
          color: colors.surface,

          borderRadius:
              BorderRadius.circular(
                AppSizes.radiusL,
              ),

          border: Border.all(
            color: history.isCompleted
                ? colors.primary.withValues(alpha: 0.6)
                : colors.border,
            width: 0.8,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),

              blurRadius: 10,

              offset: const Offset(
                0,
                4,
              ),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            // ─────────────────────
            // 上部情報
            // ─────────────────────

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                0,
              ),

              child: Row(
                children: [
                  // 天気
                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),

                    decoration:
                        BoxDecoration(
                      color: colors.surfaceLight,

                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),

                    child: Text(
                      history.weather,

                      style:
                          const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(
                    child: Text(
                      _formatDate(
                        history.createdAt,
                      ),

                      style:
                          TextStyle(
                        color: colors.textSecondary,
                        fontSize: 11,
                        letterSpacing:
                            0.3,
                      ),
                    ),
                  ),

                  _StatusBadge(
                    isCompleted:
                        history
                            .isCompleted,
                  ),
                ],
              ),
            ),

            // ─────────────────────
            // タイトル
            // ─────────────────────

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                14,
                16,
                0,
              ),

              child: Text(
                 history.title,

                 maxLines: 2,

                 overflow:
                     TextOverflow
                         .ellipsis,

                 style:
                     TextStyle(
                   color: colors.textPrimary,

                   fontSize: 17,

                   height: 1.4,

                   fontWeight:
                       FontWeight.bold,
                 ),
              ),
            ),

            // ─────────────────────
            // スタッツ
            // ─────────────────────

            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                0,
              ),

              child: Wrap(
                spacing: 10,
                runSpacing: 8,

                crossAxisAlignment:
                    WrapCrossAlignment
                        .center,

                children: [
                  _StatChip(
                    icon:
                        Icons.route_rounded,

                    label:
                        '${history.distanceKm.toStringAsFixed(1)}km',
                  ),

                  _StatChip(
                    icon: Icons
                        .timer_outlined,

                    label:
                        '${history.durationMinutes}分',
                  ),

                  if (history
                      .friendIds
                      .isNotEmpty)
                    _StatChip(
                      icon:
                          Icons.people_alt_rounded,

                      label:
                          '${history.friendIds.length}人',
                    ),

                  // 断片
                  if (history
                      .fragments
                      .isNotEmpty)
                    ...history.fragments
                        .take(3)
                        .map(
                      (f) => Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              8,
                          vertical:
                              4,
                        ),

                        decoration:
                            BoxDecoration(
                          color: colors.surfaceLight,

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),

                          border:
                              Border.all(
                            color: colors.border,
                            width:
                                0.5,
                          ),
                        ),

                        child: Text(
                          f,

                          style:
                              TextStyle(
                            color: colors.primary,

                            fontSize:
                                10,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ─────────────────────
            // 写真
            // ─────────────────────

            if (history
                .imageUrls
                .isNotEmpty)
              _PhotoThumbnails(
                photoUrls:
                    history.imageUrls,
              )
            else
              const _MapPlaceholder(),

            // ─────────────────────
            // フレンド
            // ─────────────────────

            // ─────────────────────
            // フレンド
            // ─────────────────────

            if (history
                .friendIds
                .isNotEmpty)
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(
                  16,
                  0,
                  16,
                  16,
                ),

                child: Row(
                  children: [
                    ...history.friendIds
                        .take(4)
                        .map(
                      (_) =>
                          Container(
                        width: 28,
                        height: 28,

                        margin:
                            const EdgeInsets.only(
                          right:
                              6,
                        ),

                        decoration:
                            BoxDecoration(
                          color: colors.surfaceLight,

                          shape:
                              BoxShape
                                  .circle,

                          border:
                              Border.all(
                            color: colors.primary,
                            width:
                                0.6,
                          ),
                        ),

                        child:
                            Icon(
                          Icons.person,
                          size: 16,
                          color: colors.primary,
                        ),
                      ),
                    ),

                    if (history
                            .friendIds
                            .length >
                        4)
                      Text(
                        '+${history.friendIds.length - 4}',

                        style:
                            TextStyle(
                          color: colors.textSecondary,
                          fontSize:
                              11,
                        ),
                      ),
                  ],
                ),
              )
            else
              const SizedBox(
                height: 16,
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(
    DateTime dt,
  ) {
    return DateFormat(
      'yyyy/MM/dd HH:mm〜',
    ).format(dt);
  }
}

// ─────────────────────────────
// ステータスバッジ
// ─────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isCompleted;

  const _StatusBadge({
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.success.withValues(alpha: 0.15)
            : AppColors.warning.withValues(alpha: 0.15),

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: isCompleted
              ? AppColors.success
              : colors.primary,
          width: 0.6,
        ),
      ),

      child: Text(
        isCompleted
            ? '✦ 完走'
            : '中断',

        style: TextStyle(
          color: isCompleted
              ? AppColors.success
              : colors.primary,

          fontSize: 10,

          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}

// ─────────────────────────────
// スタッツチップ
// ─────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: colors.surfaceLight,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: colors.border,
          width: 0.5,
        ),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 14,
            color: colors.primary,
          ),

          const SizedBox(
            width: 4,
          ),

          Text(
            label,

            style:
                TextStyle(
              color: colors.primary,
              fontSize: 11,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────
// 写真
// ─────────────────────────────

class _PhotoThumbnails
    extends StatelessWidget {
  final List<String> photoUrls;

  const _PhotoThumbnails({
    required this.photoUrls,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        14,
      ),

      child: SizedBox(
        height: 74,

        child: ListView.separated(
          scrollDirection:
              Axis.horizontal,

          itemCount:
              photoUrls.length > 3
                  ? 3
                  : photoUrls.length,

          separatorBuilder:
              (_, _) =>
                  const SizedBox(
            width: 8,
          ),

          itemBuilder:
              (context, index) {
            return ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                10,
              ),

              child: Image.network(
                photoUrls[index],

                width: 96,
                height: 74,

                fit: BoxFit.cover,

                errorBuilder:
                    (_, _, _) {
                  return Container(
                    width: 96,
                    height: 74,

                    color: colors.surfaceLight,

                    child:
                        Icon(
                      Icons
                          .image_not_supported_outlined,
                      color: colors.textMuted,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────
// マッププレースホルダー
// ─────────────────────────────

class _MapPlaceholder
    extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      margin:
          const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        14,
      ),

      height: 68,

      decoration: BoxDecoration(
        color: colors.background,

        borderRadius:
            BorderRadius.circular(10),

        border: Border.all(
          color: colors.border,
          width: 0.5,
        ),
      ),

      child: Center(
        child: Row(
          mainAxisSize:
              MainAxisSize.min,

          children: [
            Icon(
              Icons.map_rounded,
              size: 16,
              color: colors.textMuted,
            ),

            const SizedBox(width: 8),

            Text(
              'ルート軌跡ログ',

              style: TextStyle(
                color: colors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
