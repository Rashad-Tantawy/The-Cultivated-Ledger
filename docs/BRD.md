# The Cultivated Ledger — Business Requirements Document
**Version 1.0 | April 2026**

---

## 1. Executive Summary / App Vision

**The Cultivated Ledger** is a fractional livestock investment platform that bridges the agricultural economy with modern retail investing. It allows accredited and non-accredited investors to purchase fractional ownership ("shares") in verified cattle assets — a class of tangible, insured, and biometrically tracked real-world assets — while giving independent farmers and ranchers access to capital that was previously available only through institutional lenders.

**Platform thesis:** Livestock is one of the oldest stores of wealth on earth, yet retail investors have had no clean, transparent, or liquid mechanism to participate in this market. The Cultivated Ledger changes that by applying the mechanics of equity crowdfunding to cattle ranching, complete with prospectuses, exit dividends, and verified farmer profiles.

**Vision Statement:** "The world's most trusted marketplace for agricultural asset investment — where every share is a seed of prosperity, for both the investor and the land."

**Target Geography:** United States (MVP / Phase 1), with expansion to UK, Australia, and Sub-Saharan Africa in Phase 2.

**Business Model:** Two-sided marketplace with SaaS-style premium tiers for Farmers and a transaction-fee-on-carry model for Investors.

---

## 2. User Personas

### Persona 1: The Curious Diversifier (Investor)

| Field | Detail |
|---|---|
| Name | Marcus, 34 — Atlanta, GA |
| Occupation | Software engineer, $140K/yr HHI |
| Behavior | Holds brokerage + crypto wallet. Frustrated by crypto volatility and low bond yields. Reads alternative asset news. |
| Goal | Find a tangible, uncorrelated asset generating 10–18% ROI over 12–24 months without farming expertise. |
| Pain Points | Can't evaluate cattle investments. Doesn't trust unverified farmers. Needs insurance and transparent data. |
| Primary Activities | Browse Opportunities, review listing details, purchase shares, track portfolio, receive dividends. |

---

### Persona 2: The Generational Rancher (Farmer / Vendor)

| Field | Detail |
|---|---|
| Name | Silas, 52 — Montana |
| Occupation | Third-generation cattle rancher, 800 acres, 200+ head |
| Behavior | Expert in animal husbandry. Limited digital fluency. Relies on seasonal bank loans at 7–9% interest. |
| Goal | Access lower-cost capital to expand herd and upgrade feeding infrastructure without giving up land equity. |
| Pain Points | Bank loans are expensive and slow. Doesn't understand crowdfunding. Needs a simple onboarding process. |
| Primary Activities | Register livestock assets, upload vet certifications, set share price, track investor interest, receive payouts. |

---

### Persona 3: The ESG Portfolio Manager (Institutional Investor — Phase 2)

| Field | Detail |
|---|---|
| Name | Priya, 41 — New York |
| Occupation | Director of Alternative Investments at a mid-size family office |
| Behavior | Manages a $50M portfolio. Seeking uncorrelated real assets with ESG credentials. Reports quarterly to stakeholders. |
| Goal | Allocate $250,000+ into verified regenerative agriculture assets with audited performance history. |
| Primary Activities | Advanced search, bulk investment checkout, portfolio analytics, exportable reports, prospectus downloads. |

---

### Persona 4: The Platform Administrator (Internal Ops)

| Field | Detail |
|---|---|
| Name | Internal ops team at The Cultivated Ledger HQ |
| Goal | Review/approve listings, verify credentials, manage KYC/AML compliance, moderate disputes, monitor platform metrics. |
| Primary Activities | Listing review queue, user KYC status, escrow disbursement approval, platform P&L dashboard. (Web Admin Panel) |

---

## 3. Core User Journeys

### Journey 1: Investor — Discover → Invest → Track

**Step 1 — Onboarding & Identity Verification**
New investor downloads app → email registration → KYC identity check (government ID + selfie) → links bank account or card → lands on investor dashboard.

**Step 2 — Discovery**
Views "Active Opportunities" grid → sees cattle breed, price/share, estimated ROI, shares remaining → filters by ROI/duration/breed → taps a listing card.

**Step 3 — Due Diligence**
Reviews Cow Listing Detail: hero image, biological stats (breed, age, weight, health score), ROI bento (projected annual return, maturity timeline, exit dividend/share), verified farmer card with rating, risk & security section, downloadable prospectus PDF.

