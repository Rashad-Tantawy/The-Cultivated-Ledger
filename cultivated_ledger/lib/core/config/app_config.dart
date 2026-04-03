enum AppEnvironment { development, staging, production }

class AppConfig {
  static AppEnvironment _environment = AppEnvironment.development;

  static AppEnvironment get environment => _environment;

  static void setEnvironment(AppEnvironment env) {
    _environment = env;
  }

  // TODO: Replace with your Supabase project URL and anon key
  static String get supabaseUrl {
    switch (_environment) {
      case AppEnvironment.development:
        return 'https://YOUR_DEV_PROJECT.supabase.co';
      case AppEnvironment.staging:
        return 'https://YOUR_STAGING_PROJECT.supabase.co';
      case AppEnvironment.production:
        return 'https://YOUR_PROD_PROJECT.supabase.co';
    }
  }

  static String get supabaseAnonKey {
    switch (_environment) {
      case AppEnvironment.development:
        return 'YOUR_DEV_ANON_KEY';
      case AppEnvironment.staging:
        return 'YOUR_STAGING_ANON_KEY';
      case AppEnvironment.production:
        return 'YOUR_PROD_ANON_KEY';
    }
  }

  // TODO: Replace with your Stripe publishable key
  static String get stripePublishableKey {
    switch (_environment) {
      case AppEnvironment.development:
        return 'pk_test_YOUR_STRIPE_TEST_KEY';
      case AppEnvironment.staging:
        return 'pk_test_YOUR_STRIPE_TEST_KEY';
      case AppEnvironment.production:
        return 'pk_live_YOUR_STRIPE_LIVE_KEY';
    }
  }

  static bool get isProduction => _environment == AppEnvironment.production;
}
