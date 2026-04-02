# The Cultivated Ledger — Technical Implementation Plan
**Version 1.0 | April 2026 | Flutter Mobile App**

---

## 1. Architecture Pattern

**Clean Architecture with Feature-First Folder Structure**

Feature-first is chosen over layer-first because this is a two-sided marketplace with fundamentally different domain contexts (investor domain, farmer/vendor domain, platform domain). Each feature folder is self-contained with its own `data`, `domain`, and `presentation` layers — a developer navigates to `features/cow_listing/` and finds everything related to that screen without cross-referencing four different top-level folders.

### Project Folder Structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart           # Environment config (dev/staging/prod)
│   │   ├── router.dart               # GoRouter route definitions (all 37 routes)
│   │   └── theme.dart                # AppTheme, color tokens, typography
│   ├── constants/
│   │   └── app_constants.dart        # Platform fee %, share limits, etc.
│   ├── di/
│   │   └── providers.dart            # Riverpod root provider definitions
│   ├── error/
│   │   ├── app_exception.dart
│   │   └── failure.dart
│   ├── network/
│   │   ├── api_client.dart           # Dio HTTP client wrapper
│   │   └── interceptors/
│   ├── storage/
│   │   └── local_storage.dart        # SharedPreferences / Hive wrapper
│   └── utils/
│       ├── currency_formatter.dart
│       ├── date_formatter.dart
│       └── validators.dart
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sign_in_usecase.dart
│   │   │       ├── sign_up_usecase.dart
│   │   │       └── verify_kyc_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       └── screens/
│   │           ├── splash_screen.dart
│   │           ├── onboarding_screen.dart
│   │           ├── login_screen.dart
│   │           ├── register_screen.dart
│   │           ├── role_selection_screen.dart
│   │           └── kyc_screen.dart
│   │
│   ├── investor_dashboard/
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── dashboard_provider.dart
│   │       ├── screens/
│   │       │   └── investor_dashboard_screen.dart
│   │       └── widgets/
│   │           ├── portfolio_hero_card.dart
│   │           ├── farmer_carousel.dart
│   │           ├── opportunity_grid.dart
│   │           └── investment_card.dart
│   │
│   ├── cow_listing/
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── listing_provider.dart
│   │       ├── screens/
│   │       │   └── cow_listing_detail_screen.dart
│   │       └── widgets/
│   │           ├── hero_image_section.dart
│   │           ├── bio_stats_row.dart
│   │           ├── roi_bento.dart
│   │           ├── investment_sidebar_card.dart
│   │           └── verified_farmer_chip.dart
│   │
│   ├── investment_purchase/
│   │   ├── data/ ...
│   │   ├── domain/ ...
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── purchase_provider.dart
│   │       └── screens/
│   │           ├── share_selector_screen.dart
│   │           ├── order_summary_screen.dart
│   │           └── payment_confirmation_screen.dart
│   │
│   ├── portfolio/
│   │   └── presentation/
│   │       └── screens/
│   │           ├── portfolio_screen.dart
│   │           └── investment_detail_screen.dart
│   │
│   ├── search/
│   │   └── presentation/
│   │       └── screens/
│   │           └── search_screen.dart
│   │
│   ├── farmer_profile/
│   │   └── presentation/
│   │       └── screens/
│   │           └── farmer_profile_screen.dart
│   │
│   ├── vendor/
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── listing_form_provider.dart
│   │       └── screens/
│   │           ├── vendor_dashboard_screen.dart
│   │           ├── vendor_listing_form_screen.dart  # 3-step form
│   │           └── listing_management_screen.dart
│   │
│   ├── wallet/
│   │   └── presentation/
│   │       └── screens/
│   │           ├── wallet_screen.dart
│   │           ├── add_funds_screen.dart
│   │           └── withdrawal_screen.dart
│   │
│   ├── notifications/
│   │   └── presentation/
│   │       └── screens/
│   │           └── notification_center_screen.dart
│   │
│   └── profile/
│       └── presentation/
│           └── screens/
│               ├── user_profile_screen.dart
│               └── settings_screen.dart
│
└── main.dart
```

---

## 2. Technology Stack Decisions

### 2.1 State Management: Riverpod ✅ Recommended

**Package:** `flutter_riverpod ^2.5.x` + `riverpod_annotation ^2.3.x` + `riverpod_generator ^2.4.x`

**Rationale vs. alternatives:**

| Option | Verdict | Reason |
|---|---|---|
| **Riverpod** | ✅ Choose | Compile-time safety, no BuildContext dependency, `AsyncNotifier` handles multi-source async composition with near-zero boilerplate. 2-day ramp-up for new devs. |
| BLoC | ❌ Skip | Event-state verbosity appropriate for 50+ event trading platforms. Overkill here. Slower onboarding for junior devs. |
| Provider | ❌ Skip | Riverpod is its spiritual successor by the same author, fixing Provider's context-dependency problem. No reason to use Provider in a new 2026 project. |
| GetX | ❌ Skip | Tight coupling between routing, DI, and state makes unit testing difficult. Unacceptable for a production financial app. |

**Key Riverpod patterns used:**
- `AsyncNotifierProvider` — investment listings (loading/error/data clean handling)
- `StreamProvider` — real-time portfolio value via Supabase Realtime
- `StateNotifierProvider` — multi-step vendor listing form state
- Auto-dispose prevents memory leaks on investment detail screens
- Code generation via `riverpod_generator` eliminates boilerplate

---

### 2.2 Backend: Supabase ✅ Recommended

**Package:** `supabase_flutter ^2.5.x`

**Rationale vs. alternatives:**

| Option | Verdict | Reason |
|---|---|---|
| **Supabase** | ✅ Choose | PostgreSQL with ACID guarantees, Row Level Security, auto-generated REST API, Realtime subscriptions, built-in Auth, S3-compatible Storage, Edge Functions. Saves 6–8 weeks of backend dev vs. custom Node.js. |
| Firebase | ❌ Skip for MVP | The Cultivated Ledger has deeply relational data (Investment → CattleAsset → FarmerProfile → history). Firestore NoSQL requires denormalization or waterfall queries. Financial audit trail demands ACID. Firebase only considered if Supabase Realtime proves insufficient at scale. |
| Custom Node.js / Express | ❌ Defer to Phase 3 | Correct choice after proven PMF. For MVP, adds 6–8 weeks of infrastructure work with no competitive advantage. |
| AWS Amplify | ❌ Skip | Poor developer experience. No advantage over Supabase for this use case. |

**Supabase features used:**
- **Row Level Security (RLS):** Investors can only read their own `investments` rows. Farmers can only write to their own `cattle_assets` rows. Security lives in the database, not application code.
- **Supabase Auth:** Email/password, future Google/Apple OAuth. JWT tokens auto-attached to every API call.
- **Supabase Storage:** Cattle images and CVI PDFs. Served via CDN.
- **Supabase Realtime:** `shares_remaining` counter updates live across all investor devices viewing the same listing.
- **Edge Functions (Deno):** Stripe webhook handling, escrow logic, exit dividend calculations — keeping business-critical logic server-side.

---

### 2.3 Payments: Stripe

**Package:** `flutter_stripe ^10.x`

- **Stripe Connect (Custom accounts):** Marketplace payments — platform collects investor funds, holds in escrow logic, disburses to farmers. Industry standard for investment marketplace apps.
- **PaymentSheet:** Handles Apple Pay, Google Pay, card entry, and ACH in a single bottom sheet, minimizing checkout friction.
- **Stripe Identity (optional):** KYC document verification, supplementing or replacing Persona SDK.
- **Webhooks → Supabase Edge Function:** `payment_intent.succeeded`, `payout.paid` events update DB and trigger push notifications.

**Phase 2 addition:** Dwolla for ACH bank-to-bank transfers (lower fees than Stripe ACH) for institutional investors with deal sizes > $10,000.

---

### 2.4 Navigation: GoRouter

**Package:** `go_router ^14.x`

- Riverpod-compatible declarative routing
- Deep link support (share a listing URL → opens listing detail in app)
- Nested navigation with independent stacks per bottom nav tab
- Route guards: unauthenticated users redirect to `/login`

---

### 2.5 Push Notifications: Firebase Cloud Messaging

**Packages:** `firebase_core ^3.x`, `firebase_messaging ^15.x`, `flutter_local_notifications ^17.x`

FCM is the industry standard for push notification delivery on both iOS (via APNs) and Android. Supabase Edge Functions trigger FCM notifications when key events occur (listing approved, share purchased, dividend disbursed). This uses Firebase for push only — Supabase remains the primary backend.

---

## 3. Complete Screen Inventory (37 Screens)

### Unauthenticated Shell (10 screens)

| Screen | Route Name | Path |
|---|---|---|
| Splash / Loading | `splash` | `/` |
| Onboarding Carousel | `onboarding` | `/onboarding` |
| Role Selection | `role-selection` | `/role-selection` |
| Login | `login` | `/login` |
| Register | `register` | `/register` |
| Forgot Password | `forgot-password` | `/forgot-password` |
| Reset Password | `reset-password` | `/reset-password` |
| KYC Identity Verification | `kyc-verify` | `/kyc-verify` |
| KYC Pending Status | `kyc-pending` | `/kyc-pending` |
| Bank Account Linking | `link-payment` | `/link-payment` |

### Investor Shell — Bottom Nav (4 tabs)

| Screen | Route Name | Path |
|---|---|---|
| Investor Dashboard (Home) | `investor-dashboard` | `/investor/home` |
| Search & Discover | `search` | `/investor/search` |
| Portfolio Overview | `portfolio` | `/investor/portfolio` |
| Investor Profile | `investor-profile` | `/investor/profile` |

### Investor Detail Screens (14 screens)

| Screen | Route Name | Path |
|---|---|---|
| Cow Listing Detail | `listing-detail` | `/investor/listing/:id` |
| Share Quantity Selector | `purchase-shares` | `/investor/listing/:id/purchase` |
| Order Summary | `order-summary` | `/investor/listing/:id/purchase/summary` |
| Purchase Confirmation | `purchase-confirmation` | `/investor/listing/:id/purchase/confirmation` |
| Farmer Public Profile | `farmer-profile` | `/investor/farmer/:id` |
| Portfolio Investment Detail | `portfolio-investment` | `/investor/portfolio/:investmentId` |
| Notification Center | `notifications` | `/investor/notifications` |
| Wallet | `wallet` | `/investor/wallet` |
| Add Funds | `wallet-add-funds` | `/investor/wallet/add` |
| Withdrawal Request | `wallet-withdraw` | `/investor/wallet/withdraw` |
| Transaction History | `transactions` | `/investor/transactions` |
| Settings | `investor-settings` | `/investor/settings` |
| About / Legal / Terms | `legal` | `/investor/legal` |

### Farmer/Vendor Shell — Bottom Nav (4 tabs)

| Screen | Route Name | Path |
|---|---|---|
| Vendor Dashboard (Home) | `vendor-dashboard` | `/vendor/home` |
| My Listings | `vendor-listings` | `/vendor/listings` |
| Vendor Earnings | `vendor-earnings` | `/vendor/earnings` |
| Vendor Profile | `vendor-profile` | `/vendor/profile` |

### Farmer/Vendor Detail Screens (9 screens)

| Screen | Route Name | Path |
|---|---|---|
| New Listing Form (3-step) | `vendor-new-listing` | `/vendor/listings/new` |
| Edit Listing | `vendor-edit-listing` | `/vendor/listings/:id/edit` |
| Listing Management Detail | `vendor-listing-detail` | `/vendor/listings/:id` |
| Investor List (per listing) | `listing-investors` | `/vendor/listings/:id/investors` |
| Vendor Payout Detail | `vendor-payout-detail` | `/vendor/earnings/:payoutId` |
| Vendor Settings | `vendor-settings` | `/vendor/settings` |

---

## 4. Data Models

### User
```dart
class User {
  final String id;                    // UUID — PK
  final String email;
  final UserRole role;                // investor | farmer | admin
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final KycStatus kycStatus;          // notStarted | pending | verified | rejected
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum UserRole { investor, farmer, admin }
enum KycStatus { notStarted, pending, verified, rejected }
```

### FarmerProfile
```dart
class FarmerProfile {
  final String id;                    // UUID — FK → User.id
  final String farmName;
  final String? bio;
  final String location;
  final double acreage;
  final int yearsExperience;
  final bool isVerified;
  final double averageRoi;            // computed from completed cycles
  final int totalDealsCompleted;
  final double rating;                // 0.0–5.0
  final int ratingCount;
  final String? profileImageUrl;
  final String? heroImageUrl;
  final List<String> certifications;
}
```

### CattleAsset (Listing)
```dart
class CattleAsset {
  final String id;                    // UUID — PK
  final String farmerId;              // FK → FarmerProfile.id
  final String batchName;             // e.g. "Angus Select Batch #042"
  final CattleBreed breed;
  final int ageMonths;
  final double weightLbs;
  final int healthScore;              // 0–100
  final String location;
  final ListingStatus status;
  final int totalShares;
  final int sharesRemaining;
  final double pricePerShare;
  final double estimatedRoiPercent;
  final int maturityMonths;
  final DateTime? expectedMarketDate;
  final double exitDividendPerShare;  // computed: pricePerShare * estimatedRoiPercent / 100
  final String? primaryImageUrl;
  final List<String> galleryImageUrls;
  final String? cviDocumentUrl;       // Certified Veterinary Inspection PDF
  final String healthNotes;
  final bool hasInsurance;
  final bool hasIotTracking;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
}

enum ListingStatus {
  draft, underReview, active, fullyFunded, marketReady, completed, cancelled
}

enum CattleBreed {
  angus, hereford, brahman, charolais, simmental,
  limousin, wagyu, longhorn, highland, other
}
```

### Investment
```dart
class Investment {
  final String id;                    // UUID — PK
  final String investorId;            // FK → User.id
  final String cattleAssetId;         // FK → CattleAsset.id
  final int sharesOwned;
  final double pricePerShareAtPurchase;
  final double totalInvested;
  final InvestmentStatus status;      // active | marketReady | exited
  final double? exitDividendPaid;     // null until exited
  final double? realizedRoiPercent;   // null until exited
  final DateTime purchasedAt;
  final DateTime? exitedAt;
}

enum InvestmentStatus { active, marketReady, exited }
```

### Transaction
```dart
class Transaction {
  final String id;                    // UUID — PK
  final String userId;                // FK → User.id
  final TransactionType type;
  final double amount;
  final String currencyCode;          // "USD"
  final TransactionStatus status;     // pending | completed | failed | refunded
  final String? stripePaymentIntentId;
  final String? relatedInvestmentId;
  final String? relatedCattleAssetId;
  final String description;
  final DateTime createdAt;
}

enum TransactionType { investment, dividendPayout, walletDeposit, walletWithdrawal, platformFee }
enum TransactionStatus { pending, completed, failed, refunded }
```

### AppNotification
```dart
class AppNotification {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic> metadata;  // e.g. { "listingId": "abc123" }
  final bool isRead;
  final DateTime createdAt;
}

enum NotificationType {
  purchaseConfirmed, listingApproved, listingFullyFunded,
  healthUpdate, marketReady, dividendPaid,
  kycApproved, kycRejected, general
}
```

---

## 5. Key Flutter Packages

```yaml
dependencies:
  # Core Framework
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  go_router: ^14.2.0

