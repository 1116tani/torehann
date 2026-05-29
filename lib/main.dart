// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

import 'router/app_router.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔑 環境変数の読み込み
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('.env ファイルの読み込みに失敗しました: $e');
  }

  // Firebase 初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tale Trace',

      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.darkTheme,

      // Router
      routerConfig: appRouter,
    );
  }
}