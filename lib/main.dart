// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

import 'router/app_router.dart';
import 'themes/app_theme.dart';
import 'services/local_storage_service.dart';
import 'providers/settings_provider.dart';

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

  // 📦 SharedPreferences初期化
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeSetting = ref.watch(settingsProvider.select((s) => s.themeMode));

    // 'adventure' or 'default' -> dark, 'daylight' -> light
    final isDaylight = themeModeSetting == 'daylight';

    return MaterialApp.router(
      title: 'Tale Trace',

      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDaylight ? ThemeMode.light : ThemeMode.dark,

      // Router
      routerConfig: appRouter,
    );
  }
}