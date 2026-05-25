import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;
  final String? title;

  final List<Widget>? actions;

  final Widget? floatingActionButton;

  final bool showBackButton;

  const CustomScaffold({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1610),

      appBar: title != null
          ? AppBar(
              backgroundColor: const Color(0xFF2C2318),
              elevation: 0,
              centerTitle: true,

              leading: showBackButton
                  ? IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFC8A97A),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  : null,

              title: Text(
                title!,
                style: const TextStyle(
                  color: Color(0xFFF5EDD8),
                  fontWeight: FontWeight.bold,
                ),
              ),

              actions: actions,
            )
          : null,

      floatingActionButton: floatingActionButton,

      body: SafeArea(
        child: child,
      ),
    );
  }
}