# The Cultivated Ledger — Backend Implementation Plan
**Version 1.0 | April 2026**

---

## Overview

The backend for The Cultivated Ledger is built entirely on **Supabase** (PostgreSQL + Auth + Storage + Realtime + Edge Functions) with **Stripe Connect** for payment processing. No custom server is required for MVP. Edge Functions (Deno/TypeScript) handle all business-critical server-side logic.

---

## Tech Stack

| Concern | Technology |
|---|---|
| Database | Supabase (PostgreSQL) |
| Authentication | Supabase Auth (email/password + Google/Apple OAuth) |
| File Storage | Supabase Storage (cattle images, CVI PDFs) |
| Realtime | Supabase Realtime (live `shares_remaining` updates) |
| Server-side Logic | Supabase Edge Functions (Deno/TypeScript) |
| Payments | Stripe Connect (Custom accounts) |
| Push Notifications | Firebase Cloud Messaging (FCM) |
| KYC / Identity | Persona.com SDK |

---

## Phase 1 — Foundation (Week 1–2)

### 1.1 Supabase Project Setup

- Create Supabase project (production + staging environments)
- Configure custom SMTP for auth emails (welcome, password reset, KYC status)
- Enable Google and Apple OAuth providers
- Set JWT expiry to 7 days, refresh token rotation enabled
- Configure Storage buckets:
  - `cattle-images` — public read, authenticated write
  - `cvi-documents` — private, farmer-only read/write
  - `profile-images` — public read, authenticated write

---

### 1.2 Database Schema

#### `users` (extends Supabase auth.users)
```sql
create table public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  role text not null check (role in ('investor', 'farmer', 'admin')),
  first_name text,
  last_name text,
  avatar_url text,
  kyc_status text not null default 'not_started'
    check (kyc_status in ('not_started', 'pending', 'verified', 'rejected')),
  kyc_inquiry_id text,               -- Persona.com inquiry ID
  wallet_balance numeric(12,2) not null default 0.00,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.users enable row level security;

-- User can only read/write their own row
create policy "users: self access" on public.users
  for all using (auth.uid() = id);
```

#### `farmer_profiles`
```sql
create table public.farmer_profiles (
  id uuid primary key references public.users(id) on delete cascade,
  farm_name text not null,
  bio text,
  location text not null,
  acreage numeric(10,2),
  years_experience int,
  is_verified boolean not null default false,
  average_roi numeric(5,2) default 0,    -- recomputed on investment exit
  total_deals_completed int default 0,
  rating numeric(3,2) default 0,
  rating_count int default 0,
  profile_image_url text,
  hero_image_url text,
  certifications text[] default '{}',
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.farmer_profiles enable row level security;

-- Public read, self write
create policy "farmer_profiles: public read" on public.farmer_profiles
  for select using (true);

create policy "farmer_profiles: self write" on public.farmer_profiles
  for all using (auth.uid() = id);
```

#### `cattle_assets` (Listings)
```sql
create table public.cattle_assets (
  id uuid primary key default gen_random_uuid(),
  farmer_id uuid not null references public.farmer_profiles(id),
  batch_name text not null,
  breed text not null check (breed in (
    'angus','hereford','brahman','charolais','simmental',
    'limousin','wagyu','longhorn','highland','other'
  )),
  age_months int not null,
  weight_lbs numeric(8,2) not null,
  health_score int check (health_score between 0 and 100),
  location text not null,
  status text not null default 'draft' check (status in (
    'draft','under_review','active','fully_funded',
    'market_ready','completed','cancelled'
  )),
  total_shares int not null,
  shares_remaining int not null,
  price_per_share numeric(10,2) not null,
  estimated_roi_percent numeric(5,2) not null,
  maturity_months int not null,
  expected_market_date date,
  exit_dividend_per_share numeric(10,2) generated always as
    (price_per_share * estimated_roi_percent / 100) stored,
  primary_image_url text,
  gallery_image_urls text[] default '{}',
  cvi_document_url text,
  health_notes text,
  has_insurance boolean not null default false,
  has_iot_tracking boolean not null default false,
  is_verified boolean not null default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.cattle_assets enable row level security;

-- Active listings visible to all authenticated users
create policy "cattle_assets: public read active" on public.cattle_assets
  for select using (status = 'active' or status = 'fully_funded');

-- Farmers can read all their own listings (any status)
create policy "cattle_assets: farmer own" on public.cattle_assets
  for all using (auth.uid() = farmer_id);
```

