// lib/widgets/common/custom_app_bar.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final List<Widget>? actions;

  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.p12,
        AppSizes.p8,
        AppSizes.p12,
        0,
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),

        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),

          child: AppBar(
            automaticallyImplyLeading: false,

            backgroundColor: AppColors.sheetBackground,

            elevation: 0,

            centerTitle: true,

            surfaceTintColor: Colors.transparent,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.xl),

              side: const BorderSide(color: AppColors.glassBorder),
            ),

            leading: showBackButton && context.canPop()
                ? Padding(
                    padding: const EdgeInsets.only(left: AppSizes.p8),

                    child: IconButton(
                      onPressed: () {
                        context.pop();
                      },

                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,

                        color: AppColors.textPrimary,

                        size: AppSizes.iconS,
                      ),
                    ),
                  )
                : null,

            title: Text(title, style: AppTextStyles.titleSmall),

            actions: actions,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 72);
}
