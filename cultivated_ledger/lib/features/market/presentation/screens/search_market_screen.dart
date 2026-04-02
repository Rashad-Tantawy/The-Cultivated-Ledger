import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Search / Market screen.
///
/// Layout:
///  • Glassmorphic fixed top bar
///  • Search input with live filter
///  • Active filter chips (All / Angus / Hereford / Brahman / Open / Verified)
///  • Filtered investment cards list → tap → Investment Detail
///  • Bottom nav bar (Search active)
class SearchMarketScreen extends StatefulWidget {
  const SearchMarketScreen({super.key});

  @override
  State<SearchMarketScreen> createState() => _SearchMarketScreenState();
}

class _SearchMarketScreenState extends State<SearchMarketScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  int _activeFilter = 0;

  static const _filters = ['All', 'Angus', 'Hereford', 'Brahman', 'Open', 'Verified'];

  static const _allListings = [
    (
      id: 0,
      title: 'Angus Select Batch #042',
      location: 'Montana High Plains',
      roi: '15.2%',
      price: '\$1,250',
      shares: '42 / 120',
      progress: 0.65,
      breed: 'Angus',
      isOpen: true,
      isVerified: true,
      isNew: true,
    ),
    (
      id: 1,
      title: 'Hereford Heritage #019',
      location: 'Verde Valley Farms',
      roi: '13.8%',
      price: '\$980',
      shares: '75 / 150',
      progress: 0.50,
      breed: 'Hereford',
      isOpen: true,
      isVerified: true,
      isNew: false,
    ),
    (
      id: 2,
      title: 'Brahman Specialty #10',
      location: 'Miller Ranchlands',
      roi: '16.5%',
      price: '\$2,100',
      shares: '18 / 60',
      progress: 0.70,
      breed: 'Brahman',
      isOpen: true,
      isVerified: true,
      isNew: false,
    ),
    (
      id: 1,
      title: 'Dairy Expansion Phase II',
      location: 'Verde Valley Farms',
      roi: '9.8%',
      price: '\$750',
      shares: '0 / 200',
      progress: 1.0,
      breed: 'Hereford',
      isOpen: false,
      isVerified: true,
      isNew: false,
    ),
    (
      id: 0,
      title: 'Highland Angus Batch #82',
      location: 'Montana Highland Ranches',
      roi: '12.4%',
      price: '\$1,100',
      shares: '60 / 100',
      progress: 0.40,
      breed: 'Angus',
      isOpen: true,
      isVerified: true,
      isNew: false,
    ),
  ];

  List<({
    int id,
    String title,
    String location,
    String roi,
    String price,
    String shares,
    double progress,
    String breed,
    bool isOpen,
    bool isVerified,
    bool isNew,
  })> get _filtered {
    final filter = _filters[_activeFilter];
    return _allListings.where((l) {
      final matchesQuery = _query.isEmpty ||
          l.title.toLowerCase().contains(_query.toLowerCase()) ||
          l.location.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = filter == 'All' ||
          (filter == 'Open' && l.isOpen) ||
          (filter == 'Verified' && l.isVerified) ||
          l.breed == filter;
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;

    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBody: true,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 80)),

              // ── Search bar ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIVE MARKET',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.secondary, letterSpacing: 2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Search Opportunities',
                        style: AppTextStyles.headlineMd.copyWith(
                          color: AppColors.primary, letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: AppShadows.ambientCard,
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _query = v),
                          style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.onSurface),
                          decoration: InputDecoration(
                            hintText: 'Search by breed, location, batch…',
                            hintStyle: AppTextStyles.bodyMd.copyWith(
                                color: AppColors.outline),
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: AppColors.primary, size: 22),
                            suffixIcon: _query.isNotEmpty
                                ? IconButton(
                                    onPressed: () => setState(() {
                                      _query = '';
                                      _searchController.clear();
                                    }),
                                    icon: const Icon(Icons.close_rounded,
                                        color: AppColors.outline, size: 18),
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                  color: AppColors.primary, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // ── Filter chips ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) => _FilterChip(
                      label: _filters[i],
                      isActive: _activeFilter == i,
                      onTap: () => setState(() => _activeFilter = i),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),

              // ── Result count ───────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '${results.length} result${results.length == 1 ? '' : 's'} found',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onSurfaceVariant),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // ── Results list ───────────────────────────────────────────
              results.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off_rounded,
                                size: 56,
                                color: AppColors.outlineVariant),
                            const SizedBox(height: 12),
                            Text(
                              'No listings match your search',
                              style: AppTextStyles.bodyMd.copyWith(
                                  color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _MarketCard(
                              listing: results[i],
                              onTap: () => context.pushNamed(
                                'investment-detail',
                                pathParameters: {
                                  'id': results[i].id.toString()
                                },
                              ),
                            ),
                          ),
                          childCount: results.length,
                        ),
                      ),
                    ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          // ── Fixed top bar ──────────────────────────────────────────────
          _TopBar(),
        ],
      ),
      bottomNavigationBar: const _BottomNavBar(activeIndex: 1),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip(
      {required this.label, required this.isActive, required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryFixed : AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMd.copyWith(
            color: isActive
                ? AppColors.onPrimaryFixed
                : AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Market card ───────────────────────────────────────────────────────────────

class _MarketCard extends StatelessWidget {
  const _MarketCard({required this.listing, required this.onTap});
  final ({
    int id,
    String title,
    String location,
    String roi,
    String price,
    String shares,
    double progress,
    String breed,
    bool isOpen,
    bool isVerified,
    bool isNew,
  }) listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppShadows.ambientCard,
        ),
        child: Row(
          children: [
            // Image placeholder
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Stack(
                children: [
                  Container(
                    width: 110,
                    height: 130,
                    color: AppColors.surfaceContainerHigh,
                    child: const Center(
                      child: Icon(Icons.landscape_rounded,
                          size: 40, color: AppColors.outlineVariant),
                    ),
                  ),
                  if (listing.isNew)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'NEW',
                          style: AppTextStyles.labelXs.copyWith(
                              color: AppColors.onPrimary, letterSpacing: 0.8),
                        ),
                      ),
                    ),
                ],
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
                                fontSize: 14, color: AppColors.onBackground),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(isOpen: listing.isOpen),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      listing.location,
                      style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant, fontSize: 11),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _MiniStat(
                            label: 'ROI',
                            value: listing.roi,
                            color: AppColors.primary),
                        const SizedBox(width: 16),
                        _MiniStat(
                            label: 'Price',
                            value: listing.price,
                            color: AppColors.onBackground),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: listing.progress,
                        minHeight: 5,
                        backgroundColor: AppColors.surfaceContainerHigh,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${listing.shares} shares remaining',
                      style: AppTextStyles.labelXs.copyWith(
                          color: AppColors.onSurfaceVariant, letterSpacing: 0.3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isOpen});
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOpen ? AppColors.primaryFixed : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        isOpen ? 'OPEN' : 'WAITLIST',
        style: AppTextStyles.labelXs.copyWith(
          color: isOpen
              ? AppColors.onPrimaryFixed
              : AppColors.onSurfaceVariant,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(
      {required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: AppTextStyles.labelXs
                .copyWith(color: AppColors.onSurfaceVariant)),
        Text(value,
            style: AppTextStyles.headlineSm
                .copyWith(fontSize: 15, color: color)),
      ],
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0, left: 0, right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            height: 64 + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 24, right: 24,
            ),
            color: AppColors.surface.withValues(alpha: 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  const Icon(Icons.agriculture_rounded,
                      color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Text('The Cultivated Ledger',
                      style: AppTextStyles.headlineMd.copyWith(
                          fontSize: 18,
                          color: AppColors.primary,
                          letterSpacing: -0.5)),
                ]),
                IconButton(
                  onPressed: () => context.pushNamed('notifications'),
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

// ── Bottom nav bar ────────────────────────────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({required this.activeIndex});
  final int activeIndex;

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
                      isActive: activeIndex == 0,
                      onTap: () => context.go('/investor/home')),
                  _NavItem(icon: Icons.search_rounded, label: 'Search',
                      isActive: activeIndex == 1,
                      onTap: () => context.go('/market')),
                  _NavItem(icon: Icons.account_balance_wallet_outlined,
                      label: 'Wallet', isActive: activeIndex == 2,
                      onTap: () => context.go('/wallet')),
                  _NavItem(icon: Icons.person_outline_rounded,
                      label: 'Profile', isActive: activeIndex == 3,
                      onTap: () => context.go('/profile')),
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
            Text(label.toUpperCase(),
                style: AppTextStyles.labelXs.copyWith(
                  color: isActive ? AppColors.onPrimary : AppColors.secondary,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                )),
          ],
        ),
      ),
    );
  }
}
