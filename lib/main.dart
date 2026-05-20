// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tale_trace/firebase_options.dart';
import 'package:tale_trace/pages/home_page.dart';
import 'package:tale_trace/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tale Trace',

      // ✅ テーマ修正
      theme: AppTheme.darkTheme,

      debugShowCheckedModeBanner: false,

      // ✅ 最初の画面
      home: const HomeScreen(),
    );
  }
}