**Step 4 — Investment Execution**
Taps "Buy Shares Now" → selects quantity → reviews order summary (total cost, estimated exit value, platform fee) → confirms payment → funds held in platform escrow → receives confirmation notification.

**Step 5 — Portfolio Tracking**
Dashboard shows updated portfolio value, active asset count, ROI, monthly yield, wallet balance. Investment cards show growth status, health update feed from IoT data, and countdown to market date.

**Step 6 — Exit & Dividend**
Platform notifies investor of market readiness → cattle sold by farmer → pro-rata exit dividend calculated → funds disbursed to wallet → investor withdraws to bank or reinvests.

---

### Journey 2: Farmer — List → Manage → Receive Payout

**Step 1 — Farmer Onboarding**
Registers with farmer/vendor role → enhanced KYC + agricultural license verification → submits farm profile → admin reviews → Verified Farmer badge issued.

**Step 2 — Asset Listing**
Navigates to Vendor Portal → completes 3-step listing form:
- **Step 1 (Visual Assets):** Uploads primary + up to 3 secondary images.
- **Step 2 (Biological Profile):** Selects breed, enters age, documents health/certifications, uploads CVI document (Certified Veterinary Inspection).
- **Step 3 (Financial Structure):** Sets total shares, price/share, expected ROI%. Platform auto-calculates total asset valuation and estimated harvest term.

Submits for review → listing enters admin queue.

**Step 3 — Listing Goes Live**
Admin approves → listing appears on Active Opportunities grid → farmer notified → dashboard shows shares progress bar.

**Step 4 — Asset Management**
Farmer portal shows per-listing investor count, capital raised, IoT health feeds (if collar registered), messaging thread with platform ops.

**Step 5 — Payout**
Cattle reaches market readiness → farmer logs "Market Ready" event → platform ops confirms → farmer invoices platform → escrow released → farmer receives net capital (total investment minus platform carry fee) → investors receive exit dividends.

---

## 4. Feature List

### Phase 1 — MVP (Months 1–6)

#### Authentication & Onboarding
- Email + password registration with role selection (Investor vs. Farmer)
- KYC identity verification (Persona.com or Jumio)
- Bank account / debit card linking (Stripe)
- 3-screen onboarding tutorial carousel

#### Investor Features
- Investor Dashboard: portfolio value hero, ROI metric, wallet balance, monthly yield, active assets count
- Active Opportunities grid: cattle cards with image, share price, ROI, shares remaining
- Filter and sort: by ROI, duration, breed category, new arrivals
- Cow Listing Detail: full biological profile, ROI bento, maturity timeline, farmer card, risk/security section
- Share purchase flow: quantity selector, order summary, payment confirmation
- Portfolio tracking screen: list of active investments with per-investment performance
- Notifications: purchase confirmation, health updates, market readiness alerts, exit dividend received
- Transaction history
- Wallet: balance view, add funds, withdrawal request

#### Farmer/Vendor Features
- Farmer public profile: bio, verified badge, active listings, cycle history
- Vendor listing form: 3-step flow (visual docs, biological profile, financial structure)
- Draft save and submit-for-review
- Farmer dashboard: listings overview, capital raised per listing, investor count
- Listing status tracking: `draft → under_review → active → fully_funded → market_ready → completed`

#### Core Platform
- Top Rated Farmers carousel (horizontal scroll)
- Search screen with text search + filter chips
- Glassmorphism bottom navigation (Home, Search, Investments, Profile)
- Push notifications (Firebase Cloud Messaging)
- In-app notification center

---

### Phase 2 — Months 7–12

- Secondary marketplace: investor-to-investor share transfers
- Waitlist / "Notify Me" for fully funded or upcoming listings
- IoT health data integration (wearable cattle collar data feed per listing)
- PDF prospectus generation and download per listing
- Farmer messaging / Q&A thread per listing
- Institutional investor tier with bulk purchase flow
- Portfolio analytics: performance chart over time (line chart)
- Advanced filters: location map view, ESG certification filter
- Referral program
- Admin web panel v1: listing review, KYC queue, escrow management

---

### Phase 3 — Months 13–24

- Dark mode
- Multi-currency support (GBP, AUD for UK & Australia expansion)
- Secondary market liquidity mechanism ("Exit Early" at discount)
- Automated reinvestment ("Auto-Harvest" — reinvest exit dividends into similar assets)
- AI-powered ROI prediction model (breed, region, historical data)
- Insurance policy management within the app
- Loyalty rewards for repeat investors
- Web app (Flutter Web)
- API for third-party agricultural data providers (e.g., USDA NASS)
- White-label licensing for international agri-finance operators

