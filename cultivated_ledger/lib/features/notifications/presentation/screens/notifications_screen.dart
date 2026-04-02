import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme.dart';

/// Notifications screen.
///
/// Layout:
///  • Glassmorphic top bar with back + "Mark all read"
///  • Unread count summary pill
///  • Grouped notification cards (Today / Earlier)
///  • Empty state when all read
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Notification> _notifications = [
    _Notification(
      id: 0,
      type: NotifType.dividend,
      title: 'Dividend Received',
      body: 'Q1 yield of \$682.50 from Hereford Heritage #019 has been credited to your wallet.',
      time: '10 min ago',
      isToday: true,
      isRead: false,
    ),
    _Notification(
      id: 1,
      type: NotifType.investment,
      title: 'New Opportunity Listed',
      body: 'Highland Angus Batch #82 by Silas Thorne is now open for investment. Est. ROI 12.4%.',
      time: '1 hr ago',
      isToday: true,
      isRead: false,
    ),
    _Notification(
      id: 2,
      type: NotifType.alert,
      title: 'Shares Running Low',
      body: 'Brahman Specialty #10 has only 18 shares remaining. Act before it closes.',
      time: '3 hrs ago',
      isToday: true,
      isRead: false,
    ),
    _Notification(
      id: 3,
      type: NotifType.system,
      title: 'KYC Verification Complete',
      body: 'Your identity has been successfully verified. You now have full platform access.',
      time: 'Yesterday',
      isToday: false,
      isRead: true,
    ),
    _Notification(
      id: 4,
      type: NotifType.investment,
      title: 'Investment Confirmed',
      body: 'Your purchase of 1 share in Angus Select Batch #042 (\$1,250) is confirmed.',
      time: 'Yesterday',
      isToday: false,
      isRead: true,
    ),
    _Notification(
      id: 5,
      type: NotifType.dividend,
      title: 'Q4 Cycle Completed',
      body: 'Angus Batch #038 has reached maturity. Final ROI: 14.9%. Proceeds transferred.',
      time: 'Mar 28',
      isToday: false,
      isRead: true,
    ),
    _Notification(
      id: 6,
      type: NotifType.alert,
      title: 'Price Update',
      body: 'Share price for Hereford Heritage #019 has been adjusted to \$980 per share.',
      time: 'Mar 25',
      isToday: false,
      isRead: true,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
  }

  void _markRead(int id) {
    setState(() {
      _notifications.firstWhere((n) => n.id == id).isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final todayItems = _notifications.where((n) => n.isToday).toList();
    final earlierItems = _notifications.where((n) => !n.isToday).toList();
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 80)),

              // ── Unread pill ────────────────────────────────────────────
              if (unreadCount > 0)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryFixed.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '$unreadCount unread notification${unreadCount > 1 ? 's' : ''}',
                            style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.onPrimaryFixedVariant,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),

              // ── Today ──────────────────────────────────────────────────
              if (todayItems.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('TODAY',
                        style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.secondary, letterSpacing: 2)),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NotifCard(
                          notif: todayItems[i],
                          onTap: () => _markRead(todayItems[i].id),
                        ),
                      ),
                      childCount: todayItems.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
              ],

              // ── Earlier ────────────────────────────────────────────────
              if (earlierItems.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('EARLIER',
                        style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.secondary, letterSpacing: 2)),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _NotifCard(
                          notif: earlierItems[i],
                          onTap: () => _markRead(earlierItems[i].id),
                        ),
                      ),
                      childCount: earlierItems.length,
                    ),
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),

          // ── Fixed top bar ──────────────────────────────────────────────
          _TopBar(
            unreadCount: unreadCount,
            onMarkAllRead: _markAllRead,
          ),
        ],
      ),
    );
  }
}

// ── Notification model ────────────────────────────────────────────────────────

enum NotifType { dividend, investment, alert, system }

class _Notification {
  _Notification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    required this.isToday,
    required this.isRead,
  });
  final int id;
  final NotifType type;
  final String title;
  final String body;
  final String time;
  final bool isToday;
  bool isRead;
}

// ── Notification card ─────────────────────────────────────────────────────────

class _NotifCard extends StatelessWidget {
  const _NotifCard({required this.notif, required this.onTap});
  final _Notification notif;
  final VoidCallback onTap;

  static IconData _iconFor(NotifType type) {
    switch (type) {
      case NotifType.dividend:
        return Icons.savings_outlined;
      case NotifType.investment:
        return Icons.trending_up_rounded;
      case NotifType.alert:
        return Icons.warning_amber_rounded;
      case NotifType.system:
        return Icons.verified_user_outlined;
    }
  }

  static Color _bgFor(NotifType type) {
    switch (type) {
      case NotifType.dividend:
        return AppColors.primaryFixed.withValues(alpha: 0.35);
      case NotifType.investment:
        return AppColors.primaryFixed.withValues(alpha: 0.20);
      case NotifType.alert:
        return AppColors.tertiaryFixed.withValues(alpha: 0.40);
      case NotifType.system:
        return AppColors.surfaceContainerHigh;
    }
  }

  static Color _iconColorFor(NotifType type) {
    switch (type) {
      case NotifType.dividend:
        return AppColors.primary;
      case NotifType.investment:
        return AppColors.primary;
      case NotifType.alert:
        return AppColors.tertiary;
      case NotifType.system:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notif.isRead
              ? AppColors.surfaceContainerLowest
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.ambientCard,
          border: notif.isRead
              ? null
              : Border.all(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  width: 1.5,
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon badge
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _bgFor(notif.type),
                shape: BoxShape.circle,
              ),
              child: Icon(_iconFor(notif.type),
                  size: 20, color: _iconColorFor(notif.type)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(notif.title,
                          style: AppTextStyles.labelLg.copyWith(
                              color: AppColors.onBackground,
                              fontWeight: FontWeight.w700)),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notif.body,
                      style: AppTextStyles.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                          height: 1.5)),
                  const SizedBox(height: 8),
                  Text(notif.time,
                      style: AppTextStyles.labelXs.copyWith(
                          color: AppColors.outline,
                          letterSpacing: 0.3)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.unreadCount, required this.onMarkAllRead});
  final int unreadCount;
  final VoidCallback onMarkAllRead;

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
              left: 8, right: 16,
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('INBOX',
                          style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.secondary, letterSpacing: 2)),
                      Text('Notifications',
                          style: AppTextStyles.headlineMd.copyWith(
                              fontSize: 18,
                              color: AppColors.primary,
                              letterSpacing: -0.5)),
                    ],
                  ),
                ),
                if (unreadCount > 0)
                  TextButton(
                    onPressed: onMarkAllRead,
                    child: Text('Mark all read',
                        style: AppTextStyles.labelMd.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
