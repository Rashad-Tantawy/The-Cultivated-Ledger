import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/investor/presentation/screens/investor_dashboard_screen.dart';
import '../../features/investor/presentation/screens/portfolio_detail_screen.dart';
import '../../features/farmer/presentation/screens/farmer_dashboard_screen.dart';
import '../../features/investment/presentation/screens/investment_detail_screen.dart';
import '../../features/market/presentation/screens/search_market_screen.dart';
import '../../features/wallet/presentation/screens/wallet_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SignUpScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/investor/home',
      name: 'investor-dashboard',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const InvestorDashboardScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/portfolio',
      name: 'portfolio-detail',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const PortfolioDetailScreen(),
        transitionsBuilder: (context, animation, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/farmer/:id',
      name: 'farmer-dashboard',
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return CustomTransitionPage(
          key: state.pageKey,
          child: FarmerDashboardScreen(farmerId: id),
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      path: '/investment/:id',
      name: 'investment-detail',
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return CustomTransitionPage(
          key: state.pageKey,
          child: InvestmentDetailScreen(investmentId: id),
          transitionsBuilder: (context, animation, _, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut)),
            child: child,
          ),
        );
      },
    ),
    GoRoute(
      path: '/market',
      name: 'market',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SearchMarketScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/wallet',
      name: 'wallet',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const WalletScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ProfileScreen(),
        transitionsBuilder: (context, animation, _, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    ),
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const NotificationsScreen(),
        transitionsBuilder: (context, animation, _, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -1),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      ),
    ),
  ],
);
