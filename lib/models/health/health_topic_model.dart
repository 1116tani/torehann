// lib/models/health/health_topic_model.dart

import 'package:flutter/material.dart';

class HealthTopicModel {
  final String title;
  final String description;
  final IconData icon;

  const HealthTopicModel({
    required this.title,
    required this.description,
    required this.icon,
  });
}