#### `investments`
```sql
create table public.investments (
  id uuid primary key default gen_random_uuid(),
  investor_id uuid not null references public.users(id),
  cattle_asset_id uuid not null references public.cattle_assets(id),
  shares_owned int not null,
  price_per_share_at_purchase numeric(10,2) not null,
  total_invested numeric(12,2) not null,
  status text not null default 'active'
    check (status in ('active', 'market_ready', 'exited')),
  exit_dividend_paid numeric(12,2),
  realized_roi_percent numeric(5,2),
  purchased_at timestamptz default now(),
  exited_at timestamptz
);

alter table public.investments enable row level security;

-- Investors see only their own investments
create policy "investments: investor self" on public.investments
  for all using (auth.uid() = investor_id);

-- Farmers can see investments in their listings (count/aggregate only via function)
```

#### `transactions`
```sql
create table public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id),
  type text not null check (type in (
    'investment','dividend_payout','wallet_deposit',
    'wallet_withdrawal','platform_fee'
  )),
  amount numeric(12,2) not null,
  currency_code text not null default 'USD',
  status text not null default 'pending'
    check (status in ('pending', 'completed', 'failed', 'refunded')),
  stripe_payment_intent_id text,
  related_investment_id uuid references public.investments(id),
  related_cattle_asset_id uuid references public.cattle_assets(id),
  description text not null,
  created_at timestamptz default now()
);

alter table public.transactions enable row level security;

create policy "transactions: user self" on public.transactions
  for all using (auth.uid() = user_id);
```

#### `notifications`
```sql
create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users(id),
  type text not null check (type in (
    'purchase_confirmed','listing_approved','listing_fully_funded',
    'health_update','market_ready','dividend_paid',
    'kyc_approved','kyc_rejected','general'
  )),
  title text not null,
  body text not null,
  metadata jsonb default '{}',
  is_read boolean not null default false,
  created_at timestamptz default now()
);

alter table public.notifications enable row level security;

create policy "notifications: user self" on public.notifications
  for all using (auth.uid() = user_id);
```

---

## Phase 2 — Authentication & KYC (Week 2–3)

### 2.1 Auth Flow

**Sign Up**
1. Client calls `supabase.auth.signUp({ email, password, data: { role } })`
2. Supabase triggers `auth.users` insert → DB trigger creates matching `public.users` row
3. User receives verification email
4. After email confirmation → redirect to KYC screen

**Sign In**
1. Client calls `supabase.auth.signInWithPassword({ email, password })`
2. Returns JWT + refresh token stored in secure storage (`flutter_secure_storage`)
3. GoRouter auth guard checks JWT validity on every protected route

**DB Trigger — auto-create user profile on signup:**
```sql
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer as $$
begin
  insert into public.users (id, email, role)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'role', 'investor')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
```

### 2.2 Route Guards (GoRouter + Riverpod)

```dart
// In router.dart
redirect: (context, state) {
  final authState = ref.read(authStateProvider);
  final isLoggedIn = authState.session != null;
  final isKycVerified = authState.user?.kycStatus == 'verified';

  if (!isLoggedIn) return '/login';
  if (!isKycVerified && !state.matchedLocation.startsWith('/kyc')) return '/kyc-verify';
  return null;
}
```

### 2.3 KYC Integration (Persona.com)

1. Investor taps "Verify Identity" → app opens Persona SDK
2. User completes ID scan + selfie
3. Persona webhook → Supabase Edge Function `handle-kyc-webhook`
4. Edge Function updates `users.kyc_status` and sends in-app + push notification
5. GoRouter re-evaluates guard → user proceeds to dashboard

---

## Phase 3 — Core API Layer in Flutter (Week 3–5)

### 3.1 Supabase Client Setup

```dart
// core/config/supabase_config.dart
await Supabase.initialize(
  url: AppConfig.supabaseUrl,
  anonKey: AppConfig.supabaseAnonKey,
);
```

### 3.2 Repository Pattern per Feature

Each feature follows: `RemoteDatasource → RepositoryImpl → Repository (abstract) → UseCase → Provider`

**Example: Authentication**