  # Backend & Networking
  supabase_flutter: ^2.5.0
  dio: ^5.4.3
  internet_connection_checker_plus: ^2.4.0

  # Payments
  flutter_stripe: ^10.2.0

  # Auth / Security
  local_auth: ^2.2.0              # Biometric lock on app open
  flutter_web_auth_2: ^4.0.0      # OAuth2 flows

  # Push Notifications
  firebase_core: ^3.1.0
  firebase_messaging: ^15.0.0
  flutter_local_notifications: ^17.0.0

  # UI & Design System
  google_fonts: ^6.2.1            # Manrope + Work Sans
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0                 # Loading skeleton screens
  smooth_page_indicator: ^1.1.0   # Onboarding carousel dots
  percent_indicator: ^4.2.3       # Share progress bars
  fl_chart: ^0.68.0               # Portfolio performance chart (Phase 2)
  lottie: ^3.1.0                  # Micro-animations (success, empty states)

  # Forms
  reactive_forms: ^17.0.0         # Vendor listing form validation

  # File Handling
  image_picker: ^1.1.1            # Cattle image upload
  file_picker: ^8.0.3             # CVI PDF upload
  path_provider: ^2.1.3

  # Utilities
  intl: ^0.19.0                   # Currency + date formatting
  uuid: ^4.4.0
  logger: ^2.3.0
  package_info_plus: ^8.0.2
  url_launcher: ^6.3.0            # Open prospectus PDF

