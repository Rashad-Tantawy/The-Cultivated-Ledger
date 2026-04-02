import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Portfolio Detail Screen — full portfolio analytics view.
///
/// Reached from: InvestorDashboard → "View Detailed Analytics"
///
/// Layout:
///  • Glassmorphic top bar with back button + "My Portfolio"
///  • Total Portfolio green hero card
///  • Holdings breakdown (3 investment allocations)
///  • Performance history timeline
///  • Bottom nav bar
class PortfolioDetailScreen extends StatelessWidget {
  const PortfolioDetailScreen({super.key});

  static const _holdings = [
    (
      title: 'Angus Select Batch #042',
      location: 'Montana High Plains',
      roi: '+15.2%',
      value: '\$92,400',
      allocation: 0.37,
      color: AppColors.primary,
    ),
    (
      title: 'Hereford Heritage #019',
      location: 'Verde Valley Farms',
      roi: '+13.8%',
      value: '\$73,500',
      allocation: 0.30,
      color: AppColors.primaryContainer,
    ),
    (
      title: 'Brahman Specialty #10',
      location: 'Miller Ranchlands',
      roi: '+16.5%',
      value: '\$82,600',
      allocation: 0.33,
      color: AppColors.tertiary,
    ),
  ];

  static const _history = [
    (period: 'Q1 2024', yield: '+4.2%', status: 'Completed'),
    (period: 'Q4 2023', yield: '+3.8%', status: 'Completed'),
    (period: 'Q3 2023', yield: '+3.5%', status: 'Completed'),
    (period: 'Q2 2023', yield: '+2.3%', status: 'Completed'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBody: true,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 80)),

              // ── Hero card ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _PortfolioHeroCard(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Allocation section ───────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _AllocationSection(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Performance history ──────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _PerformanceHistory(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // ── Fixed top bar ────────────────────────────────────────────
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
              left: 8,
              right: 24,
            ),
            color: AppColors.surface.withValues(alpha: 0.85),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 4),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Portfolio',
                      style: AppTextStyles.headlineMd.copyWith(
                        fontSize: 20,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Q2 2024 · 3 Active Positions',
                      style: AppTextStyles.labelSm.copyWith(
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
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

// ── Portfolio hero card ───────────────────────────────────────────────────────

class _PortfolioHeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.primaryGlow,
      ),
      child: Stack(
        children: [
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
                  fontSize: 38,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 24),
              // Stats row
              Row(
                children: [
                  _StatChip(label: 'Total ROI', value: '+14.8%',
                      valueColor: AppColors.onPrimaryContainer),
                  const SizedBox(width: 12),
                  _StatChip(label: 'Active', value: '3 Holdings',
                      valueColor: AppColors.onPrimary),
                  const SizedBox(width: 12),
                  _StatChip(label: 'Head', value: '124',
                      valueColor: AppColors.onPrimary),
                ],
              ),
              const SizedBox(height: 24),
              // Allocation bar
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Row(
                  children: [
                    Expanded(
                      flex: 37,
                      child: Container(height: 8, color: AppColors.onPrimaryContainer),
                    ),
                    Expanded(
                      flex: 30,
                      child: Container(
                          height: 8,
                          color: AppColors.onPrimaryContainer.withValues(alpha: 0.6)),
                    ),
                    Expanded(
                      flex: 33,
                      child: Container(
                          height: 8,
                          color: AppColors.onPrimaryContainer.withValues(alpha: 0.3)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Portfolio allocation across 3 active cattle batches',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.onPrimary.withValues(alpha: 0.50),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.value, required this.valueColor});
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelXs.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.55),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.labelMd.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Allocation section ────────────────────────────────────────────────────────

class _AllocationSection extends StatelessWidget {
  const _AllocationSection();

  static const _holdings = PortfolioDetailScreen._holdings;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACTIVE HOLDINGS',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Allocation Breakdown',
                  style: AppTextStyles.headlineMd.copyWith(
                    color: AppColors.primary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...List.generate(
          _holdings.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _HoldingCard(holding: _holdings[i]),
          ),
        ),
      ],
    );
  }
}

class _HoldingCard extends StatelessWidget {
  const _HoldingCard({required this.holding});
  final ({
    String title,
    String location,
    String roi,
    String value,
    double allocation,
    Color color,
  }) holding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.ambientCard,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holding.title,
                    style: AppTextStyles.headlineSm.copyWith(
                      fontSize: 15,
                      color: AppColors.onBackground,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    holding.location,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    holding.value,
                    style: AppTextStyles.headlineSm.copyWith(
                      fontSize: 17,
                      color: AppColors.onBackground,
                    ),
                  ),
                  Text(
                    holding.roi,
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: holding.allocation,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceContainerHigh,
                    valueColor: AlwaysStoppedAnimation(holding.color),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(holding.allocation * 100).round()}%',
                style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Performance history ───────────────────────────────────────────────────────

class _PerformanceHistory extends StatelessWidget {
  const _PerformanceHistory();

  static const _history = PortfolioDetailScreen._history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CYCLE PERFORMANCE',
          style: AppTextStyles.labelSm.copyWith(
            color: AppColors.secondary,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Return History',
          style: AppTextStyles.headlineMd.copyWith(
            color: AppColors.primary,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: List.generate(_history.length, (i) {
              final item = _history[i];
              final isLast = i == _history.length - 1;
              return Column(
                children: [
                  Row(
                    children: [
                      // Timeline dot
                      Column(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: i == 0 ? AppColors.primary : AppColors.outlineVariant,
                              shape: BoxShape.circle,
                              boxShadow: i == 0
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : null,
                            ),
                          ),
                          if (!isLast)
                            Container(
                              width: 2,
                              height: 36,
                              color: AppColors.outlineVariant.withValues(alpha: 0.4),
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.period,
                                    style: AppTextStyles.headlineSm.copyWith(
                                      fontSize: 15,
                                      color: AppColors.onBackground,
                                    ),
                                  ),
                                  Text(
                                    item.status,
                                    style: AppTextStyles.labelXs.copyWith(
                                      color: AppColors.secondary,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                item.yield,
                                style: AppTextStyles.headlineSm.copyWith(
                                  fontSize: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        // Download button
        Center(
          child: TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded,
                color: AppColors.primary, size: 18),
            label: Text(
              'Download Performance Report',
              style: AppTextStyles.labelLg.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
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
                      isActive: false, onTap: () => context.go('/investor/home')),
                  _NavItem(icon: Icons.search_rounded, label: 'Search',
                      isActive: false, onTap: () {}),
                  _NavItem(icon: Icons.account_balance_wallet_outlined,
                      label: 'Investments', isActive: true, onTap: () {}),
                  _NavItem(icon: Icons.person_outline_rounded, label: 'Profile',
                      isActive: false, onTap: () {}),
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
