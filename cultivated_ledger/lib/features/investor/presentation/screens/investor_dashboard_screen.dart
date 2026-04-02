import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Investor Dashboard — "Explore Products" landing screen.
///
/// Design reference: stitch/investor_dashboard/
///
/// Layout:
///  • Fixed glassmorphism top app bar (logo + notification bell)
///  • Portfolio Summary bento hero (large green card + small white card)
///  • Top Rated Farmers horizontal scroll
///  • Active Opportunities vertical list
///  • Bottom nav bar
///  • FAB (quick invest)
class InvestorDashboardScreen extends StatelessWidget {
  const InvestorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBody: true,
      body: Stack(
        children: [
          // ── Scrollable main content ───────────────────────────────────────
          CustomScrollView(
            slivers: [
              // Space for fixed top bar
              const SliverToBoxAdapter(child: SizedBox(height: 80)),

              // Portfolio hero
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _PortfolioHero(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // Top Rated Farmers
              const SliverToBoxAdapter(
                child: _FarmersSection(),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // Active Opportunities
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _OpportunitiesSection(),
                ),
              ),

              // Bottom padding (accounts for nav bar + FAB)
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // ── Fixed glassmorphism top app bar ───────────────────────────────
          const _TopAppBar(),
        ],
      ),

      // ── Bottom nav bar ────────────────────────────────────────────────────
      bottomNavigationBar: const _BottomNavBar(),

      // ── FAB ───────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.tertiary,
        foregroundColor: AppColors.onTertiary,
        elevation: 8,
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}

// ── Top app bar ───────────────────────────────────────────────────────────────

class _TopAppBar extends StatelessWidget {
  const _TopAppBar();

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
                // Logo
                Row(
                  children: [
                    const Icon(
                      Icons.agriculture_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'The Cultivated Ledger',
                      style: AppTextStyles.headlineMd.copyWith(
                        fontSize: 20,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                // Notification bell
                IconButton(
                  onPressed: () => context.pushNamed('notifications'),
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Portfolio hero ────────────────────────────────────────────────────────────

class _PortfolioHero extends StatelessWidget {
  const _PortfolioHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Large green card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                offset: Offset(0, 16),
                blurRadius: 40,
                color: AppColors.shadowPrimary,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Radial gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: RadialGradient(
                      center: Alignment.bottomRight,
                      radius: 1.4,
                      colors: [
                        Colors.white.withValues(alpha: 0.10),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL PORTFOLIO VALUE',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.60),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$248,500.00',
                    style: AppTextStyles.headlineXl.copyWith(
                      color: AppColors.onPrimary,
                      fontSize: 40,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _PortfolioStat(
                        label: 'Current ROI',
                        value: '+14.8%',
                        valueColor: AppColors.onPrimaryContainer,
                      ),
                      const SizedBox(width: 40),
                      _PortfolioStat(
                        label: 'Active Assets',
                        value: '124 Head',
                        valueColor: AppColors.onPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  TextButton(
                    onPressed: () => context.pushNamed('portfolio-detail'),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.surfaceContainerLowest,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'View Detailed Analytics',
                      style: AppTextStyles.labelLg.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Small white stats card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppShadows.ambientCard,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.10),
            ),
          ),
          child: Column(
            children: [
              _WalletRow(
                icon: Icons.account_balance_wallet_outlined,
                iconBg: AppColors.tertiaryContainer.withValues(alpha: 0.30),
                iconColor: AppColors.tertiary,
                label: 'Wallet Balance',
                value: '\$12,405.20',
                valueColor: AppColors.onBackground,
              ),
              const SizedBox(height: 20),
              Divider(
                height: 1,
                color: AppColors.surfaceContainerHigh,
              ),
              const SizedBox(height: 20),
              _WalletRow(
                icon: Icons.trending_up_rounded,
                iconBg: AppColors.primaryFixed.withValues(alpha: 0.30),
                iconColor: AppColors.primary,
                label: 'Monthly Yield',
                value: '+\$3,210.00',
                valueColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PortfolioStat extends StatelessWidget {
  const _PortfolioStat({
    required this.label,
    required this.value,
    required this.valueColor,
  });
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelXs.copyWith(
            color: AppColors.onPrimary.withValues(alpha: 0.60),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.headlineSm.copyWith(
            color: valueColor,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}

class _WalletRow extends StatelessWidget {
  const _WalletRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: AppTextStyles.headlineSm.copyWith(
                color: valueColor,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Top Rated Farmers ─────────────────────────────────────────────────────────

class _FarmersSection extends StatelessWidget {
  const _FarmersSection();

  static const _farmers = [
    (
      name: 'Silas Thorne',
      farm: 'Montana Highland Ranches',
      rating: '4.9',
      deals: '124',
      roi: '12.4% avg.',
    ),
    (
      name: 'Elena Rodriguez',
      farm: 'Verde Valley Organics',
      rating: '5.0',
      deals: '86',
      roi: '14.1% avg.',
    ),
    (
      name: 'Arthur Miller',
      farm: "Miller's Heritage Cattle",
      rating: '4.8',
      deals: '210',
      roi: '11.8% avg.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'OUR NETWORK',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.secondary,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Top Rated Farmers',
                    style: AppTextStyles.headlineMd.copyWith(
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _farmers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, i) => GestureDetector(
              onTap: () => context.pushNamed(
                'farmer-dashboard',
                pathParameters: {'id': i.toString()},
              ),
              child: _FarmerCard(farmer: _farmers[i]),
            ),
          ),
        ),
      ],
    );
  }
}

class _FarmerCard extends StatelessWidget {
  const _FarmerCard({required this.farmer});
  final ({
    String name,
    String farm,
    String rating,
    String deals,
    String roi,
  }) farmer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 24,
            color: Color(0x0A1A1C1C),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + verified badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 36,
                  color: AppColors.outlineVariant,
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.tertiaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    size: 14,
                    color: AppColors.onTertiaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            farmer.name,
            style: AppTextStyles.headlineSm.copyWith(
              fontSize: 15,
              color: AppColors.onBackground,
            ),
          ),
          Text(
            farmer.farm,
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.secondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 14, color: AppColors.tertiary),
              const SizedBox(width: 4),
              Text(
                farmer.rating,
                style: AppTextStyles.labelMd.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${farmer.deals} Deals)',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HISTORICAL ROI',
                  style: AppTextStyles.labelXs.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                Text(
                  farmer.roi,
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Active Opportunities ──────────────────────────────────────────────────────

class _OpportunitiesSection extends StatelessWidget {
  const _OpportunitiesSection();

  static const _opportunities = [
    (
      title: 'Angus Select Batch #042',
      location: 'Montana High Plains',
      roi: '15.2%',
      progress: 0.75,
      price: '\$1,250',
      shares: '42 / 120',
      isNew: true,
    ),
    (
      title: 'Hereford Heritage #019',
      location: 'Verde Valley Farms',
      roi: '13.8%',
      progress: 0.50,
      price: '\$980',
      shares: '75 / 150',
      isNew: false,
    ),
    (
      title: 'Brahman Specialty #10',
      location: 'Miller Ranchlands',
      roi: '16.5%',
      progress: 0.25,
      price: '\$2,100',
      shares: '18 / 60',
      isNew: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  'LIVE MARKET',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Active Opportunities',
                  style: AppTextStyles.headlineMd.copyWith(
                    color: AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...List.generate(
          _opportunities.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _OpportunityCard(opportunity: _opportunities[i], index: i),
          ),
        ),
      ],
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  const _OpportunityCard({required this.opportunity, required this.index});
  final ({
    String title,
    String location,
    String roi,
    double progress,
    String price,
    String shares,
    bool isNew,
  }) opportunity;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.ambientCard,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  color: AppColors.surfaceContainerHigh,
                  child: const Center(
                    child: Icon(
                      Icons.landscape_rounded,
                      size: 64,
                      color: AppColors.outlineVariant,
                    ),
                  ),
                ),
                if (opportunity.isNew)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.90),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'NEW ARRIVAL',
                        style: AppTextStyles.labelXs.copyWith(
                          color: AppColors.onPrimary,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_rounded,
                          size: 12,
                          color: AppColors.onTertiaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'VERIFIED',
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
          ),

          // Card body
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          opportunity.title,
                          style: AppTextStyles.headlineSm.copyWith(
                            fontSize: 18,
                            color: AppColors.onBackground,
                          ),
                        ),
                        Text(
                          opportunity.location,
                          style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          opportunity.roi,
                          style: AppTextStyles.headlineSm.copyWith(
                            color: AppColors.primary,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'EST. ROI',
                          style: AppTextStyles.labelXs.copyWith(
                            color: AppColors.secondary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: opportunity.progress,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
                const SizedBox(height: 20),

                // Price & shares row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PRICE PER SHARE',
                            style: AppTextStyles.labelXs.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            opportunity.price,
                            style: AppTextStyles.headlineSm.copyWith(
                              fontSize: 18,
                              color: AppColors.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'SHARES REMAINING',
                            style: AppTextStyles.labelXs.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            opportunity.shares,
                            style: AppTextStyles.headlineSm.copyWith(
                              fontSize: 18,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Invest Now button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => context.pushNamed(
                      'investment-detail',
                      pathParameters: {'id': index.toString()},
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    icon: const SizedBox.shrink(),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Invest Now',
                          style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isActive: true,
                    onTap: () {},
                  ),
                  _NavItem(
                    icon: Icons.search_rounded,
                    label: 'Search',
                    isActive: false,
                    onTap: () => context.go('/market'),
                  ),
                  _NavItem(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Wallet',
                    isActive: false,
                    onTap: () => context.go('/wallet'),
                  ),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    isActive: false,
                    onTap: () => context.go('/profile'),
                  ),
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
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });
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
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.onPrimary : AppColors.secondary,
            ),
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
