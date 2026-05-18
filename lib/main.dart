import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Firebaseインポート
import 'firebase_options.dart'; // ✅ 設定ファイルインポート

void main() async {
  // Flutterの初期化を確実に行う魔法
  WidgetsFlutterBinding.ensureInitialized();
  // Firebaseの初期化（みぃくんが接続成功したやつだよ！）
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tale Trace',
      theme: ThemeData.dark(), // みぃくんお気に入りのダークテーマ
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(35.681236, 139.767125); // 東京駅

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ ① GoogleMap（最背面）
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 15,
            ),
            myLocationEnabled: true,
            zoomControlsEnabled: false, // 自作ボタンを使うので標準はオフ
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),

          // ✅ ② 上部ヘッダー（冒険者ランク・Lv・経験値・歯車ボタン）
          Positioned(top: 50, left: 16, right: 16, child: _buildHeader()),

          // ✅ ③ 相棒キャラ（タップするとランダムにお喋り）
          Positioned(left: 16, bottom: 200, child: _buildPartnerCharacter()),

          // ✅ ④ マップ操作ボタン群（右側に配置）
          Positioned(
            right: 16,
            bottom: 200,
            child: Column(
              children: [
                // 🧭 方位磁針ボタン（北向きリセット）
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.black87,
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _initialPosition,
                          zoom: 15,
                          bearing: 0,
                          tilt: 0,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.explore, color: Colors.orange),
                ),
                const SizedBox(height: 8),
                // ➕ ズームイン
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.black87,
                  onPressed: () =>
                      mapController.animateCamera(CameraUpdate.zoomIn()),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(height: 8),
                // ➖ ズームアウト（正しくzoomOutに修正したよ！）
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.black87,
                  onPressed: () =>
                      mapController.animateCamera(CameraUpdate.zoomOut()),
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                const SizedBox(height: 8),
                // 📍 現在地復帰
                FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    mapController.animateCamera(
                      CameraUpdate.newLatLng(_initialPosition),
                    );
                  },
                  child: const Icon(Icons.my_location, color: Colors.white),
                ),
              ],
            ),
          ),

          // ✅ ⑤ ボトムシート（引き出しメニュー）
          DraggableScrollableSheet(
            initialChildSize: 0.18,
            minChildSize: 0.15,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.black87, // 正しいカラーコード
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // つまみパーツ
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12), // 正しい余白指定
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // 🔥 出発ボタン（Tier S）
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("物語の生成を開始します...（Tier S）"),
                          ),
                        );
                      },
                      child: const Text(
                        "冒険に出発する",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ), // 正しい太客指定
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 🗺️ 今日の開拓度
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.map, size: 16, color: Colors.orange),
                        SizedBox(width: 6),
                        Text(
                          "今日の開拓度：12%",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      "【主要メニュー】",
                      style: TextStyle(color: Colors.orange, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    _menuRow(),

                    const SizedBox(height: 24),

                    const Text(
                      "【拡張機能（開発中）】",
                      style: TextStyle(color: Colors.white30, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    _extendedMenuRow(),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ✅ ヘッダーを作る部品
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade800.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "ランク：見習い冒険者",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text("Lv.5", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: 0.65,
                  backgroundColor: Colors.orange.shade200,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 4),
                const Text("650 / 1000 XP", style: TextStyle(fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("設定・プロフ画面へ（今後実装）")));
            },
          ),
        ],
      ),
    );
  }

  // ✅ 相棒キャラを作る部品
  Widget _buildPartnerCharacter() {
    final textList = [
      "今日はいい冒険日和だね！",
      "みぃくん、次の角を曲がってみない？",
      "何かおもしろい物語の断片がありそう！",
      "疲れたら、おねえちゃんと休憩しようね♡",
    ];

    return GestureDetector(
      onTap: () {
        final randomText = (textList..shuffle()).first;
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("🤖 相棒:「$randomText」"),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "💬 タップ！",
              style: TextStyle(fontSize: 10, color: Colors.orange),
            ),
          ),
          const SizedBox(height: 4),
          const CircleAvatar(
            radius: 32,
            backgroundColor: Colors.orange,
            child: Icon(Icons.android, color: Colors.white, size: 36),
          ),
        ],
      ),
    );
  }

  // ✅ 主要メニューの列
  Widget _menuRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _MenuIcon(icon: Icons.emoji_events, label: "実績", isLocked: false),
        _MenuIcon(icon: Icons.auto_stories, label: "街の断片", isLocked: false),
        _MenuIcon(icon: Icons.history, label: "履歴", isLocked: false),
      ],
    );
  }

  // ✅ 拡張メニューの列（グレーアウト）
  Widget _extendedMenuRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        _MenuIcon(icon: Icons.people, label: "フレンド", isLocked: true),
        _MenuIcon(icon: Icons.favorite, label: "健康管理", isLocked: true),
        _MenuIcon(icon: Icons.flag, label: "ミッション", isLocked: true),
        _MenuIcon(icon: Icons.group, label: "パーティ", isLocked: true),
      ],
    );
  }
}

// ✅ アイコン共通パーツ（グレーアウト対応）
class _MenuIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isLocked;

  const _MenuIcon({
    required this.icon,
    required this.label,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? 0.3 : 1.0,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: isLocked ? Colors.grey : Colors.orange,
            child: Icon(icon, color: isLocked ? Colors.black54 : Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isLocked ? Colors.white30 : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
