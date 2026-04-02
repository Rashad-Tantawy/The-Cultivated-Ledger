import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';

/// Full-width primary gradient button from the design system.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 56,
        decoration: BoxDecoration(
          gradient: onPressed != null
              ? AppGradients.primaryButton
              : const LinearGradient(
                  colors: [Color(0xFF8CA88A), Color(0xFF8CA88A)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: onPressed != null ? AppShadows.primaryGlow : [],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.onPrimary,
                  ),
                )
              : Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.onPrimary,
                  ),
                ),
        ),
      ),
    );
  }
}