```
features/auth/
├── data/
│   ├── datasources/auth_remote_datasource.dart   # Supabase calls
│   ├── models/user_model.dart                     # JSON ↔ entity mapping
│   └── repositories/auth_repository_impl.dart
├── domain/
│   ├── entities/user.dart
│   ├── repositories/auth_repository.dart          # abstract interface
│   └── usecases/
│       ├── sign_in_usecase.dart
│       ├── sign_up_usecase.dart
│       └── get_current_user_usecase.dart
└── presentation/
    └── providers/auth_provider.dart               # Riverpod AsyncNotifier
```

### 3.3 Riverpod Provider Strategy

| Provider Type | Used For |
|---|---|
| `AsyncNotifierProvider` | Investment listings, portfolio, notifications |
| `StreamProvider` | Auth state, real-time `shares_remaining` |
| `StateNotifierProvider` | Multi-step vendor listing form |
| `FutureProvider` | One-time fetches (farmer profile, transaction history) |

---

## Phase 4 — Feature Implementation Order (Week 4–10)

### Priority 1 — Auth + Dashboard (Week 4–5)
- [ ] `AuthRepository` + `AuthProvider` (sign in, sign up, sign out, session restore)
- [ ] `UserRepository` (fetch current user profile, update profile)
- [ ] `InvestorDashboardProvider` — fetch portfolio summary, active opportunities, top farmers
- [ ] Wire `InvestorDashboardScreen` to real data (replace hardcoded values)

### Priority 2 — Listings + Investment Flow (Week 5–7)
- [ ] `CattleAssetRepository` (fetch active listings, listing detail, search + filter)
- [ ] `SearchProvider` — text search + filter chips (breed, ROI range, duration)
- [ ] `InvestmentRepository` (purchase shares, fetch portfolio, investment detail)
- [ ] Share purchase flow: `ShareSelectorScreen → OrderSummaryScreen → PaymentConfirmationScreen`
- [ ] Stripe PaymentSheet integration for share purchase

### Priority 3 — Portfolio + Wallet (Week 7–8)
- [ ] `PortfolioProvider` — active investments list, per-investment stats
- [ ] `PortfolioDetailScreen` wired to real investment data
- [ ] `WalletRepository` (balance, add funds, withdrawal request)
- [ ] `TransactionRepository` (history list)
- [ ] Wire `WalletScreen` and transaction history

### Priority 4 — Farmer Flow (Week 8–9)
- [ ] `FarmerProfileRepository` (public farmer profile, ratings)
- [ ] `VendorRepository` (create/edit/manage listings)
- [ ] 3-step listing form with draft save (`StateNotifierProvider`)
- [ ] `FarmerDashboardProvider` — capital raised, investor count, listing statuses
- [ ] Wire `FarmerDashboardScreen` to real data

### Priority 5 — Notifications + Profile (Week 9–10)
- [ ] `NotificationRepository` (fetch, mark as read)
- [ ] Supabase Realtime subscription for live notification badge count
- [ ] Firebase Cloud Messaging setup (iOS + Android)
- [ ] `ProfileRepository` (update name, avatar, password)
- [ ] KYC status display on profile screen

---

## Phase 5 — Stripe Payments (Week 6–7)

### 5.1 Stripe Setup
- Create Stripe Connect platform account
- Configure `flutter_stripe` with publishable key
- Create Supabase Edge Function `create-payment-intent`

### 5.2 Investment Purchase Flow
```
1. User selects shares → app calls Edge Function `create-payment-intent`
2. Edge Function:
   a. Validates shares_remaining >= requested quantity
   b. Creates Stripe PaymentIntent (amount = shares × price_per_share)
   c. Returns client_secret to Flutter
3. Flutter presents PaymentSheet (card / Apple Pay / Google Pay)
4. On success → Stripe webhook fires `payment_intent.succeeded`
5. Edge Function `handle-payment-webhook`:
   a. Creates investment row in DB
   b. Decrements cattle_assets.shares_remaining (atomic update)
   c. Creates transaction record
   d. If shares_remaining = 0 → updates listing status to 'fully_funded'
   e. Sends push notification to investor
   f. If fully_funded → notifies farmer
```

### 5.3 Wallet Add Funds
- Same PaymentSheet flow, `type = 'wallet_deposit'`
- Updates `users.wallet_balance` on webhook success

