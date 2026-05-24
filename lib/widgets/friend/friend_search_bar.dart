// lib/widgets/friend/search_bar.dart

import 'package:flutter/material.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2318),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF5C4033),
          width: 0.6,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Color(0xFFC8A97A),
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                hintText: '冒険者IDを入力...',
                hintStyle: TextStyle(
                  color: Color(0xFF7A5C3A),
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
                color: const Color(0xFFB8860B),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                '検索',
                style: TextStyle(
                  color: Colors.white,
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