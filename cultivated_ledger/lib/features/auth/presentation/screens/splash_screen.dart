import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Splash / Landing screen.
///
/// Design reference: stitch_v1/splash_screen/
///
/// Layout:
///  • Background: surface + skewed surfaceContainerLow tonal layer
///  • Logo cluster (primary square icon + brand name + "Agricultural Private Equity")
///  • Hero headline "Growing Heritage, / Investing in Growth."
///  • Subtext
///  • Two CTAs: "Begin Your Portfolio" (primary gradient) + "Explore Markets" (secondary)
///  • Floating glass card with Current Yield Index
///  • Footer links
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // ── Tonal background layers ────────────────────────────────────
          _BackgroundDecoration(size: size),

          // ── Main scroll content ───────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Logo cluster
                  const _LogoCluster(),
                  const SizedBox(height: 40),

                  // Hero headline
                  const _HeroHeadline(),
                  const SizedBox(height: 20),

                  // Subtext
                  Text(
                    "Precision data meets generational wisdom. Secure your future in the world's most resilient asset class.",
                    style: AppTextStyles.bodyLg.copyWith(
                      color: AppColors.onSurfaceVariant,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // CTAs
                  const _CtaButtons(),
                  const SizedBox(height: 40),

                  // Floating data card
                  const _YieldCard(),
                  const SizedBox(height: 40),

                  // Footer
                  const _FooterLinks(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Decorative grain icon top-right
          const Positioned(
            top: 48,
            right: -16,
            child: Opacity(
              opacity: 0.08,
              child: Icon(
                Icons.filter_vintage_rounded,
                size: 120,
                color: AppColors.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Background decoration ────────────────────────────────────────────────────

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration({required this.size});
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Skewed surfaceContainerLow panel (top-right)
          Positioned(
            top: 0,
            right: -size.width * 0.3,
            width: size.width * 0.7,
            height: size.height,
            child: Transform(
              alignment: Alignment.topRight,
              transform: Matrix4.skewX(-0.21), // -skew-x-12 ≈ -0.21rad
              child: Container(
                color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
              ),
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  AppColors.surface,
                  Colors.transparent,
                  AppColors.surfaceContainerLow.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Logo cluster ─────────────────────────────────────────────────────────────

class _LogoCluster extends StatelessWidget {
  const _LogoCluster();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Primary square icon
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 12),
                blurRadius: 32,
                color: AppColors.shadowPrimary,
              ),
            ],
          ),
          child: const Icon(
            Icons.agriculture_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The Cultivated Ledger',
              style: AppTextStyles.headlineMd.copyWith(
                color: AppColors.primary,
                letterSpacing: -0.5,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'AGRICULTURAL PRIVATE EQUITY',
              style: AppTextStyles.labelXs.copyWith(
                color: AppColors.secondary,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Hero headline ─────────────────────────────────────────────────────────────

class _HeroHeadline extends StatelessWidget {
  const _HeroHeadline();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.displayLg.copyWith(
          fontSize: 44,
          height: 1.1,
        ),
        children: const [
          TextSpan(
            text: 'Growing\nHeritage,\n',
            style: TextStyle(color: AppColors.onBackground),
          ),
          TextSpan(
            text: 'Investing in\nGrowth.',
            style: TextStyle(color: AppColors.primaryContainer),
          ),
        ],
      ),
    );
  }
}

// ── CTA buttons ──────────────────────────────────────────────────────────────

class _CtaButtons extends StatelessWidget {
  const _CtaButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary: Begin Your Portfolio
        GestureDetector(
          onTap: () {
            // TODO: navigate to sign up
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryButton,
              borderRadius: BorderRadius.circular(6),
              boxShadow: AppShadows.primaryGlow,
            ),
            child: Center(
              child: Text(
                'Begin Your Portfolio',
                style: AppTextStyles.labelLg.copyWith(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.onPrimary,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Secondary: Explore Markets
        GestureDetector(
          onTap: () {
            // TODO: navigate to marketplace
          },
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(
                'Explore Markets',
                style: AppTextStyles.labelLg.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.onSurface,
                  letterSpacing: 0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Floating yield card ───────────────────────────────────────────────────────

class _YieldCard extends StatelessWidget {
  const _YieldCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          // Hero image placeholder (grayscale tinted)
          Container(
            height: 260,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Image would go here via CachedNetworkImage in production
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.surfaceContainerHigh,
                        AppColors.surfaceContainer,
                      ],
                    ),
                  ),
                ),
                // Illustration overlay
                const Center(
                  child: Icon(
                    Icons.landscape_rounded,
                    size: 80,
                    color: AppColors.outlineVariant,
                  ),
                ),
              ],
            ),
          ),

          // Glassmorphism data card at the bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _GlassYieldCard(),
          ),
        ],
      ),
    );
  }
}

class _GlassYieldCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest.withValues(alpha: 0.85),
            border: Border(
              top: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT YIELD INDEX',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.secondary,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+14.2%',
                        style: AppTextStyles.headlineLg.copyWith(
                          color: AppColors.onBackground,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Divider(
                color: AppColors.onSurface.withValues(alpha: 0.05),
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _Tag(
                    label: 'Verified Assets',
                    bg: AppColors.tertiaryContainer.withValues(alpha: 0.30),
                    fg: AppColors.onTertiaryContainer,
                  ),
                  _Tag(
                    label: 'Sustainable',
                    bg: AppColors.primaryFixed.withValues(alpha: 0.30),
                    fg: AppColors.onPrimaryFixedVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.labelXs.copyWith(
          color: fg,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

// ── Footer links ──────────────────────────────────────────────────────────────

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: 24,
              children: ['Methodology', 'Global Soil Data', 'Legal']
                  .map(
                    (t) => Text(
                      t.toUpperCase(),
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 1,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.public, size: 14, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 4),
            Text(
              'London — Chicago — São Paulo',
              style: AppTextStyles.labelSm
                  .copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }
}
