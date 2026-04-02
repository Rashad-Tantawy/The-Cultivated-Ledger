# The Cultivated Ledger

A fractional livestock investment platform built with Flutter — bridging the agricultural economy with modern retail investing. Investors can purchase fractional ownership in verified cattle assets, while farmers gain access to capital previously available only through institutional lenders.

---

## Summary

The Cultivated Ledger is a mobile-first application targeting two user personas:

- **Investors** — accredited and non-accredited individuals who want exposure to tangible agricultural assets (cattle) with transparent, insured, and biometrically tracked returns.
- **Farmers / Ranchers** — independent operators who list cattle assets on the platform to raise capital without relying on traditional institutional lenders.

The platform acts as a marketplace: farmers list cattle assets with verified data, investors purchase fractional shares, and returns are distributed at market exit.

---

## Features

### Authentication
- Splash screen with brand identity and dual CTAs (Investor / Farmer onboarding)
- Login screen with email/password and social login UI (Google, Apple)
- Sign-up screen with animated role selector (Investor or Farmer)

### Investor
- **Dashboard** — portfolio overview, total value, ROI stats, active opportunities, top-rated farmers
- **Portfolio Detail** — per-asset performance breakdown, yield tracking, health status feed
- **Investment Detail** — individual asset deep-dive, fractional share purchase flow

### Farmer
- **Dashboard** — active listings, capital raised, payout history, asset health management

### Market
- **Search & Discovery** — browse and filter active cattle investment opportunities

### Wallet
- Balance display, deposit/withdrawal UI, transaction history

### Notifications
- In-app notification feed for investment updates, yield events, and platform alerts

### Profile
- User profile, account settings, KYC status

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Riverpod |
| Navigation | GoRouter |
| Fonts | Google Fonts (Manrope, Work Sans) |
| Image Caching | cached_network_image |
| UI Style | Material 3 + custom glassmorphism design system |

---

## Architecture

The project follows a **feature-first clean architecture** structure:

```
lib/
├── core/
│   ├── config/
│   │   └── router.dart          # GoRouter route definitions
│   └── theme/
│       ├── app_colors.dart      # Full Material 3 color system
│       ├── app_text_styles.dart # Typography tokens (Manrope + Work Sans)
│       └── app_theme.dart       # ThemeData configuration
│
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       ├── screens/         # splash, login, sign_up
│   │       └── widgets/         # auth_text_field, glass_app_bar, primary_button
│   ├── investor/
│   │   └── presentation/screens/ # investor_dashboard, portfolio_detail
│   ├── farmer/
│   │   └── presentation/screens/ # farmer_dashboard
│   ├── investment/
│   │   └── presentation/screens/ # investment_detail
│   ├── market/
│   │   └── presentation/screens/ # search_market
│   ├── wallet/
│   │   └── presentation/screens/ # wallet
│   ├── notifications/
│   │   └── presentation/screens/ # notifications
│   └── profile/
│       └── presentation/screens/ # profile
│
└── main.dart
```

Each feature is structured to support full clean architecture layers (presentation → domain → data) as backend integration is added.

---

## Design System

The app uses a custom **Heritage Modernist** aesthetic — a premium agricultural investment look that bridges the earth and the precision of financial markets.

| Token | Value |
|---|---|
| Primary | Deep Forest Green `#154212` |
| Secondary | Arable Soil Brown `#805533` |
| Tertiary | Harvest Gold `#735C00` |
| Display Font | Manrope |
| Body Font | Work Sans |
| UI Style | Glassmorphism (BackdropFilter + blur) |

---

## Implementation Status

| Screen | UI | Logic | API |
|---|---|---|---|
| Splash | ✅ | ✅ | — |
| Login | ✅ | 🔜 | 🔜 |
| Sign Up | ✅ | 🔜 | 🔜 |
| Investor Dashboard | ✅ | 🔜 | 🔜 |
| Portfolio Detail | ✅ | 🔜 | 🔜 |
| Investment Detail | ✅ | 🔜 | 🔜 |
| Farmer Dashboard | ✅ | 🔜 | 🔜 |
| Search / Market | ✅ | 🔜 | 🔜 |
| Wallet | ✅ | 🔜 | 🔜 |
| Notifications | ✅ | 🔜 | 🔜 |
| Profile | ✅ | 🔜 | 🔜 |

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.3.0`
- Dart SDK `>=3.3.0 <4.0.0`

### Install & Run

```bash
cd cultivated_ledger
flutter pub get
flutter run
```

---

## Roadmap

- [ ] Supabase integration (auth, database, storage)
- [ ] Riverpod providers for all features
- [ ] Investment purchase flow
- [ ] Stripe Connect for wallet & payouts
- [ ] Push notifications (FCM)
- [ ] KYC / identity verification
- [ ] IoT health data feed for cattle assets
- [ ] Farmer asset listing flow
