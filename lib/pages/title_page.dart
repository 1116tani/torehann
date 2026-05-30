// lib/pages/title_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../router/route_names.dart';

class TitlePage extends ConsumerStatefulWidget {
  const TitlePage({super.key});

  @override
  ConsumerState<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends ConsumerState<TitlePage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            const Text(
              'Treasure Navigation',
              style: TextStyle(
                color: Color(0xFFF5EDD8),
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'あなたの歩みが、世界の物語になる',
              style: TextStyle(
                color: Color(0xFFC8A97A),
                fontSize: 13,
                letterSpacing: 1.1,
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFB8860B),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        setState(() => _isLoading = true);

                        final result = await ref
                            .read(authControllerProvider)
                            .signInAnonymously();

                        if (!context.mounted) return;

                        if (result != null) {
                          context.go(AppRoutes.home);
                          return;
                        }

                        setState(() => _isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('匿名ログインに失敗しました。通信環境を確認してください。'),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2318),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFFB8860B),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFB8860B,
                              ).withValues(alpha: 0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Text(
                          '冒険の書を作成する',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFF5EDD8),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              '※面倒な登録なしで、すぐに遊べます',
              style: TextStyle(
                color: const Color(0xFF7A5C3A).withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
