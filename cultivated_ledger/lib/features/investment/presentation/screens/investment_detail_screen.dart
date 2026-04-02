import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Investment Detail screen — individual cattle listing detail.
///
/// Design reference: stitch/cow_listing_detail/
/// Reached from: InvestorDashboard "Invest Now" tap, or FarmerDashboard "View Details" tap.
///
/// investmentId path param (0, 1, 2) selects which investment to display.
class InvestmentDetailScreen extends StatelessWidget {
  const InvestmentDetailScreen({super.key, required this.investmentId});
  final int investmentId;

  // ── Static investment data ────────────────────────────────────────────────
  static const _investments = [
    (
      title: 'Angus Select Batch #042',
      subtitle:
          'Premium Black Angus cattle investment in the fertile grazing lands of the Montana High Plains.',
      location: 'Montana High Plains',
      roi: '15.2%',
      roiAmount: '+\$9.80 / share',
      price: '\$1,250',
      totalShares: '120',
      remainingShares: '42',
      progress: 0.65,
      breed: 'Black Angus',
      age: '22 Months',
      healthScore: '97/100',
      weight: '1,180 lbs',
      farmerId: 0,
      farmerName: 'Silas Thorne',
      farmerRating: '4.98 (240 Investments)',
      maturityMonths: '14 Months',
      marketReady: 'Nov 2025',
      riskItems: [
        (icon: Icons.health_and_safety_outlined, title: 'Comprehensive Insurance',
          desc: 'Full loss protection coverage against disease or mortality.'),
        (icon: Icons.sensors_outlined, title: 'Biometric Tracking',
          desc: '24/7 health monitoring via wearable IoT collars.'),
      ],
    ),
    (
      title: 'Hereford Heritage #019',
      subtitle:
          'Heritage Hereford cattle raised on certified regenerative pasture in the Verde Valley farming district.',
      location: 'Verde Valley Farms',
      roi: '13.8%',
      roiAmount: '+\$7.60 / share',
      price: '\$980',
      totalShares: '150',
      remainingShares: '75',
      progress: 0.50,
      breed: 'Hereford',
      age: '18 Months',
      healthScore: '95/100',
      weight: '1,050 lbs',
      farmerId: 1,
      farmerName: 'Elena Rodriguez',
      farmerRating: '5.0 (86 Investments)',
      maturityMonths: '16 Months',
      marketReady: 'Jan 2026',
      riskItems: [
        (icon: Icons.health_and_safety_outlined, title: 'Full Asset Insurance',
          desc: 'Comprehensive coverage through Verde Valley Organics Insurance Plan.'),
        (icon: Icons.eco_outlined, title: 'Organic Certification',
          desc: 'USDA Certified Organic herd with quarterly audits.'),
      ],
    ),
    (
      title: 'Brahman Specialty #10',
      subtitle:
          'Specialist Brahman cattle investment operating across regenerative Highland pasture with heritage breeding.',
      location: 'Miller Ranchlands',
      roi: '16.5%',
      roiAmount: '+\$12.25 / share',
      price: '\$2,100',
      totalShares: '60',
      remainingShares: '18',
      progress: 0.70,
      breed: 'Brahman',
      age: '20 Months',
      healthScore: '99/100',
      weight: '1,320 lbs',
      farmerId: 2,
      farmerName: 'Arthur Miller',
      farmerRating: '4.8 (210 Investments)',
      maturityMonths: '12 Months',
      marketReady: 'Sep 2025',
      riskItems: [
        (icon: Icons.health_and_safety_outlined, title: 'Highlands Agricultural Board Audit',
          desc: 'Independently audited by the Highlands Agricultural Board quarterly.'),
        (icon: Icons.sensors_outlined, title: 'GPS & Health Monitoring',
          desc: 'Real-time herd tracking with biometric health sensors.'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final inv = _investments[investmentId.clamp(0, _investments.length - 1)];

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBody: true,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 80)),

              // Breadcrumb
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back_rounded,
                            size: 16, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text(
                          'Back to Marketplace',
                          style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Hero image ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _HeroImage(investmentId: investmentId),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Metadata grid ─────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _MetadataGrid(inv: inv),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Investment sidebar card ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _InvestmentCard(inv: inv),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Verified farmer card ───────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _VerifiedFarmerCard(inv: inv),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // ── ROI Analysis ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _RoiAnalysis(inv: inv),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // ── Fixed top bar ──────────────────────────────────────────────
          _TopBar(),
        ],
      ),
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

// ── Top app bar ───────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 64 + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 24,
              right: 24,
            ),
            color: AppColors.surface.withValues(alpha: 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.agriculture_rounded,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'The Cultivated Ledger',
                      style: AppTextStyles.headlineMd.copyWith(
                        fontSize: 18,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_outlined,
                          color: AppColors.secondary, size: 22),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person_outline_rounded,
                          color: AppColors.secondary, size: 22),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Hero image ────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.investmentId});
  final int investmentId;

  static const _colors = [
    AppColors.surfaceContainerHigh,
    AppColors.surfaceContainer,
    AppColors.surfaceContainerHighest,
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          Container(
            height: 240,
            width: double.infinity,
            color: _colors[investmentId.clamp(0, 2)],
            child: const Center(
              child: Icon(Icons.landscape_rounded,
                  size: 72, color: AppColors.outlineVariant),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.tertiaryContainer,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_rounded,
                      size: 14, color: AppColors.onTertiaryContainer),
                  const SizedBox(width: 6),
                  Text(
                    'VERIFIED ASSET',
                    style: AppTextStyles.labelXs.copyWith(
                      color: AppColors.onTertiaryContainer,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Metadata grid ─────────────────────────────────────────────────────────────

class _MetadataGrid extends StatelessWidget {
  const _MetadataGrid({required this.inv});
  final dynamic inv;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.4,
      children: [
        _MetaTile(label: 'Breed', value: inv.breed),
        _MetaTile(label: 'Age', value: inv.age),
        _MetaTile(label: 'Health Score', value: inv.healthScore,
            valueColor: AppColors.primary),
        _MetaTile(label: 'Weight', value: inv.weight),
      ],
    );
  }
}

class _MetaTile extends StatelessWidget {
  const _MetaTile(
      {required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelXs.copyWith(
              color: AppColors.secondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.headlineSm.copyWith(
              fontSize: 16,
              color: valueColor ?? AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Investment card ───────────────────────────────────────────────────────────

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({required this.inv});
  final dynamic inv;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.ambientCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            inv.title,
            style: AppTextStyles.headlineLg.copyWith(
              fontSize: 26,
              letterSpacing: -0.5,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            inv.subtitle,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 24),

          // Price / remaining row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SHARE PRICE',
                    style: AppTextStyles.labelXs.copyWith(
                      color: AppColors.secondary, letterSpacing: 1.5),
                  ),
                  Text(
                    inv.price,
                    style: AppTextStyles.headlineLg.copyWith(
                      color: AppColors.primary, fontSize: 32,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'REMAINING',
                    style: AppTextStyles.labelXs.copyWith(
                      color: AppColors.secondary, letterSpacing: 1.5),
                  ),
                  Text(
                    '${inv.remainingShares} / ${inv.totalShares}',
                    style: AppTextStyles.headlineMd.copyWith(
                      color: AppColors.onSurface, fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
              height: 1,
              color: AppColors.outlineVariant.withValues(alpha: 0.15)),
          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: inv.progress,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${((1 - inv.progress) * 100).round()}% of shares still available',
            style: AppTextStyles.labelXs.copyWith(
              color: AppColors.onSurfaceVariant, letterSpacing: 0.5),
          ),
          const SizedBox(height: 24),

          // Buy button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppGradients.primaryButton,
                borderRadius: BorderRadius.circular(8),
                boxShadow: AppShadows.primaryGlow,
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Buy Shares Now',
                  style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'Secure transaction via The Cultivated Ledger Escrow',
              style: AppTextStyles.labelXs.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Verified farmer card ──────────────────────────────────────────────────────

class _VerifiedFarmerCard extends StatelessWidget {
  const _VerifiedFarmerCard({required this.inv});
  final dynamic inv;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        'farmer-dashboard',
        pathParameters: {'id': inv.farmerId.toString()},
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded,
                  size: 30, color: AppColors.outlineVariant),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ASSET MANAGER',
                    style: AppTextStyles.labelXs.copyWith(
                      color: AppColors.secondary, letterSpacing: 1.5),
                  ),
                  Text(
                    inv.farmerName,
                    style: AppTextStyles.headlineSm.copyWith(
                        fontSize: 16, color: AppColors.onSurface),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 12, color: AppColors.tertiary),
                      const SizedBox(width: 4),
                      Text(
                        inv.farmerRating,
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.tertiary, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: const Icon(Icons.verified_user_rounded,
                  color: AppColors.primary, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}

// ── ROI Analysis ──────────────────────────────────────────────────────────────

class _RoiAnalysis extends StatelessWidget {
  const _RoiAnalysis({required this.inv});
  final dynamic inv;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Expected ROI Analysis',
              style: AppTextStyles.headlineMd.copyWith(
                fontSize: 22, letterSpacing: -0.3),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Main ROI card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.primaryFixed,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PROJECTED ANNUAL RETURN',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onPrimaryFixed.withValues(alpha: 0.7),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    inv.roi,
                    style: AppTextStyles.displayLg.copyWith(
                      color: AppColors.onPrimaryFixed,
                      fontSize: 56,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Based on current market valuations, feeding efficiency, and historic yield performance for this specific bloodline and region.',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onPrimaryFixedVariant,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: -16,
                right: -16,
                child: Icon(
                  Icons.trending_up_rounded,
                  size: 100,
                  color: AppColors.onPrimaryFixed.withValues(alpha: 0.08),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Maturity timeline card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MATURITY TIMELINE',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.secondary, letterSpacing: 1.5),
              ),
              const SizedBox(height: 16),
              _TimelineRow(label: 'Growth Phase', value: inv.maturityMonths),
              const SizedBox(height: 12),
              _TimelineRow(label: 'Market Readiness', value: inv.marketReady),
              const SizedBox(height: 12),
              _TimelineRow(
                  label: 'Exit Dividend',
                  value: inv.roiAmount,
                  valueColor: AppColors.primary),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded,
                    size: 16, color: AppColors.primary),
                label: Text(
                  'Download Full Prospectus',
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.primary, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Risk factors
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SECURITY & RISK',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.secondary, letterSpacing: 1.5),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                inv.riskItems.length,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(inv.riskItems[i].icon,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inv.riskItems[i].title,
                              style: AppTextStyles.labelLg.copyWith(
                                color: AppColors.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              inv.riskItems[i].desc,
                              style: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.onSurfaceVariant,
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Historical comparison
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.ambientCard,
                ),
                child: const Icon(Icons.analytics_outlined,
                    color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Historical Comparison',
                      style: AppTextStyles.headlineSm.copyWith(
                          fontSize: 15, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'This investment tracks 1.4% higher than the 5-year average for Grade A assets in this territory.',
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow(
      {required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: AppTextStyles.labelLg.copyWith(
            color: valueColor ?? AppColors.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ── Bottom nav bar ────────────────────────────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: AppColors.surface.withValues(alpha: 0.85),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(icon: Icons.home_rounded, label: 'Home',
                      isActive: false,
                      onTap: () => context.go('/investor/home')),
                  _NavItem(icon: Icons.search_rounded, label: 'Search',
                      isActive: true, onTap: () {}),
                  _NavItem(icon: Icons.account_balance_wallet_outlined,
                      label: 'Investments', isActive: false, onTap: () {}),
                  _NavItem(icon: Icons.person_outline_rounded,
                      label: 'Profile', isActive: false, onTap: () {}),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.icon, required this.label,
      required this.isActive, required this.onTap});
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22,
                color: isActive ? AppColors.onPrimary : AppColors.secondary),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: AppTextStyles.labelXs.copyWith(
                color: isActive ? AppColors.onPrimary : AppColors.secondary,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