  # Local Storage / Offline Cache
  shared_preferences: ^2.3.0
  hive_flutter: ^1.1.0            # Cache listings for offline browsing

dev_dependencies:
  riverpod_generator: ^2.4.3
  build_runner: ^2.4.9
  flutter_lints: ^4.0.0
  mocktail: ^1.0.3
  flutter_test:
    sdk: flutter
```

---

## 6. Design System in Flutter

### 6.1 Color Tokens (`core/config/theme.dart`)

Mapping all stitch design tokens directly to Flutter `Color` constants:

```dart
class AppColors {
  // Primary — Deep Forest Green
  static const primary                = Color(0xFF154212);
  static const onPrimary              = Color(0xFFFFFFFF);
  static const primaryContainer       = Color(0xFF2D5A27);
  static const onPrimaryContainer     = Color(0xFF9DD090);
  static const primaryFixed           = Color(0xFFBCF0AE);
  static const onPrimaryFixed         = Color(0xFF002201);
  static const primaryFixedDim        = Color(0xFFA1D494);
  static const onPrimaryFixedVariant  = Color(0xFF23501E);

  // Secondary — Arable Soil Brown
  static const secondary              = Color(0xFF805533);
  static const onSecondary            = Color(0xFFFFFFFF);
  static const secondaryContainer     = Color(0xFFFDC39A);
  static const onSecondaryContainer   = Color(0xFF794E2E);

