import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Farmer Dashboard / Profile screen.
///
/// Design reference: stitch/farmer_profile/
/// Reached from: InvestorDashboard farmer card tap, or InvestmentDetail farmer tap.
///
/// farmerId path param (0, 1, 2) selects which farmer's data to display.
class FarmerDashboardScreen extends StatelessWidget {
  const FarmerDashboardScreen({super.key, required this.farmerId});
  final int farmerId;

  // ── Static farmer data ────────────────────────────────────────────────────
  static const _farmers = [
    (
      name: 'Silas Thorne',
      farm: 'Montana Highland Ranches',
      location: 'Great Falls, Montana',
      rating: '4.9',
      reviews: '124',
      experience: '18 Years',
      about:
          'Operating across 2,400 acres of prime Montana ranchland, Silas Thorne has built one of the most respected cattle operations in the Northern Plains. Specializing in Black Angus and heritage crossbreeds raised on open pasture with zero synthetic inputs, every investment cycle delivers consistent, audited returns backed by full asset insurance.',
      listings: [
        (
          title: 'Angus Select Batch #042',
          status: 'Open',
          roi: '15.2%',
          duration: '14 Months',
          isOpen: true,
        ),
        (
          title: 'Yearling Futures Batch #11',
          status: 'Waitlist',
          roi: '11.8%',
          duration: '18 Months',
          isOpen: false,
        ),
      ],
      history: [
        (cycle: 'Batch #041 — Q1 2024', roi: '14.9%', date: 'Completed Mar 2024'),
        (cycle: 'Batch #038 — Q3 2023', roi: '13.2%', date: 'Completed Sep 2023'),
        (cycle: 'Batch #035 — Q1 2023', roi: '12.4%', date: 'Completed Feb 2023'),
      ],
    ),
    (
      name: 'Elena Rodriguez',
      farm: 'Verde Valley Organics',
      location: 'Sedona, Arizona',
      rating: '5.0',
      reviews: '86',
      experience: '12 Years',
      about:
          'Elena Rodriguez leads Verde Valley Organics, a 900-acre certified regenerative farm in the heart of Arizona\'s high desert. With a focus on heritage Hereford breeds and soil-first practices, her operation has achieved top-tier returns through sustainable herd management and transparency-first investor relations.',
      listings: [
        (
          title: 'Hereford Heritage #019',
          status: 'Open',
          roi: '13.8%',
          duration: '16 Months',
          isOpen: true,
        ),
        (
          title: 'Organic Grass-Fed Herd #07',
          status: 'Waitlist',
          roi: '12.5%',
          duration: '20 Months',
          isOpen: false,
        ),
      ],
      history: [
        (cycle: 'Heritage #018 — Q4 2023', roi: '14.1%', date: 'Completed Dec 2023'),
        (cycle: 'Heritage #015 — Q2 2023', roi: '13.6%', date: 'Completed Jun 2023'),
        (cycle: 'Heritage #012 — Q3 2022', roi: '12.9%', date: 'Completed Sep 2022'),
      ],
    ),
    (
      name: 'Arthur Miller',
      farm: "Miller's Heritage Cattle",
      location: 'Inverness-shire, Scotland',
      rating: '4.8',
      reviews: '210',
      experience: '24 Years',
      about:
          'Operating across 1,200 acres of regenerative pasture, the Miller family has been a staple of the Highlands for three generations. Their commitment to soil health and heritage Brahman breeds ensures that every investment cycle yields high-quality results while restoring the local ecosystem with zero synthetic inputs.',
      listings: [
        (
          title: 'Brahman Specialty #10',
          status: 'Open',
          roi: '16.5%',
          duration: '12 Months',
          isOpen: true,
        ),
        (
          title: 'Highland Regenerative Lot #4',
          status: 'Waitlist',
          roi: '13.1%',
          duration: '22 Months',
          isOpen: false,
        ),
      ],
      history: [
        (cycle: 'Brahman #09 — Q1 2024', roi: '15.8%', date: 'Completed Jan 2024'),
        (cycle: 'Brahman #07 — Q3 2023', roi: '14.4%', date: 'Completed Aug 2023'),
        (cycle: 'Brahman #05 — Q1 2023', roi: '11.8%', date: 'Completed Mar 2023'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final farmer = _farmers[farmerId.clamp(0, _farmers.length - 1)];

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBody: true,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 80)),

              // ── Profile hero ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _ProfileHero(farmer: farmer),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),

              // ── Active listings ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _ActiveListings(
                    listings: farmer.listings,
                    farmerId: farmerId,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Cycle history ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _CycleHistory(history: farmer.history),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Heritage guarantee ─────────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _HeritageGuarantee(),
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
              left: 8,
              right: 24,
            ),
            color: AppColors.surface.withValues(alpha: 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 4),
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
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined,
                      color: AppColors.secondary, size: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Profile hero ──────────────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.farmer});
  final ({
    String name,
    String farm,
    String location,
    String rating,
    String reviews,
    String experience,
    String about,
    List<({String title, String status, String roi, String duration, bool isOpen})> listings,
    List<({String cycle, String roi, String date})> history,
  }) farmer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar + verified badge
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 100,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.person_rounded,
                      size: 56, color: AppColors.outlineVariant),
                ),
                Positioned(
                  bottom: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.tertiaryContainer,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: AppShadows.ambientCard,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded,
                            size: 12, color: AppColors.onTertiaryContainer),
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
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    farmer.name,
                    style: AppTextStyles.headlineLg.copyWith(
                      color: AppColors.primary,
                      fontSize: 28,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    farmer.farm,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _BadgeChip(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.tertiary,
                        label:
                            '${farmer.rating} (${farmer.reviews} reviews)',
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _BadgeChip(
                    icon: Icons.calendar_month_outlined,
                    iconColor: AppColors.primary,
                    label: '${farmer.experience} Experience',
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // About section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About the Farm',
                style: AppTextStyles.headlineMd.copyWith(
                  fontSize: 20,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                farmer.about,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: AppColors.secondary),
                  const SizedBox(width: 6),
                  Text(
                    farmer.location,
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip(
      {required this.icon, required this.iconColor, required this.label});
  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Active listings ───────────────────────────────────────────────────────────

class _ActiveListings extends StatelessWidget {
  const _ActiveListings(
      {required this.listings, required this.farmerId});
  final List<({
    String title,
    String status,
    String roi,
    String duration,
    bool isOpen,
  })> listings;
  final int farmerId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Active Listings',
              style: AppTextStyles.headlineMd.copyWith(
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              '${listings.length} Opportunities',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.secondary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...listings.map(
          (listing) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _ListingCard(
              listing: listing,
              onViewDetails: listing.isOpen
                  ? () => context.pushNamed(
                        'investment-detail',
                        pathParameters: {'id': farmerId.toString()},
                      )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _ListingCard extends StatelessWidget {
  const _ListingCard(
      {required this.listing, required this.onViewDetails});
  final ({
    String title,
    String status,
    String roi,
    String duration,
    bool isOpen,
  }) listing;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.ambientCard,
      ),
      child: Row(
        children: [
          // Image placeholder
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16)),
            child: Container(
              width: 100,
              height: 120,
              color: AppColors.surfaceContainerHigh,
              child: const Center(
                child: Icon(Icons.landscape_rounded,
                    size: 36, color: AppColors.outlineVariant),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          listing.title,
                          style: AppTextStyles.headlineSm.copyWith(
                            fontSize: 14,
                            color: AppColors.onBackground,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: listing.isOpen
                              ? AppColors.primaryFixed
                              : AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          listing.status.toUpperCase(),
                          style: AppTextStyles.labelXs.copyWith(
                            color: listing.isOpen
                                ? AppColors.onPrimaryFixed
                                : AppColors.onSurfaceVariant,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _MiniStat(label: 'Target', value: listing.roi,
                          valueColor: AppColors.primary),
                      const SizedBox(width: 16),
                      _MiniStat(label: 'Duration', value: listing.duration,
                          valueColor: AppColors.onBackground),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: listing.isOpen
                        ? ElevatedButton(
                            onPressed: onViewDetails,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              elevation: 0,
                            ),
                            child: Text(
                              'View Details',
                              style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.onPrimary,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        : OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              side: const BorderSide(
                                  color: AppColors.outlineVariant),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: Text(
                              'Notify Me',
                              style: AppTextStyles.labelMd.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontWeight: FontWeight.w600),
                            ),
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

class _MiniStat extends StatelessWidget {
  const _MiniStat(
      {required this.label, required this.value, required this.valueColor});
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
          style: AppTextStyles.labelXs.copyWith(color: AppColors.onSurfaceVariant),
        ),
        Text(
          value,
          style: AppTextStyles.headlineSm.copyWith(
              fontSize: 16, color: valueColor),
        ),
      ],
    );
  }
}

// ── Cycle history ─────────────────────────────────────────────────────────────

class _CycleHistory extends StatelessWidget {
  const _CycleHistory({required this.history});
  final List<({String cycle, String roi, String date})> history;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cycle History',
          style: AppTextStyles.headlineMd.copyWith(
              fontSize: 22, letterSpacing: -0.5),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ...List.generate(history.length, (i) {
                final item = history[i];
                final isLast = i == history.length - 1;
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline
                    Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          margin: const EdgeInsets.only(top: 3),
                          decoration: BoxDecoration(
                            color: i < 2 ? AppColors.primary : AppColors.outlineVariant,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surfaceContainerLow,
                              width: 3,
                            ),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 52,
                            color: AppColors.primary.withValues(alpha: 0.15),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.date.toUpperCase(),
                              style: AppTextStyles.labelXs.copyWith(
                                color: AppColors.secondary,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.cycle,
                              style: AppTextStyles.headlineSm.copyWith(
                                  fontSize: 15,
                                  color: i < 2
                                      ? AppColors.onBackground
                                      : AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  item.roi,
                                  style: AppTextStyles.headlineSm.copyWith(
                                    fontSize: 22,
                                    color: i < 2
                                        ? AppColors.primary
                                        : AppColors.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Realized ROI',
                                  style: AppTextStyles.bodyMd.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Download Performance Report',
                    style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Heritage guarantee ────────────────────────────────────────────────────────

class _HeritageGuarantee extends StatelessWidget {
  const _HeritageGuarantee();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.security_rounded,
              size: 36, color: AppColors.onPrimaryContainer),
          const SizedBox(height: 12),
          Text(
            'Heritage Guarantee',
            style: AppTextStyles.headlineSm.copyWith(
              color: AppColors.onPrimaryContainer,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All investments are backed by comprehensive asset insurance and audited by the Regional Agricultural Board.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onPrimaryContainer.withValues(alpha: 0.80),
              height: 1.6,
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
                  _NavItem(icon: Icons.home_rounded, label: 'Home',
                      isActive: false,
                      onTap: () => context.go('/investor/home')),
                  _NavItem(icon: Icons.search_rounded, label: 'Search',
                      isActive: false, onTap: () {}),
                  _NavItem(icon: Icons.account_balance_wallet_outlined,
                      label: 'Investments', isActive: false, onTap: () {}),
                  _NavItem(icon: Icons.person_outline_rounded,
                      label: 'Profile', isActive: true, onTap: () {}),
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
