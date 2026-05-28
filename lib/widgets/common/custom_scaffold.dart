// lib/widgets/common/custom_scaffold.dart

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

class CustomScaffold extends StatelessWidget {
  final Widget child;

  final String? title;

  final List<Widget>? actions;

  final Widget? floatingActionButton;

  final bool showBackButton;

  final EdgeInsetsGeometry? padding;

  final bool useSafeArea;

  final Widget? bottomNavigationBar;

  const CustomScaffold({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showBackButton = true,
    this.padding,
    this.useSafeArea = true,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: padding ?? const EdgeInsets.all(AppSizes.p16),
      child: child,
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      extendBody: true,

      appBar: title != null
          ? AppBar(
              automaticallyImplyLeading: false,

              leading: showBackButton
                  ? Padding(
                      padding: const EdgeInsets.only(left: AppSizes.p8),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    )
                  : null,

              title: Text(title!, style: AppTextStyles.titleMedium),

              actions: actions,
            )
          : null,

      floatingActionButton: floatingActionButton,

      bottomNavigationBar: bottomNavigationBar,

      body: useSafeArea ? SafeArea(child: body) : body,
    );
  }
}
