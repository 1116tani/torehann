// lib/widgets/friend/search_bar.dart

import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class FriendSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const FriendSearchBar({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: colors.border,
          width: 0.6,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: colors.secondary,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: colors.textPrimary,
                fontSize: 13,
              ),
              decoration: InputDecoration(
                hintText: '冒険者IDを入力...',
                hintStyle: TextStyle(
                  color: colors.textMuted,
                  fontSize: 12,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          GestureDetector(
            onTap: onSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '検索',
                style: TextStyle(
                  color: colors.background,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}