// lib/widgets/settings/location_pin_modal.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/settings_provider.dart';
import 'base_dialog.dart';

class LocationPinModal extends ConsumerStatefulWidget {
  const LocationPinModal({super.key});

  @override
  ConsumerState<LocationPinModal> createState() => _LocationPinModalState();
}

class _LocationPinModalState extends ConsumerState<LocationPinModal> {
  late TextEditingController _homeController;
  late TextEditingController _workController;
  late TextEditingController _favoriteController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _homeController = TextEditingController(text: settings.homeLocation);
    _workController = TextEditingController(text: settings.workLocation);
    _favoriteController = TextEditingController(text: settings.favoriteLocation);
  }

  @override
  void dispose() {
    _homeController.dispose();
    _workController.dispose();
    _favoriteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(settingsProvider.notifier);

    return BaseDialog(
      title: '📍 保存地点（場所ピン）',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '自宅エリア',
            style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _homeController,
            hint: '例: 渋谷・目黒、または住所',
            onChanged: notifier.updateHomeLocation,
          ),
          const SizedBox(height: 20),
          const Text(
            '学校 / 会社',
            style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _workController,
            hint: '例: 新宿、または住所',
            onChanged: notifier.updateWorkLocation,
          ),
          const SizedBox(height: 20),
          const Text(
            '気になる場所',
            style: TextStyle(color: Color(0xFFC8A97A), fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _favoriteController,
            hint: '例: 代々木公園、または住所',
            onChanged: notifier.updateFavoriteLocation,
          ),
          const SizedBox(height: 24),
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF8B7355), size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '保存した場所は、AIルート生成時に優先的なスポット候補の基準として考慮されます。',
                  style: TextStyle(color: Color(0xFF8B7355), fontSize: 12, height: 1.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Color(0xFFF5EDD8), fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
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
    );
  }
}