  // Tertiary — Harvest Gold
  static const tertiary               = Color(0xFF735C00);
  static const onTertiary             = Color(0xFFFFFFFF);
  static const tertiaryContainer      = Color(0xFFCCA730);
  static const onTertiaryContainer    = Color(0xFF4F3D00);

  // Surface Hierarchy — Pristine Canvas
  static const background             = Color(0xFFFAF9F8);
  static const surface                = Color(0xFFFAF9F8);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow    = Color(0xFFF4F3F2);
  static const surfaceContainer       = Color(0xFFEEEEED);
  static const surfaceContainerHigh   = Color(0xFFE9E8E7);
  static const surfaceContainerHighest= Color(0xFFE3E2E1);
  static const surfaceDim             = Color(0xFFDADAD9);
  static const surfaceBright          = Color(0xFFFAF9F8);

  // On-Surface
  static const onBackground           = Color(0xFF1A1C1C);
  static const onSurface              = Color(0xFF1A1C1C);
  static const onSurfaceVariant       = Color(0xFF42493E);

  // Outline
  static const outline                = Color(0xFF72796E);
  static const outlineVariant         = Color(0xFFC2C9BB);

  // Error
  static const error                  = Color(0xFFBA1A1A);
  static const onError                = Color(0xFFFFFFFF);
  static const errorContainer         = Color(0xFFFFDAD6);

