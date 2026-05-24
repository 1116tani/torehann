// lib/widgets/party/party_action_button.dart

import 'package:flutter/material.dart';

class PartyActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData icon;
  final bool isEnabled;

  const PartyActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: isEnabled ? 1.0 : 0.45,

      child: GestureDetector(
        onTap: isEnabled ? onTap : null,

        child: Container(
          width: double.infinity,
          height: 58,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            gradient: isEnabled
                ? const LinearGradient(
                    colors: [
                      Color(0xFFB8860B),
                      Color(0xFFD4AF37),
                    ],
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFF4A3728),
                      Color(0xFF3A2A1F),
                    ],
                  ),

            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: const Color(0xFFB8860B)
                          .withValues(alpha: 0.28),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),

              const SizedBox(width: 10),

              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}