---

## 5. Monetization Model

### 5.1 Platform Carry Fee (Primary Revenue)
On exit, the platform charges **5% of total investment returns** (not principal), deducted at exit dividend disbursement.

> Example: Investor puts in $10,000. Exit value = $11,200. Profit = $1,200. Platform fee = $60. Investor receives $11,140 net.

### 5.2 Farmer Origination Fee
Farmers pay **1.5% of total capital raised** when a listing becomes fully funded.

> Example: Listing raises $50,000 total. Farmer origination fee = $750.

### 5.3 Premium Farmer Tier — "Cultivated Pro" ($49/month)
Unlocks:
- Priority placement in the Active Opportunities grid (sponsored listing)
- "Featured" badge on listings
- Advanced analytics on investor behavior
- Prospectus PDF auto-generation
- Dedicated support channel

### 5.4 Investor Premium Tier — "Harvest Pass" ($99/year)
Unlocks:
- 24-hour early access to new listings before public
- Portfolio export to CSV/PDF
- Priority customer support
- Institutional-grade data (breed performance benchmarks, regional ROI averages)

### 5.5 Payment Processing Margin
Platform earns ~0.5–1% net margin on payment processing by negotiating volume rates with Stripe below standard 2.9% + $0.30.

### 5.6 Future: Data Licensing (Phase 3)
Anonymized, aggregated livestock investment data licensed to academic research institutions and commodity traders.

**Projected Blended Revenue Per Transaction (MVP):** ~$95–$180 per completed investment cycle depending on deal size.

---

## 6. Success Metrics / KPIs

### Growth Metrics

| KPI | Month 6 Target | Month 12 Target |
|---|---|---|
| Monthly Active Investors (MAI) | 500 | 5,000 |
| Monthly Active Farmers (MAF) | 50 verified | 200 |
| Total Listings Published / month | 20 | 100 |
| Total Capital Deployed (GMV) | $500,000 | $5,000,000 |

### Engagement Metrics

| KPI | Target |
|---|---|
| Investor Dashboard Weekly Active Rate | 30% of users check app weekly |
| Avg. Time to First Investment (from signup) | Under 7 days |
| Listing Conversion Rate (views → investments) | 8–12% |
| Share Sellout Rate | 85% of listings reach 100% funded within 30 days |

### Financial Health Metrics

| KPI | Target |
|---|---|
| Take Rate (platform revenue / GMV) | 3.5–5% |
| Investor CAC | Under $35 |
| Farmer CAC | Under $120 |
| Investor LTV (18 months) | $850 (~2.3 investment cycles) |
| LTV:CAC Ratio | 8:1 minimum |

### Quality & Trust Metrics

| KPI | Target |
|---|---|
| Farmer Verification Rate | 100% — every listing requires Verified badge before going live |
| Investment Dispute Rate | Below 0.5% of total transactions |
| App Store Rating | 4.6+ on iOS and Android |
| Exit Dividend On-Time Rate | 95% disbursed within 5 business days of market-ready confirmation |

---

## 7. Assumptions & Constraints

### Legal & Regulatory
- Legal counsel will determine whether cattle share offerings require SEC Regulation Crowdfunding (Reg CF) registration or qualify under Reg D/506(b) exemptions.
- KYC/AML compliance handled via licensed third-party provider (Persona.com or Jumio) before any user can transact.
- Platform operates escrow via a licensed money services business (MSB) or regulated custodian partner.
- Agricultural asset insurance (covering disease, mortality, theft) is required by contract for every farmer before listing approval.

### Technical
- MVP targets iOS and Android only. Web app deferred to Phase 3.
- IoT cattle collar data is a Phase 2 feature and depends on farmer hardware adoption (RFID/GPS collar devices from vendors such as Moocall or CattleConnect).
- The platform will not hold user funds directly in MVP — all transactions routed through Stripe Connect or Dwolla, with escrow logic handled at the payment processor level.

### Business
- **Cold-start problem:** Farmer supply must exist before investor demand can be monetized. Strategy: manually onboard 20 pre-vetted farmers before public launch, seed marketplace with 40 curated listings ready to go live on day one.
- **Connectivity:** Farmers in remote areas may have limited broadband — the app must function gracefully on 3G and cache key screens offline.
- **Budget (estimated):** $180,000–$250,000 for a 6-person cross-functional team over 6 months (2 Flutter devs, 1 backend dev, 1 designer, 1 product manager, 1 QA/DevOps).