### 5.4 Farmer Payout (Exit Dividend)
```
Admin confirms market_ready → Edge Function `process-exit-dividend`:
  1. Fetches all investments for the cattle_asset
  2. Calculates each investor's exit_dividend (shares × exit_dividend_per_share)
  3. Deducts platform carry fee (5% of profit)
  4. Creates Stripe payouts to farmer's Connect account
  5. Credits investor wallets (wallet_balance += dividend)
  6. Updates investment.status = 'exited'
  7. Sends dividend_paid push notifications to all investors
```

---

## Phase 6 — Realtime & Push Notifications (Week 9–10)

### 6.1 Supabase Realtime
```dart
// Live shares_remaining on listing detail screen
supabase.from('cattle_assets')
  .stream(primaryKey: ['id'])
  .eq('id', listingId)
  .listen((data) => ref.notifyListeners());
```

### 6.2 FCM Push Notifications
- Triggered from Supabase Edge Functions on key events
- Handled in Flutter via `firebase_messaging` (foreground + background)
- Local notification shown via `flutter_local_notifications`
- Tap on notification deep-links to relevant screen via GoRouter

| Event | Notification |
|---|---|
| Purchase confirmed | "Your investment in [Batch Name] is confirmed." |
| Listing approved | "Your listing [Batch Name] is now live!" |
| Listing fully funded | "Your listing [Batch Name] is fully funded!" |
| Dividend paid | "You received $[amount] from [Batch Name] exit." |
| KYC approved | "Identity verified — you're ready to invest." |
| Health update | "[Batch Name] health update: Score 94/100" |

---

## Phase 7 — Security & RLS Audit (Week 10)

- Audit all RLS policies — every table must have a policy for every operation
- Ensure no table is readable without authentication except public farmer profiles and active listings
- Test with a second Supabase user to verify data isolation
- Enable Supabase Vault for storing Stripe secret keys used in Edge Functions
- Add rate limiting on Edge Functions (Deno `Deno.serve` request limits)
- Validate all user inputs in Edge Functions (type coercion attacks)
- HTTPS enforced for all Supabase connections (default)

---

## Edge Functions Summary

| Function | Trigger | Purpose |
|---|---|---|
| `create-payment-intent` | Flutter HTTP POST | Create Stripe PaymentIntent for share purchase or wallet deposit |
| `handle-payment-webhook` | Stripe webhook | Update DB on payment success (investment, wallet, shares count) |
| `handle-kyc-webhook` | Persona webhook | Update user KYC status, send notification |
| `process-exit-dividend` | Admin action | Calculate + disburse exit dividends to investors |
| `send-push-notification` | Internal (called by other functions) | FCM push via Firebase Admin SDK |
| `approve-listing` | Admin action | Move listing from under_review → active, notify farmer |

---

## Environment Variables (Supabase Vault / Edge Function Secrets)

```
SUPABASE_URL
SUPABASE_SERVICE_ROLE_KEY
STRIPE_SECRET_KEY
STRIPE_WEBHOOK_SECRET
PERSONA_API_KEY
FIREBASE_SERVICE_ACCOUNT_JSON
```

---

## Implementation Checklist

### Database
- [ ] Create all tables with RLS policies
- [ ] Add DB triggers (new user profile auto-create)
- [ ] Add indexes on foreign keys and status columns
- [ ] Seed dev database with test users, farmers, listings

### Auth
- [ ] Email/password signup + login
- [ ] Google OAuth
- [ ] Apple OAuth (iOS)
- [ ] Session persistence with secure storage
- [ ] GoRouter auth guards

### Payments
- [ ] Stripe Connect platform account
- [ ] `create-payment-intent` Edge Function
- [ ] PaymentSheet integration in Flutter
- [ ] Stripe webhook handler
- [ ] Farmer payout flow (Stripe Connect transfers)

### Features
- [ ] Investor dashboard live data
- [ ] Listings feed + search + filter
- [ ] Investment purchase end-to-end
- [ ] Portfolio tracking
- [ ] Wallet (balance, deposit, withdrawal)
- [ ] Farmer dashboard
- [ ] Vendor listing form (3-step, draft save)
- [ ] Notification center
- [ ] Profile + settings

### Infrastructure
- [ ] KYC (Persona.com webhook)
- [ ] FCM push notifications
- [ ] Supabase Realtime (shares_remaining)
- [ ] RLS security audit
- [ ] Staging vs. production environments
