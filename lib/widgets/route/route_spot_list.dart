// lib/widgets/route/route_spot_list.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/spot_model.dart';

class RouteSpotList extends StatelessWidget {
  final List<SpotModel> spots;

  const RouteSpotList({super.key, required this.spots});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.explore_outlined, color: colors.secondary, size: 14),
            const SizedBox(width: 8),
            Text(
              'SPOTS TO VISIT',
              style: TextStyle(
                color: colors.secondary.withValues(alpha: 0.7),
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: spots.length,
          separatorBuilder: (context, index) => _buildConnector(context),
          itemBuilder: (context, index) {
            final spot = spots[index];
            final hasSubtitle = spot.aiStoryName.isNotEmpty && spot.aiStoryName != spot.name;
            final title = spot.aiStoryName.isNotEmpty ? spot.aiStoryName : spot.name;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ドット
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.secondary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                // スポット名
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasSubtitle) ...[
                        const SizedBox(height: 2),
                        Text(
                          spot.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.textSecondary.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (spot.category.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: colors.border, width: 0.5),
                    ),
                    child: Text(
                      spot.category,
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildConnector(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 3.5), // ドットの中央に合わせる
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 1.0,
          height: 12,
          color: colors.border, // ドットを繋ぐ縦線
        ),
      ),
    );
  }
}

