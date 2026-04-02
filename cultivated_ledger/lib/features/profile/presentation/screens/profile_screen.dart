import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Profile / Settings screen.
///
/// Layout:
///  • Glassmorphic top bar
///  • Profile hero card (avatar, name, role, stats)
///  • Account settings sections (grouped rows)
///  • Preferences section
///  • Danger zone (Sign Out)
///  • Bottom nav (Profile active)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

              // ── Profile hero ───────────────────────────────────────────
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: _ProfileHero(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),

              // ── Account section ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SettingsSection(
                    title: 'Account',
                    items: [
                      _SettingItem(
                          icon: Icons.person_outline_rounded,
                          label: 'Personal Information',
                          onTap: () {}),
                      _SettingItem(
                          icon: Icons.lock_outline_rounded,
                          label: 'Security & Password',
                          onTap: () {}),
                      _SettingItem(
                          icon: Icons.verified_user_outlined,
                          label: 'KYC Verification',
                          trailing: _VerifiedBadge(),
                          onTap: () {}),
                      _SettingItem(
                          icon: Icons.account_balance_outlined,
                          label: 'Linked Bank Accounts',
                          onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ── Investment section ─────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SettingsSection(
                    title: 'Investment',
                    items: [
                      _SettingItem(
                          icon: Icons.analytics_outlined,
                          label: 'Portfolio Summary',
                          onTap: () => context.pushNamed('portfolio-detail')),
                      _SettingItem(
                          icon: Icons.history_rounded,
                          label: 'Investment History',
                          onTap: () {}),
                      _SettingItem(
                          icon: Icons.receipt_long_outlined,
                          label: 'Tax Documents',
                          onTap: () {}),
                      _SettingItem(
                          icon: Icons.card_giftcard_outlined,
                          label: 'Referral Programme',
                          trailing: _BadgeCount(label: 'New'),
                          onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ── Preferences section ────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SettingsSection(
                    title: 'Preferences',
                    items: [
                      _SettingItem(
                          icon: Icons.notifications_outlined,
                          label: 'Notifications',
                          onTap: () => context.pushNamed('notifications')),
                      _SettingItem(
                          icon: Icons.language_outlined,
                          label: 'Language & Region',
                          value: 'English (UK)',
                          onTap: () {}),
                      _SettingItem(
                          icon: Icons.dark_mode_outlined,
                          label: 'Appearance',
                          value: 'Light Mode',
                          onTap: () {}),
                      _SettingItem(
                          icon: Icons.help_outline_rounded,
                          label: 'Help & Support',
                          onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ── Legal section ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SettingsSection(
                    title: 'Legal',
                    items: [
                      _SettingItem(
                          icon: Icons.description_outlined,
                          label: 'Terms of Service',
                          onTap: () {}),
                      _SettingItem(
                          icon: Icons.privacy_tip_outlined,
                          label: 'Privacy Policy',
                          onTap: () {}),
                      _SettingItem(
                          icon: Icons.info_outline_rounded,
                          label: 'About The Cultivated Ledger',
                          value: 'v1.0.0',
                          onTap: () {}),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ── Sign out ───────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _SignOutButton(
                    onTap: () => context.go('/'),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _TopBar(),
        ],
      ),
      bottomNavigationBar: const _BottomNavBar(activeIndex: 3),
    );
  }
}

// ── Profile hero ──────────────────────────────────────────────────────────────

class _ProfileHero extends StatelessWidget {
  const _ProfileHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.ambientCard,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primaryFixed.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded,
                        size: 40, color: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryContainer,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.surfaceContainerLowest, width: 2),
                      ),
                      child: const Icon(Icons.verified_rounded,
                          size: 12, color: AppColors.onTertiaryContainer),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Arthur Greenfield',
                        style: AppTextStyles.headlineMd.copyWith(
                            fontSize: 20,
                            color: AppColors.onBackground,
                            letterSpacing: -0.3)),
                    const SizedBox(height: 2),
                    Text('arthur@ledger.com',
                        style: AppTextStyles.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant, fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('INVESTOR',
                              style: AppTextStyles.labelXs.copyWith(
                                  color: AppColors.onPrimaryFixedVariant,
                                  letterSpacing: 1)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.tertiaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('KYC VERIFIED',
                              style: AppTextStyles.labelXs.copyWith(
                                  color: AppColors.onTertiaryContainer,
                                  letterSpacing: 1)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined,
                    color: AppColors.primary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: AppColors.surfaceContainerHigh),
          const SizedBox(height: 20),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ProfileStat(label: 'Portfolio Value', value: '\$248,500'),
              _Divider(),
              _ProfileStat(label: 'Active Holdings', value: '3'),
              _Divider(),
              _ProfileStat(
                  label: 'Total ROI',
                  value: '+14.8%',
                  valueColor: AppColors.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat(
      {required this.label, required this.value, this.valueColor});
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: AppTextStyles.headlineSm.copyWith(
                fontSize: 18,
                color: valueColor ?? AppColors.onBackground)),
        const SizedBox(height: 2),
        Text(label,
            style: AppTextStyles.labelXs.copyWith(
                color: AppColors.onSurfaceVariant, letterSpacing: 0.5)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1, height: 32, color: AppColors.surfaceContainerHigh);
  }
}

// ── Settings section ──────────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.items});
  final String title;
  final List<_SettingItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title.toUpperCase(),
              style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.secondary, letterSpacing: 2)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.ambientCard,
          ),
          child: Column(
            children: List.generate(items.length, (i) {
              return Column(
                children: [
                  items[i],
                  if (i < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 20,
                      endIndent: 20,
                      color: AppColors.surfaceContainerHigh,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SettingItem extends StatelessWidget {
  const _SettingItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
    this.trailing,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label,
                  style: AppTextStyles.labelLg.copyWith(
                      color: AppColors.onSurface, fontWeight: FontWeight.w500)),
            ),
            if (value != null) ...[
              Text(value!,
                  style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.onSurfaceVariant, fontSize: 13)),
              const SizedBox(width: 6),
            ],
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 6),
            ],
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.outlineVariant),
          ],
        ),
      ),
    );
  }
}

// ── Trailing widgets ──────────────────────────────────────────────────────────

class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('VERIFIED',
          style: AppTextStyles.labelXs.copyWith(
              color: AppColors.onTertiaryContainer, letterSpacing: 0.8)),
    );
  }
}

class _BadgeCount extends StatelessWidget {
  const _BadgeCount({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: AppTextStyles.labelXs.copyWith(
              color: AppColors.onPrimary, letterSpacing: 0.5)),
    );
  }
}

// ── Sign out ──────────────────────────────────────────────────────────────────

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.errorContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded,
                size: 18, color: AppColors.onErrorContainer),
            const SizedBox(width: 10),
            Text('Sign Out',
                style: AppTextStyles.labelLg.copyWith(
                    color: AppColors.onErrorContainer,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
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
                    Text('MY ACCOUNT',
                        style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.secondary, letterSpacing: 2)),
                    Text('Profile & Settings',
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
