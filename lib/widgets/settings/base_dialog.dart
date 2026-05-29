// lib/widgets/settings/base_dialog.dart

import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  final String title;
  final Widget child;

  const BaseDialog({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2C2318),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF4A3728), width: 1.5),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFF5EDD8),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF7A5C3A), size: 24),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
              const Divider(color: Color(0xFF4A3728), height: 24, thickness: 1.0),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
