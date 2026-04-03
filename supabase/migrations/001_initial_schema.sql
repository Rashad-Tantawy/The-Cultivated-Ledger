-- ============================================================
-- The Cultivated Ledger — Initial Database Schema
-- Run this in the Supabase SQL Editor
-- ============================================================

-- ── Users ────────────────────────────────────────────────────────────────────
create table public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null unique,
  role text not null default 'investor' check (role in ('investor', 'farmer', 'admin')),
  first_name text,
  last_name text,
  avatar_url text,
  kyc_status text not null default 'not_started'
    check (kyc_status in ('not_started', 'pending', 'verified', 'rejected')),
  kyc_inquiry_id text,
  wallet_balance numeric(12,2) not null default 0.00,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.users enable row level security;
create policy "users: self access" on public.users
  for all using (auth.uid() = id);

-- Auto-create user profile on signup
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

-- ── Farmer Profiles ──────────────────────────────────────────────────────────
create table public.farmer_profiles (
  id uuid primary key references public.users(id) on delete cascade,
  farm_name text not null,
  bio text,
  location text not null default '',
  acreage numeric(10,2),
  years_experience int,
  is_verified boolean not null default false,
  average_roi numeric(5,2) default 0,
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
create policy "farmer_profiles: public read" on public.farmer_profiles
  for select using (true);
create policy "farmer_profiles: self write" on public.farmer_profiles
  for all using (auth.uid() = id);

-- ── Cattle Assets (Listings) ─────────────────────────────────────────────────
create table public.cattle_assets (
  id uuid primary key default gen_random_uuid(),
  farmer_id uuid not null references public.farmer_profiles(id),
  batch_name text not null,
  breed text not null default 'other' check (breed in (
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
    (round(price_per_share * estimated_roi_percent / 100, 2)) stored,
  primary_image_url text,
  gallery_image_urls text[] default '{}',
  cvi_document_url text,
  health_notes text default '',
  has_insurance boolean not null default false,
  has_iot_tracking boolean not null default false,
  is_verified boolean not null default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.cattle_assets enable row level security;
create policy "cattle_assets: public read active" on public.cattle_assets
  for select using (status in ('active', 'fully_funded'));
create policy "cattle_assets: farmer own" on public.cattle_assets
  for all using (auth.uid() = farmer_id);

-- Index for performance
create index cattle_assets_status_idx on public.cattle_assets(status);
create index cattle_assets_farmer_id_idx on public.cattle_assets(farmer_id);

-- ── Investments ──────────────────────────────────────────────────────────────
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
create policy "investments: investor self" on public.investments
  for all using (auth.uid() = investor_id);

create index investments_investor_id_idx on public.investments(investor_id);
create index investments_cattle_asset_id_idx on public.investments(cattle_asset_id);

-- ── Transactions ─────────────────────────────────────────────────────────────
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
  description text not null default '',
  created_at timestamptz default now()
);

alter table public.transactions enable row level security;
create policy "transactions: user self" on public.transactions
  for all using (auth.uid() = user_id);

create index transactions_user_id_idx on public.transactions(user_id);

-- ── Notifications ────────────────────────────────────────────────────────────
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

create index notifications_user_id_idx on public.notifications(user_id);
create index notifications_is_read_idx on public.notifications(user_id, is_read);

-- ── Enable Realtime on cattle_assets ─────────────────────────────────────────
alter publication supabase_realtime add table public.cattle_assets;
alter publication supabase_realtime add table public.notifications;
