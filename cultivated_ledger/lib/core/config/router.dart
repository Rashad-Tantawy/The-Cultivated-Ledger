import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
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

GoRouter createRouter(WidgetRef ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authRepositoryProvider).authStateChanges,
    ),
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final path = state.matchedLocation;

      final publicRoutes = ['/', '/login', '/register'];
      final isPublicRoute = publicRoutes.contains(path);

      if (!isLoggedIn && !isPublicRoute) return '/login';

      if (isLoggedIn) {
        final user = authState.valueOrNull!;

        // Redirect away from auth screens when logged in
        if (isPublicRoute && path != '/') {
          return user.isFarmer ? '/vendor/home' : '/investor/home';
        }

        // Route farmer to vendor dashboard, investor to investor dashboard
        if (path == '/investor/home' && user.isFarmer) return '/vendor/home';
        if (path == '/vendor/home' && user.isInvestor) return '/investor/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => _fade(state, const LoginScreen()),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => _fade(state, const SignUpScreen()),
      ),

      // ── Investor shell ────────────────────────────────────────────────────
      GoRoute(
        path: '/investor/home',
        name: 'investor-dashboard',
        pageBuilder: (context, state) =>
            _fade(state, const InvestorDashboardScreen()),
      ),
      GoRoute(
        path: '/investor/portfolio',
        name: 'portfolio-detail',
        pageBuilder: (context, state) =>
            _slideUp(state, const PortfolioDetailScreen()),
      ),
      GoRoute(
        path: '/investor/market',
        name: 'market',
        pageBuilder: (context, state) =>
            _fade(state, const SearchMarketScreen()),
      ),
      GoRoute(
        path: '/investor/wallet',
        name: 'wallet',
        pageBuilder: (context, state) => _fade(state, const WalletScreen()),
      ),
      GoRoute(
        path: '/investor/profile',
        name: 'investor-profile',
        pageBuilder: (context, state) => _fade(state, const ProfileScreen()),
      ),
      GoRoute(
        path: '/investor/notifications',
        name: 'notifications',
        pageBuilder: (context, state) =>
            _slideDown(state, const NotificationsScreen()),
      ),
      GoRoute(
        path: '/investor/listing/:id',
        name: 'investment-detail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'] ?? '0';
          return _slideRight(state, InvestmentDetailScreen(investmentId: int.tryParse(id) ?? 0));
        },
      ),

      // ── Farmer/Vendor shell ───────────────────────────────────────────────
      GoRoute(
        path: '/vendor/home',
        name: 'vendor-dashboard',
        pageBuilder: (context, state) =>
            _fade(state, FarmerDashboardScreen(farmerId: 0)),
      ),
      GoRoute(
        path: '/vendor/profile',
        name: 'vendor-profile',
        pageBuilder: (context, state) => _fade(state, const ProfileScreen()),
      ),

      // ── Shared ───────────────────────────────────────────────────────────
      GoRoute(
        path: '/farmer/:id',
        name: 'farmer-public-profile',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          return _slideRight(state, FarmerDashboardScreen(farmerId: id));
        },
      ),
    ],
  );
}

// ── Transition helpers ────────────────────────────────────────────────────────

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) =>
          FadeTransition(opacity: animation, child: child),
    );

CustomTransitionPage<void> _slideUp(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    );

CustomTransitionPage<void> _slideDown(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    );

CustomTransitionPage<void> _slideRight(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      ),
    );

// ── GoRouter refresh stream helper ───────────────────────────────────────────

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