  // Shadow base (on-surface color for ambient shadows)
  static const shadowBase             = Color(0x0F1A1C1C); // rgba(26,28,28,0.06)
}
```

### 6.2 Typography

```dart
class AppTextStyles {
  // Manrope — Headlines & Display
  static const displayLg = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 56,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.02 * 56,
  );
  static const headlineXl = TextStyle(
    fontFamily: 'Manrope', fontSize: 48, fontWeight: FontWeight.w800,
    letterSpacing: -1,
  );
  static const headlineLg = TextStyle(
    fontFamily: 'Manrope', fontSize: 32, fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
  static const headlineMd = TextStyle(
    fontFamily: 'Manrope', fontSize: 24, fontWeight: FontWeight.w700,
  );
  static const headlineSm = TextStyle(
    fontFamily: 'Manrope', fontSize: 20, fontWeight: FontWeight.w700,
  );

  // Work Sans — Body & Labels
  static const bodyLg = TextStyle(
    fontFamily: 'Work Sans', fontSize: 16, fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static const bodyMd = TextStyle(
    fontFamily: 'Work Sans', fontSize: 14, fontWeight: FontWeight.w400,
  );
  static const labelMd = TextStyle(
    fontFamily: 'Work Sans', fontSize: 12, fontWeight: FontWeight.w600,
  );
  static const labelSm = TextStyle(
    fontFamily: 'Work Sans', fontSize: 10, fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );
}
```

### 6.3 Shadow Constants

```dart
class AppShadows {
  // Ambient card shadow — used on all cards and floating panels
  static const ambientCard = BoxShadow(
    offset: Offset(0, 12),
    blurRadius: 32,
    color: Color(0x0F1A1C1C),   // rgba(26,28,28,0.06)
  );

  // Subtle list shadow — listing/farmer cards in lists
  static const subtleList = BoxShadow(
    offset: Offset(0, 12),
    blurRadius: 32,
    color: Color(0x0A1A1C1C),   // rgba(26,28,28,0.04)
  );

  // Bottom nav shadow (upward)
  static const bottomNav = BoxShadow(
    offset: Offset(0, -4),
    blurRadius: 24,
    color: Color(0x0A1A1C1C),
  );
}
```

### 6.4 Glassmorphism Navigation Bar

```dart
Widget buildGlassNavBar() {
  return ClipRRect(
    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        color: AppColors.surface.withOpacity(0.85),
        // ... nav items
      ),
    ),
  );
}
```

### 6.5 Primary Gradient Button

```dart
decoration: BoxDecoration(
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.primaryContainer],
  ),
  borderRadius: BorderRadius.circular(4),
)
```

---

## 7. Supabase Database Schema

```sql
-- Users table extends Supabase auth.users
create table public.farmer_profiles (
  id uuid references auth.users on delete cascade primary key,
  farm_name text not null,
  bio text,
  location text,
  acreage numeric,
  years_experience int,
  is_verified boolean default false,
  rating numeric(3,2) default 0.0,
  rating_count int default 0,
  profile_image_url text,
  hero_image_url text,
  certifications text[],
  created_at timestamptz default now()
);

