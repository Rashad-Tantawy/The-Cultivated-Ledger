import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Wallet / Transactions screen.
///
/// Layout:
///  • Glassmorphic top bar
///  • Balance hero card (gradient green)
///  • Quick actions row (Deposit / Withdraw / Transfer)
///  • Holdings summary (3 cards)
///  • Transaction history timeline
///  • Bottom nav (Wallet active)
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const _transactions = [
    (
      type: 'Investment',
      title: 'Angus Select Batch #042',
      amount: '-\$1,250.00',
      date: 'Today, 10:24 AM',
      isDebit: true,
      icon: Icons.trending_up_rounded,
    ),
    (
      type: 'Dividend',
      title: 'Q1 Yield — Hereford #019',
      amount: '+\$682.50',
      date: 'Yesterday, 3:11 PM',
      isDebit: false,
      icon: Icons.savings_outlined,
    ),
    (
      type: 'Deposit',
      title: 'Bank Transfer',
      amount: '+\$5,000.00',
      date: 'Apr 1, 9:00 AM',
      isDebit: false,
      icon: Icons.account_balance_outlined,
    ),
    (
      type: 'Investment',
      title: 'Brahman Specialty #10',
      amount: '-\$2,100.00',
      date: 'Mar 28, 2:45 PM',
      isDebit: true,
      icon: Icons.trending_up_rounded,
    ),
    (
      type: 'Dividend',
      title: 'Q4 Yield — Angus Batch #038',
      amount: '+\$1,490.00',
      date: 'Mar 15, 11:30 AM',
      isDebit: false,
      icon: Icons.savings_outlined,
    ),
    (
      type: 'Withdrawal',
      title: 'Bank Transfer',
      amount: '-\$3,000.00',
      date: 'Mar 10, 4:00 PM',
      isDebit: true,
      icon: Icons.arrow_upward_rounded,
    ),
  ];

  static const _holdings = [
    (title: 'Angus Select #042', value: '\$92,400', roi: '+15.2%'),
    (title: 'Hereford #019', value: '\$73,500', roi: '+13.8%'),
    (title: 'Brahman #10', value: '\$82,600', roi: '+16.5%'),
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

              // ── Balance hero ───────────────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _BalanceHero(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),

              // ── Quick actions ──────────────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _QuickActions(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Holdings summary ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Active Holdings',
                              style: AppTextStyles.headlineMd.copyWith(
                                  fontSize: 20, letterSpacing: -0.3)),
                          TextButton(
                            onPressed: () =>
                                context.pushNamed('portfolio-detail'),
                            child: Text('View All',
                                style: AppTextStyles.labelMd.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 96,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _holdings.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) =>
                            _HoldingChip(holding: _holdings[i]),
                      ),
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Transaction history ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Transaction History',
                              style: AppTextStyles.headlineMd.copyWith(
                                  fontSize: 20, letterSpacing: -0.3)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.filter_list_rounded,
                                    size: 14,
                                    color: AppColors.onSurfaceVariant),
                                const SizedBox(width: 4),
                                Text('Filter',
                                    style: AppTextStyles.labelSm.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                        letterSpacing: 0.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: AppShadows.ambientCard,
                        ),
                        child: Column(
                          children: List.generate(
                            _transactions.length,
                            (i) => _TransactionRow(
                              tx: _transactions[i],
                              showDivider: i < _transactions.length - 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _TopBar(),
        ],
      ),
      bottomNavigationBar: const _BottomNavBar(activeIndex: 2),
    );
  }
}

// ── Balance hero ──────────────────────────────────────────────────────────────

class _BalanceHero extends StatelessWidget {
  const _BalanceHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryButton,
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
                  radius: 1.5,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AVAILABLE BALANCE',
                  style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onPrimary.withValues(alpha: 0.60),
                      letterSpacing: 2)),
              const SizedBox(height: 8),
              Text('\$12,405.20',
                  style: AppTextStyles.headlineXl.copyWith(
                      color: AppColors.onPrimary,
                      fontSize: 38,
                      letterSpacing: -1)),
              const SizedBox(height: 20),
              Row(
                children: [
                  _BalanceStat(
                      label: 'Portfolio', value: '\$248,500'),
                  const SizedBox(width: 24),
                  _BalanceStat(
                      label: 'Monthly Yield',
                      value: '+\$3,210',
                      valueColor: AppColors.onPrimaryContainer),
                  const SizedBox(width: 24),
                  _BalanceStat(label: 'Total ROI', value: '+14.8%',
                      valueColor: AppColors.onPrimaryContainer),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  const _BalanceStat(
      {required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: AppTextStyles.labelXs.copyWith(
                color: AppColors.onPrimary.withValues(alpha: 0.55),
                letterSpacing: 1)),
        const SizedBox(height: 2),
        Text(value,
            style: AppTextStyles.labelMd.copyWith(
                color: valueColor ?? AppColors.onPrimary,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

// ── Quick actions ─────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
              icon: Icons.add_rounded,
              label: 'Deposit',
              onTap: () {}),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
              icon: Icons.arrow_upward_rounded,
              label: 'Withdraw',
              onTap: () {}),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
              icon: Icons.swap_horiz_rounded,
              label: 'Transfer',
              onTap: () {}),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.ambientCard,
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryFixed.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(height: 8),
            Text(label,
                style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onSurface, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ── Holding chip ──────────────────────────────────────────────────────────────

class _HoldingChip extends StatelessWidget {
  const _HoldingChip({required this.holding});
  final ({String title, String value, String roi}) holding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.ambientCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(holding.title,
              style: AppTextStyles.labelMd.copyWith(
                  color: AppColors.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(holding.value,
              style: AppTextStyles.headlineSm.copyWith(
                  fontSize: 17, color: AppColors.onBackground)),
          Text(holding.roi,
              style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// ── Transaction row ───────────────────────────────────────────────────────────

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.tx, required this.showDivider});
  final ({
    String type,
    String title,
    String amount,
    String date,
    bool isDebit,
    IconData icon,
  }) tx;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tx.isDebit
                      ? AppColors.errorContainer.withValues(alpha: 0.4)
                      : AppColors.primaryFixed.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: Icon(tx.icon,
                    size: 20,
                    color: tx.isDebit
                        ? AppColors.onErrorContainer
                        : AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tx.title,
                        style: AppTextStyles.labelLg.copyWith(
                            color: AppColors.onBackground,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text(tx.date,
                        style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant, fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(tx.amount,
                      style: AppTextStyles.labelLg.copyWith(
                        color: tx.isDebit
                            ? AppColors.onErrorContainer
                            : AppColors.primary,
                        fontWeight: FontWeight.w700,
                      )),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(tx.type.toUpperCase(),
                        style: AppTextStyles.labelXs.copyWith(
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.5)),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
            color: AppColors.surfaceContainerHigh,
          ),
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MY WALLET',
                        style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.secondary, letterSpacing: 2)),
                    Text('Transactions',
                        style: AppTextStyles.headlineMd.copyWith(
                            fontSize: 18,
                            color: AppColors.primary,
                            letterSpacing: -0.5)),
                  ],
                ),
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
