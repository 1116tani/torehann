// lib/models/health/health_topic_model.dart

import 'package:flutter/material.dart';

class HealthTopicModel {
  final String title;        // アドバイスのタイトル（例：「素晴らしい歩行ペース！」）
  final String description;  // 具体的な説明文（例：「この調子で歩くと脂肪燃焼効率がUPします」）
  final IconData icon;       // 画面に飾る可愛いアイコン

  const HealthTopicModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}