create table public.cattle_assets (
  id uuid default gen_random_uuid() primary key,
  farmer_id uuid references public.farmer_profiles not null,
  batch_name text not null,
  breed text not null,
  age_months int,
  weight_lbs numeric,
  health_score int check (health_score between 0 and 100),
  location text,
  status text default 'draft',
  -- draft | under_review | active | fully_funded | market_ready | completed | cancelled
  total_shares int not null,
  shares_remaining int not null,
  price_per_share numeric not null,
  estimated_roi_percent numeric,
  maturity_months int,
  expected_market_date date,
  primary_image_url text,
  gallery_image_urls text[],
  cvi_document_url text,
  health_notes text,
  has_insurance boolean default false,
  has_iot_tracking boolean default false,
  is_verified boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table public.investments (
  id uuid default gen_random_uuid() primary key,
  investor_id uuid references auth.users not null,
  cattle_asset_id uuid references public.cattle_assets not null,
  shares_owned int not null,
  price_per_share_at_purchase numeric not null,
  total_invested numeric not null,  -- shares_owned * price_per_share_at_purchase
  status text default 'active',     -- active | market_ready | exited
  exit_dividend_paid numeric,
  realized_roi_percent numeric,
  purchased_at timestamptz default now(),
  exited_at timestamptz
);

create table public.transactions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  type text not null,
  -- investment | dividend_payout | wallet_deposit | wallet_withdrawal | platform_fee
  amount numeric not null,
  currency_code text default 'USD',
  status text default 'pending',    -- pending | completed | failed | refunded
  stripe_payment_intent_id text,
  related_investment_id uuid references public.investments,
  related_cattle_asset_id uuid references public.cattle_assets,
  description text,
  created_at timestamptz default now()
);

create table public.wallets (
  id uuid references auth.users on delete cascade primary key,
  balance numeric default 0.0,
  currency_code text default 'USD',
  stripe_customer_id text,
  updated_at timestamptz default now()
);

create table public.notifications (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  type text not null,
  title text not null,
  body text not null,
  metadata jsonb default '{}',
  is_read boolean default false,
  created_at timestamptz default now()
);

-- Row Level Security (RLS) examples
alter table public.investments enable row level security;
create policy "investors_read_own" on public.investments
  for select using (auth.uid() = investor_id);
create policy "investors_insert_own" on public.investments
  for insert with check (auth.uid() = investor_id);

alter table public.cattle_assets enable row level security;
create policy "anyone_read_active" on public.cattle_assets
  for select using (status in ('active', 'fully_funded', 'market_ready', 'completed'));
create policy "farmers_write_own" on public.cattle_assets
  for all using (auth.uid() = farmer_id);

