// lib/widgets/settings/profile_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import 'base_dialog.dart';

class ProfileModal extends ConsumerStatefulWidget {
  const ProfileModal({super.key});

  @override
  ConsumerState<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends ConsumerState<ProfileModal> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _nameController = TextEditingController(text: settings.userName);
    _ageController = TextEditingController(text: settings.age.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return BaseDialog(
      title: '👤 冒険者プロフィール',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '冒険者名',
            style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            onChanged: notifier.updateUserName,
            style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 16),
            decoration: InputDecoration(
              hintText: '名前を入力してください',
              hintStyle: const TextStyle(color: Color(0xFF5C4033)),
              filled: true,
              fillColor: const Color(0xFF1C1610),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4A3728)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4A3728)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFC8A97A), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '年齢',
            style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _ageController,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              final age = int.tryParse(val) ?? 0;
              notifier.updateAge(age);
            },
            style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 16),
            decoration: InputDecoration(
              hintText: '年齢を入力してください',
              hintStyle: const TextStyle(color: Color(0xFF5C4033)),
              filled: true,
              fillColor: const Color(0xFF1C1610),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4A3728)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4A3728)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFC8A97A), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '1日の距離目標',
                style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                '${settings.dailyGoalKm.toStringAsFixed(1)} km',
                style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFC8A97A),
              inactiveTrackColor: const Color(0xFF4A3728),
              thumbColor: const Color(0xFFC8A97A),
              overlayColor: const Color(0xFFC8A97A).withValues(alpha: 0.12),
              valueIndicatorColor: const Color(0xFF4A3728),
              valueIndicatorTextStyle: const TextStyle(color: Color(0xFFF5EDD8)),
            ),
            child: Slider(
              value: settings.dailyGoalKm.clamp(1.0, 20.0),
              min: 1.0,
              max: 20.0,
              divisions: 19,
              label: '${settings.dailyGoalKm.toStringAsFixed(1)}km',
              onChanged: (val) {
                notifier.updateDailyGoalKm(val);
              },
            ),
          ),
          Center(
            child: Text(
              '目安歩数: ${settings.dailyStepGoal} 歩',
              style: const TextStyle(color: Color(0xFF8B7355), fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
