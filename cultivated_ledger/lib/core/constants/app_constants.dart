class AppConstants {
  // Platform fees
  static const double platformCarryFeePercent = 5.0;
  static const double farmerOriginationFeePercent = 1.5;

  // Investment limits
  static const int minSharesPerPurchase = 1;
  static const int maxSharesPerPurchase = 1000;
  static const double minWalletDeposit = 10.0;
  static const double maxWalletDeposit = 50000.0;

  // Pagination
  static const int defaultPageSize = 20;

  // Cache durations
  static const Duration listingCacheDuration = Duration(minutes: 5);
  static const Duration dashboardCacheDuration = Duration(minutes: 2);

  // Secure storage keys
  static const String kSessionKey = 'supabase_session';
  static const String kUserRoleKey = 'user_role';

  // Shared preferences keys
  static const String kOnboardingComplete = 'onboarding_complete';
  static const String kLastSeenNotification = 'last_seen_notification';

  // Supabase table names
  static const String tableUsers = 'users';
  static const String tableFarmerProfiles = 'farmer_profiles';
  static const String tableCattleAssets = 'cattle_assets';
  static const String tableInvestments = 'investments';
  static const String tableTransactions = 'transactions';
  static const String tableNotifications = 'notifications';

  // Supabase storage buckets
  static const String bucketCattleImages = 'cattle-images';
  static const String bucketCviDocuments = 'cvi-documents';
  static const String bucketProfileImages = 'profile-images';

  // Edge function names
  static const String fnCreatePaymentIntent = 'create-payment-intent';
  static const String fnProcessExitDividend = 'process-exit-dividend';
}