-- Index for performance
create index idx_cattle_assets_status on public.cattle_assets(status);
create index idx_cattle_assets_farmer on public.cattle_assets(farmer_id);
create index idx_investments_investor on public.investments(investor_id);
create index idx_investments_asset on public.investments(cattle_asset_id);
create index idx_transactions_user on public.transactions(user_id, created_at desc);
```

---

## 8. Sprint Plan

### Sprint 1 — Foundation (Weeks 1–2)

**Tasks:**
- Flutter project scaffolding (feature-first structure as defined above)
- Supabase project setup: create all database tables, RLS policies, indexes
- Stripe Connect account setup in test mode
- GoRouter configuration with all 37 route definitions
- `AppTheme`, `AppColors`, `AppTextStyles`, `AppShadows` classes
- Core network layer: Dio client, Supabase client initialization, error handling
- CI/CD pipeline: GitHub Actions → Fastlane → TestFlight + Firebase App Distribution

**✅ Done When:** Compilable blank app, all routes navigable, correct fonts loading, correct colors applied, CI pipeline green.

---

### Sprint 2 — Authentication & Onboarding (Weeks 3–4)

**Tasks:**
- Splash screen with brand animation (Lottie agriculture icon)
- Onboarding 3-screen carousel (`smooth_page_indicator`)
- Role selection screen (Investor vs. Farmer card tap targets)
- Email/password registration with Supabase Auth
- Login screen + forgot/reset password flow
- KYC SDK integration (Persona.com) — basic integration + pending status screen
- Bank/card linking via Stripe SetupIntent + PaymentSheet
- `AuthNotifier` (Riverpod): auth state persisted with SharedPreferences
- GoRouter guards: unauthenticated users redirect to `/login`

**✅ Done When:** Full auth flow works end-to-end in test mode.

---

### Sprint 3 — Investor Dashboard & Discovery (Weeks 5–7)

**Tasks:**
- Investor Dashboard: portfolio hero bento card (deep green, `displayLg` portfolio value), wallet balance side card, ROI and active assets metrics
- Top Rated Farmers horizontal scroll carousel: farmer cards with avatar, verified gold badge, rating chip, historical ROI
- Active Opportunities grid: cattle cards (hero image, batch name, ROI, shares remaining progress bar, price/share, "Invest Now" CTA)
- `DashboardNotifier` (`AsyncNotifier`): fetches portfolio aggregate and active listings from Supabase
- Glassmorphism bottom nav bar with safe area handling (iOS home indicator)
- Floating Action Button (tertiary gold, `add` icon)
- Shimmer loading skeletons for all async sections
- Search screen: text field, filter chips (breed, ROI range, duration), grid results

**✅ Done When:** Fully interactive investor dashboard matching stitch designs with live Supabase data.

---

### Sprint 4 — Cow Listing Detail & Purchase Flow (Weeks 8–9)

**Tasks:**
- Cow Listing Detail screen:
  - Asymmetric hero image (4:3 ratio, `CachedNetworkImage`)
  - Verified badge overlay (tertiary-container gold)
  - Biological stats grid (breed, age, health score, weight — `surfaceContainerLow` cards)
  - Investment sidebar card (share price, shares remaining, gradient CTA)
  - ROI bento (12.4% hero, maturity timeline, exit dividend/share)
  - Risk/security section (insurance icon, IoT icon, historical comparison card + investor avatar stack)
- Supabase Realtime subscription for `shares_remaining` counter
- Share Quantity Selector: stepper widget, real-time total cost calculation
- Order Summary: investment breakdown, platform fee line item, estimated exit value, legal disclaimer
- Payment Confirmation: Stripe PaymentSheet integration, success Lottie animation
- `InvestmentPurchaseNotifier`: orchestrates purchase flow via Supabase Edge Function for escrow logic

**✅ Done When:** Complete end-to-end investment purchase in Stripe test mode.

---

### Sprint 5 — Farmer/Vendor Portal (Weeks 10–11)

**Tasks:**
- Farmer Public Profile screen:
  - Asymmetric portrait hero image, verified badge (absolute positioned)
  - Farm name, location, rating, about section
  - Active listings horizontal scroll, cycle history timeline
- Vendor Dashboard: listings table, capital raised per listing, investor count badge
- Vendor Listing Form — 3-step flow:
  - **Step 1 (Visual):** Multi-image upload grid (`ImagePicker`, primary 16:9 + secondary slots), editorial step sidebar
  - **Step 2 (Biological):** Breed `DropdownButton`, age `TextField`, health notes `TextFormField`, CVI PDF upload (`FilePicker`)
  - **Step 3 (Financial):** Shares, price/share, expected ROI (all validated with `reactive_forms`), auto-calculated total asset valuation summary card
- Draft save: persist to Hive locally + Supabase as `draft` status
- Submit for review: status → `under_review`, triggers admin FCM notification
- `ListingFormNotifier` (`StateNotifier`): multi-step form state, per-step validation

**Image upload optimization:** `ImagePicker` with `maxWidth: 1920, imageQuality: 75` — compress before upload. Resumable uploads via Supabase Storage TUS protocol. Per-file upload progress indicators.

**✅ Done When:** Farmer can onboard, create a listing draft, and submit for review.

---

### Sprint 6 — Portfolio, Wallet, Notifications & Polish (Weeks 12–14)

**Tasks:**
- Portfolio screen: active investment list, per-investment progress (% of maturity elapsed), total invested, current estimated value
- Investment detail: original purchase data, current health status, days to maturity, share option
- Wallet: balance, add funds (Stripe PaymentSheet), withdrawal request form
- Transaction history: chronological list with type icons, amount, status chip
- Notification center: grouped by date, read/unread state, tap → navigate to relevant screen
- FCM integration: register device token on login, handle foreground + background + terminated app scenarios
- App-wide error boundary: user-friendly error screens with retry button
- Offline mode: Hive-cached listings with "Cached Data" banner when offline
- Deep link handling: share listing URL → opens listing detail
- App Store / Play Store submission prep: app icons, splash screen, privacy policy URL, reviewer test account

**✅ Done When:** Feature-complete MVP ready for TestFlight beta and Play Store internal testing.

---

## 9. Development Milestones

| Milestone | Target | Definition of Done |
|---|---|---|
| M1: Foundation | Week 2 | Compilable app, all routes defined, Supabase schema live, CI/CD green |
| M2: Auth Complete | Week 4 | Full auth flow end-to-end, KYC integrated, Stripe setup complete |
| M3: Investor Dashboard | Week 7 | Dashboard + Search live with real Supabase data, glassmorphism nav correct |
| M4: Purchase Flow | Week 9 | Complete end-to-end investment purchase in Stripe test mode |
| M5: Farmer Portal | Week 11 | Farmer onboarding, listing form, public profile, vendor dashboard all functional |
| M6: MVP Complete | Week 14 | Portfolio, wallet, notifications, offline handling, TestFlight open beta |
| M7: App Store Launch | Week 18 | iOS App Store + Google Play Store public release |

---

## 10. Risk Register

| # | Risk | Severity | Mitigation |
|---|---|---|---|
| 1 | KYC / Regulatory approval delay | **HIGH** | Engage legal counsel in Week 1 (parallel with dev). Begin KYC SDK in Sprint 2 with "waitlist" fallback mode. |
| 2 | Marketplace cold start — no listings at launch | **HIGH** | Executive team manually onboards 20 pre-vetted farmers + 40 pre-approved listings before public launch. Sales risk, not technical. |
| 3 | Stripe Connect application delay (2–4 weeks) | **MEDIUM** | Submit Stripe Connect application in Week 1. Provide clear documentation: agricultural asset marketplace with insurance + escrow. |
| 4 | iOS App Store rejection (financial/investment apps) | **MEDIUM** | Add clear legal disclaimers on every investment screen. Never characterize returns as "guaranteed." Submit with pre-funded reviewer demo account. |
| 5 | Supabase Realtime bottleneck at 1,000+ concurrent users | **LOW (MVP) / MEDIUM (Phase 2)** | Optimistic UI updates client-side. Debounce Realtime subscriptions to 5-second intervals. Upgrade to Supabase Pro by Month 6. |
| 6 | Farmer app literacy gap | **MEDIUM** | In-app 30-second video walkthrough per form step. Prominent "Save Draft" for multi-session completion. Phone support for first 90 days. |
| 7 | Image upload failures on rural 3G | **MEDIUM** | `ImagePicker` with quality:75 compression. Resumable uploads via Supabase TUS protocol. Per-file progress indicators. |

---

## 11. Reference Files

All stitch source files that implementation must match:

| Screen | HTML Reference | Screenshot |
|---|---|---|
| Investor Dashboard | `stitch/investor_dashboard/code.html` | `stitch/investor_dashboard/screen.png` |
| Cow Listing Detail | `stitch/cow_listing_detail/code.html` | `stitch/cow_listing_detail/screen.png` |
| Farmer Profile | `stitch/farmer_profile/code.html` | `stitch/farmer_profile/screen.png` |
| Vendor Listing Form | `stitch/vendor_listing_form/code.html` | `stitch/vendor_listing_form/screen.png` |
| Design System Spec | `stitch/terra_capital/DESIGN.md` | — |
| Interactive Design System | `design-system.html` | — |
