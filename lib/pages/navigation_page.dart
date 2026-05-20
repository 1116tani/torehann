import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF4F5540),
      body: SafeArea(
        child: Stack(
          children: [
            // 仮マップ
            Positioned.fill(
              child: Container(
                color:const Color(0xFF6F755A),
                child:const Center(
                  child: Text(
                    'MAP AREA',
                    style:TextStyle(color:Colors.white54,fontSize: 28),
                  ),
                ),
              ),
            ),

            // 上のルート案内
            Positioned(
              top:20,
              left:20,
              right:20,
              child:Container(
                padding:const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:const Color(0xFF8A4B00).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  border:Border.all(color: Colors.orange, width: 1),
                ),
                child: const Text(
                  '次の目的地：風の広場（中央公園）方面',
                  style: TextStyle(
                    color:Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 中央ピン
            const Center(
              child: Icon(
                Icons.location_on,
                color: Colors.redAccent,
                size: 48,
              ),
            ),

            // 吹き出し
            Positioned(
              right: 24,
              bottom: 150,
              child: Container(
                width: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3D0),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'あそこに宝の気配がするよ！',
                  style: TextStyle(
                    color: Color(0xFF4A2A00),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // 下ステータス
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3D0),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('歩いた距離\n0.8km', textAlign: TextAlign.center),
                        Text('見つけた宝物\n0/2', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        context.go('/result');
                      },
                      child: const Text(
                        '冒険を終了してリザルトへ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
