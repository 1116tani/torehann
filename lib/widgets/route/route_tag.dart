// lib/widgets/route/route_tag.dart

import 'package:flutter/material.dart';

class RouteTag extends StatelessWidget {
  final String label; // 例：'#カフェ'

  const RouteTag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF3D2B1F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC8A97A), width: 0.5),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFC8A97A),
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
