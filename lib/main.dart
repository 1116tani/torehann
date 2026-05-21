// lib/main.dart
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart'; // 一旦お休み
import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:tale_trace/firebase_options.dart'; // 一旦お休み
import 'package:tale_trace/themes/app_theme.dart';
import 'package:tale_trace/router/app_router.dart';

void main() async {
  // 💡 Flutterの初期化だけは絶対に行うよ！
  WidgetsFlutterBinding.ensureInitialized();

  // 💡 Firebaseの初期化をコメントアウトして完全にスキップ！
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Tale Trace',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
