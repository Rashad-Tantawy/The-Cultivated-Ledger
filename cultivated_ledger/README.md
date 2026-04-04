# The Cultivated Ledger

A fractional livestock investment platform built with Flutter and Supabase — bridging the agricultural economy with modern retail investing. Investors purchase fractional ownership in verified cattle assets, while farmers gain access to capital previously available only through institutional lenders.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Core Layer](#core-layer)
- [Feature Implementation](#feature-implementation)
  - [Authentication](#authentication)
  - [Market / Cattle Assets](#market--cattle-assets)
  - [Investment](#investment)
  - [Investor Dashboard](#investor-dashboard)
  - [Farmer / Vendor](#farmer--vendor)
  - [Wallet](#wallet)
  - [Notifications](#notifications)
- [Database Schema](#database-schema)
- [Design System](#design-system)
- [Getting Started](#getting-started)
- [Implementation Status](#implementation-status)
- [Roadmap](#roadmap)

---

## Overview

The Cultivated Ledger is a two-sided marketplace mobile app targeting two user personas:

- **Investors** — accredited and non-accredited individuals seeking tangible, uncorrelated assets with transparent, insured, and biometrically tracked returns (target ROI: 10–18% over 12–24 months).
- **Farmers / Ranchers** — independent operators who list verified cattle assets to raise capital at better rates than institutional loans, without giving up land equity.

The platform collects a **5% carry fee on investment returns** at exit and a **1.5% origination fee** when a listing becomes fully funded.

---

## Features

### Authentication & Onboarding
- Splash screen with brand identity and dual investor/farmer CTAs
- Email/password sign up and sign in via Supabase Auth
- Animated role selector (Investor or Farmer) on registration
- Session persistence via secure storage
- Route guards — unauthenticated users redirect to login; farmers and investors are routed to their respective dashboards

### Investor
- **Dashboard** — live portfolio value, ROI, active asset count, wallet balance, active opportunities grid, top-rated farmer listings
- **Portfolio Detail** — per-investment breakdown, yield tracking, health status
- **Investment Detail** — full cattle asset profile, biological stats, ROI bento, share purchase flow

### Farmer / Vendor
- **Dashboard** — active listings overview, capital raised per listing, investor count
- **Listing Form** — 3-step form (visual assets → biological profile → financial structure) with draft save

### Market
- **Search & Discovery** — browse active listings with text search and filters (breed, ROI range, maturity)
- Real-time `shares_remaining` counter via Supabase Realtime

### Wallet
- Balance display, transaction history, deposit and withdrawal UI

### Notifications
- In-app notification feed with unread count badge (Supabase Realtime)
- Mark as read / mark all as read

### Profile
- User profile screen, KYC status display, account settings

---

## Tech Stack

| Concern | Technology |
|---|---|
| Framework | Flutter (Dart) `>=3.3.0` |
| State Management | Riverpod `^2.5.1` |
| Navigation | GoRouter `^14.2.0` |
| Backend | Supabase (PostgreSQL + Auth + Storage + Realtime + Edge Functions) |
| Payments | Stripe Connect (`flutter_stripe ^10.2.0`) |
| Push Notifications | Firebase Cloud Messaging |
| Secure Storage | `flutter_secure_storage ^9.2.2` |
| Fonts | Google Fonts — Manrope + Work Sans |
| UI Utilities | shimmer, percent_indicator, cached_network_image, lottie |
| Utilities | intl, uuid, logger, equatable, url_launcher |

---

## Architecture

The project follows **feature-first clean architecture**. Each feature is fully self-contained with its own `data`, `domain`, and `presentation` layers. This keeps investor logic, farmer logic, and platform logic independently navigable and testable.

```
Presentation  →  Domain  →  Data
(Riverpod)       (Entities,   (Supabase, Stripe,
                  UseCases,    Remote Datasources,
                  Repos)       Models)
```

**Data flows in one direction:**
- UI watches a Riverpod provider
- Provider calls a use case (domain)
- Use case calls a repository interface (domain)
- Repository implementation calls a datasource (data)
- Datasource talks to Supabase

**Why this matters for a financial app:**
- Business logic (fee calculations, share counts, escrow rules) lives in the domain layer — never in widgets
- Repository interfaces allow swapping Supabase for a custom API in Phase 3 without touching the UI
- Riverpod's compile-time safety catches provider misuse before runtime

---

## Project Structure

```
lib/
├── main.dart                          # App entry, Supabase init, ProviderScope
│
├── core/
│   ├── config/
│   │   ├── app_config.dart            # Environment config (dev/staging/prod), Supabase + Stripe keys
│   │   └── router.dart                # GoRouter with auth guards + role-based routing
│   ├── constants/
│   │   └── app_constants.dart         # Table names, bucket names, fee %, edge function names
│   ├── error/
│   │   ├── app_exception.dart         # Typed exceptions (Auth, Network, Payment, Storage...)
│   │   └── failure.dart               # Domain-layer failure types (equatable)
│   ├── network/
│   │   ├── supabase_client.dart       # Global supabase client accessor
│   │   └── network_info.dart          # Connectivity checker
│   ├── storage/
│   │   └── local_storage.dart         # FlutterSecureStorage + SharedPreferences wrapper
│   ├── theme/
│   │   ├── app_colors.dart            # Full Material 3 color system (Heritage Modernist)
│   │   ├── app_text_styles.dart       # Typography tokens (Manrope + Work Sans)
│   │   └── app_theme.dart             # ThemeData, gradients, shadow constants
│   └── utils/
│       ├── currency_formatter.dart    # USD formatting, compact, ROI percent
│       ├── date_formatter.dart        # Short/long/relative date + maturity display
│       ├── validators.dart            # Email, password, share count validators
│       └── logger.dart                # Logger (debug in dev, warning in prod)
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/auth_remote_datasource.dart   # Supabase auth calls
│   │   │   ├── models/user_model.dart                    # JSON ↔ entity mapping
│   │   │   └── repositories/auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/user.dart                        # AppUser, UserRole, KycStatus
│   │   │   ├── repositories/auth_repository.dart         # Abstract interface
│   │   │   └── usecases/
│   │   │       ├── sign_in_usecase.dart
│   │   │       ├── sign_up_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   └── presentation/
│   │       ├── providers/auth_provider.dart              # AuthNotifier, authStateProvider
│   │       ├── screens/                                  # splash, login, sign_up
│   │       └── widgets/                                  # auth_text_field, glass_app_bar, primary_button
│   │
│   ├── market/
│   │   ├── data/
│   │   │   ├── datasources/cattle_asset_remote_datasource.dart  # Supabase queries + Realtime
│   │   │   ├── models/cattle_asset_model.dart                   # JSON mapping with farmer join
│   │   │   └── repositories/cattle_asset_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/cattle_asset.dart                # CattleAsset, ListingStatus, CattleBreed
│   │   │   └── repositories/cattle_asset_repository.dart
│   │   └── presentation/
│   │       ├── providers/market_provider.dart            # activeListingsProvider, searchResultsProvider, listingDetailProvider
│   │       └── screens/search_market_screen.dart
│   │
│   ├── investment/
│   │   ├── data/
│   │   │   ├── datasources/investment_remote_datasource.dart  # Supabase + Edge Function call
│   │   │   ├── models/investment_model.dart
│   │   │   └── repositories/investment_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/investment.dart                  # Investment, InvestmentStatus
│   │   │   └── repositories/investment_repository.dart
│   │   └── presentation/
│   │       ├── providers/investment_provider.dart        # myInvestmentsProvider, portfolioSummaryProvider
│   │       └── screens/investment_detail_screen.dart
│   │
│   ├── investor/
│   │   └── presentation/
│   │       ├── providers/investor_dashboard_provider.dart  # Aggregates portfolio + listings + wallet
│   │       └── screens/                                    # investor_dashboard, portfolio_detail
│   │
│   ├── farmer/
│   │   ├── data/
│   │   │   └── datasources/farmer_remote_datasource.dart  # Farmer profile, listings CRUD
│   │   └── presentation/
│   │       ├── providers/farmer_provider.dart             # myFarmerProfileProvider, listingFormProvider
│   │       └── screens/farmer_dashboard_screen.dart
│   │
│   ├── wallet/
│   │   ├── data/
│   │   │   └── datasources/wallet_remote_datasource.dart  # Balance + transaction history
│   │   └── presentation/
│   │       ├── providers/wallet_provider.dart             # walletBalanceProvider, transactionsProvider
│   │       └── screens/wallet_screen.dart
│   │
│   ├── notifications/
│   │   ├── data/
│   │   │   └── datasources/notification_remote_datasource.dart  # Fetch, mark read, Realtime count
│   │   └── presentation/
│   │       ├── providers/notification_provider.dart       # NotificationNotifier, unreadCountProvider
│   │       └── screens/notifications_screen.dart
│   │
│   └── profile/
│       └── presentation/
│           └── screens/profile_screen.dart
│
supabase/
└── migrations/
    └── 001_initial_schema.sql         # Full DB schema (run in Supabase SQL Editor)
```

---

## Core Layer

### `app_config.dart`
Three-environment configuration class (development, staging, production). Holds Supabase project URL, anon key, and Stripe publishable key. Switch environments by calling `AppConfig.setEnvironment(AppEnvironment.production)` in `main.dart` before release.

### `router.dart`
GoRouter with full auth-aware route guards:
- Unauthenticated users → `/login`
- Investors → `/investor/home`
- Farmers → `/vendor/home`
- `GoRouterRefreshStream` listens to `authStateChanges` so the router re-evaluates on every auth event (sign in, sign out, token refresh)

### `app_constants.dart`
Single source of truth for all Supabase table names, storage bucket names, edge function names, platform fee percentages, and pagination defaults. No magic strings in datasources.

### Error Handling
Two layers:
- `AppException` subtypes (thrown by datasources): `AuthException`, `NetworkException`, `ServerException`, `PaymentException`, `StorageException`, etc.
- `Failure` subtypes (returned by repositories to presentation): `AuthFailure`, `NetworkFailure`, `PaymentFailure`, etc.

This keeps Supabase-specific errors from leaking into the domain or UI layer.

### `local_storage.dart`
Wraps `FlutterSecureStorage` (for session tokens, sensitive credentials) and `SharedPreferences` (for non-sensitive settings like onboarding completion flag, last seen notification timestamp).

---

## Feature Implementation

### Authentication

**Sign Up Flow:**
1. User selects role (Investor / Farmer) on `SignUpScreen`
2. `AuthNotifier.signUp()` calls `SignUpUseCase`
3. Use case calls `AuthRepositoryImpl` → `AuthRemoteDatasource`
4. `supabase.auth.signUp()` fires with `{ role, first_name, last_name }` in user metadata
5. Supabase DB trigger `on_auth_user_created` auto-inserts a row in `public.users`
6. `authStateProvider` (StreamProvider) emits the new `AppUser`
7. GoRouter redirect picks up the new auth state → navigates to dashboard

**Sign In Flow:**
1. `AuthNotifier.signIn()` → `supabase.auth.signInWithPassword()`
2. JWT stored in Supabase's secure session store
3. `AuthRemoteDatasource` fetches the user's full profile from `public.users`
4. `authStateProvider` emits → GoRouter redirects

**Session Restore:**
On cold start, `GetCurrentUserUseCase` checks `supabase.auth.currentSession`. If a valid session exists, the user skips the auth flow entirely.

**Route Guards:**
```dart
redirect: (context, state) {
  final isLoggedIn = authState.valueOrNull != null;
  if (!isLoggedIn && !isPublicRoute) return '/login';
  if (isLoggedIn && user.isFarmer) return '/vendor/home';
  if (isLoggedIn && user.isInvestor) return '/investor/home';
}
```

---

### Market / Cattle Assets

**Entity: `CattleAsset`**
Holds all listing data including farmer info (joined from `farmer_profiles`), biological stats, share count, pricing, computed `exitDividendPerShare`, and listing status enum (`draft → under_review → active → fully_funded → market_ready → completed`).

**Providers:**
| Provider | Type | Purpose |
|---|---|---|
| `activeListingsProvider` | `FutureProvider` | Paginated active listings feed |
| `topListingsProvider` | `FutureProvider` | Top 5 listings for dashboard carousel |
| `listingDetailProvider(id)` | `StreamProvider.family` | Realtime single listing (live `shares_remaining`) |
| `searchStateProvider` | `StateProvider` | Current search query + filters |
| `searchResultsProvider` | `FutureProvider` | Filtered results, reacts to `searchStateProvider` |

**Realtime:**
`CattleAssetRemoteDatasource.watchListing(id)` uses `supabase.from('cattle_assets').stream()` so `shares_remaining` updates live across all devices viewing the same listing when another investor purchases shares.

---

### Investment

**Entity: `Investment`**
Tracks `sharesOwned`, `pricePerShareAtPurchase`, `totalInvested`, `status`, and `exitDividendPaid`. Computed `currentValue` returns `exitDividendPaid` if exited, else `totalInvested`.

**Purchase Flow (Stripe):**
1. User selects share quantity on the investment detail screen
2. Flutter calls `InvestmentRemoteDatasource.createPaymentIntent()` → Supabase Edge Function `create-payment-intent`
3. Edge Function validates share availability, creates Stripe `PaymentIntent`, returns `client_secret`
4. Flutter presents `PaymentSheet` (card / Apple Pay / Google Pay)
5. On success, Stripe fires `payment_intent.succeeded` webhook → Edge Function `handle-payment-webhook`
6. Webhook handler: inserts `investments` row, decrements `shares_remaining` atomically, creates `transactions` record, sends push notification

**Providers:**
| Provider | Type | Purpose |
|---|---|---|
| `myInvestmentsProvider` | `FutureProvider` | All investments for current user |
| `portfolioSummaryProvider` | `Provider` | Computed total value, ROI %, active count |
| `investorDashboardProvider` | `FutureProvider` | Aggregates investments + listings + wallet balance for dashboard |

---

### Investor Dashboard

`investorDashboardProvider` fetches in parallel:
- All active investments (for portfolio stats)
- Active listings (for the opportunity grid)
- Top farmer listings (for the carousel)
- Wallet balance

Returns a single record with `totalPortfolioValue`, `roiPercent`, `activeAssetCount`, `walletBalance`, `opportunities`, `topFarmerListings`, and `recentInvestments`. The `InvestorDashboardScreen` watches this single provider instead of managing multiple async states.

---

### Farmer / Vendor

**Providers:**
| Provider | Type | Purpose |
|---|---|---|
| `myFarmerProfileProvider` | `FutureProvider` | Farmer's own profile data |
| `farmerProfileProvider(id)` | `FutureProvider.family` | Public farmer profile by ID |
| `myListingsProvider` | `FutureProvider` | All listings for the current farmer |
| `listingFormProvider` | `StateNotifierProvider` | 3-step listing form state machine |

**`ListingFormNotifier`** manages the 3-step form as a `StateNotifier`. Each step updates fields via `copyWith()`. On final submission, `toJson()` serializes to Supabase insert format. `status` defaults to `'draft'` — listings enter the admin review queue before going live.

---

### Wallet

`walletBalanceProvider` fetches `wallet_balance` from `public.users`. `transactionsProvider` fetches the last 50 transactions. Both invalidate on pull-to-refresh. Deposit and withdrawal flows call Stripe PaymentSheet and Stripe payouts respectively, triggered via Supabase Edge Functions.

---

### Notifications

`unreadCountProvider` is a `StreamProvider` backed by `supabase.from('notifications').stream()` filtered to the current user — the notification badge in the app bar updates in real time without polling.

`NotificationNotifier` supports `markAsRead(id)` and `markAllAsRead()`, both of which call `ref.invalidateSelf()` to refresh the list after updating.

---

## Database Schema

Five tables, all with Row Level Security (RLS) enabled. Full SQL in `supabase/migrations/001_initial_schema.sql`.

| Table | Key Columns | RLS |
|---|---|---|
| `users` | id (FK → auth.users), email, role, kyc_status, wallet_balance | Self-only read/write |
| `farmer_profiles` | id (FK → users), farm_name, rating, is_verified | Public read, self write |
| `cattle_assets` | farmer_id, breed, status, total_shares, shares_remaining, price_per_share, exit_dividend_per_share (computed) | Active listings: public read; own listings: farmer full access |
| `investments` | investor_id, cattle_asset_id, shares_owned, total_invested, status | Investor self-only |
| `transactions` | user_id, type, amount, stripe_payment_intent_id | User self-only |
| `notifications` | user_id, type, title, is_read | User self-only |

**DB Trigger:** `on_auth_user_created` — fires after every Supabase Auth signup and auto-inserts a corresponding `public.users` row using the role from signup metadata. This means no extra API call is needed after registration.

**Realtime:** `cattle_assets` and `notifications` tables are added to `supabase_realtime` publication — enabling live share count updates and notification badge counts.

---

## Design System

The app uses a custom **Heritage Modernist** aesthetic — a premium agricultural investment look that bridges the earth and the precision of financial markets.

| Token | Value | Usage |
|---|---|---|
| Primary | Deep Forest Green `#154212` | CTAs, active states |
| Secondary | Arable Soil Brown `#805533` | Accents, badges |
| Tertiary | Harvest Gold `#735C00` | Highlights, ROI indicators |
| Display Font | Manrope | Headlines, hero numbers |
| Body Font | Work Sans | Body text, labels, forms |
| UI Style | Glassmorphism | App bars, cards, overlays |

**Glassmorphism** is implemented with Flutter's `BackdropFilter` + `ImageFilter.blur` with semi-transparent containers — used consistently across the app bar, investment cards, and dashboard hero sections.

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.3.0`
- Dart SDK `>=3.3.0 <4.0.0`
- A [Supabase](https://supabase.com) project

### 1. Clone & Install

```bash
cd cultivated_ledger
flutter pub get
```

### 2. Set Up Supabase

1. Create a project at [supabase.com](https://supabase.com)
2. Go to **SQL Editor** → paste and run `supabase/migrations/001_initial_schema.sql`
3. Go to **Project Settings → API** → copy your Project URL and anon key

### 3. Configure Keys

Open `lib/core/config/app_config.dart` and replace the placeholders:

```dart
static String get supabaseUrl => 'https://YOUR_PROJECT.supabase.co';
static String get supabaseAnonKey => 'YOUR_ANON_KEY';
static String get stripePublishableKey => 'pk_test_YOUR_KEY';
```

### 4. Run

```bash
flutter run
```

---

## Implementation Status

| Feature | UI | Backend Layer | Wired to Supabase |
|---|---|---|---|
| Splash Screen | ✅ | — | — |
| Login | ✅ | ✅ | 🔜 Connect keys |
| Sign Up | ✅ | ✅ | 🔜 Connect keys |
| Auth Guards / Session | ✅ | ✅ | 🔜 Connect keys |
| Investor Dashboard | ✅ | ✅ | 🔜 Connect keys |
| Portfolio Detail | ✅ | ✅ | 🔜 Connect keys |
| Investment Detail | ✅ | ✅ | 🔜 Connect keys |
| Farmer Dashboard | ✅ | ✅ | 🔜 Connect keys |
| Search / Market | ✅ | ✅ | 🔜 Connect keys |
| Wallet | ✅ | ✅ | 🔜 Connect keys |
| Notifications (Realtime) | ✅ | ✅ | 🔜 Connect keys |
| Profile | ✅ | 🔜 | 🔜 |
| Stripe Payment Flow | 🔜 | 🔜 | 🔜 |
| FCM Push Notifications | 🔜 | 🔜 | 🔜 |
| KYC (Persona.com) | 🔜 | 🔜 | 🔜 |
| Farmer Listing Form | 🔜 | ✅ | 🔜 |
| Edge Functions (Stripe) | — | 🔜 | 🔜 |

---

## Roadmap

### Now — Connect & Wire
- [ ] Add Supabase URL + anon key to `app_config.dart`
- [ ] Run `001_initial_schema.sql` in Supabase SQL Editor
- [ ] Wire login/signup screens to `AuthNotifier`
- [ ] Wire investor dashboard to `investorDashboardProvider`
- [ ] Wire search screen to `searchResultsProvider`

### Next — Payments & Notifications
- [ ] Supabase Edge Function: `create-payment-intent`
- [ ] Supabase Edge Function: `handle-payment-webhook`
- [ ] Stripe PaymentSheet integration in investment detail screen
- [ ] Firebase Cloud Messaging setup (iOS + Android)
- [ ] Edge Function: `send-push-notification`

### Later — Compliance & Scale
- [ ] KYC integration (Persona.com webhook)
- [ ] Farmer 3-step listing form UI
- [ ] Supabase Edge Function: `process-exit-dividend`
- [ ] Stripe Connect farmer payout flow
- [ ] Portfolio analytics chart (`fl_chart`)
- [ ] Offline caching with Hive
- [ ] Admin web panel (Flutter Web)
