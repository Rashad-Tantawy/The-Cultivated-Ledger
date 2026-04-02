import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Glassmorphism top app bar — surface at 85% opacity + 12px backdrop blur.
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GlassAppBar({super.key, this.trailing});

  final Widget? trailing;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64 + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: const BoxDecoration(
            color: Color(0xD9FAF9F8), // surface at ~85% opacity
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 12),
                blurRadius: 32,
                color: AppColors.shadowAmbient,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.agriculture_rounded,
                        color: AppColors.primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'The Cultivated Ledger',
                      style: GoogleFonts.manrope(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
