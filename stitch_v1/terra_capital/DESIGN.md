# Design System Specification: The Cultivated Ledger

## 1. Overview & Creative North Star
**Creative North Star: "The Heritage Modernist"**

This design system rejects the "SaaS-template" aesthetic in favor of a high-end, editorial experience that feels as much like a premium financial broadsheet as it does a tactile agricultural journal. We are moving away from rigid, boxed-in layouts and toward a "fluid-grid" philosophy characterized by intentional asymmetry, generous white space (breathing room), and sophisticated tonal layering.

The goal is to bridge the gap between the dirt of the earth and the precision of the stock market. We achieve this through "Organic Brutalism"—using heavy, authoritative typography paired with soft, nested surfaces and a color palette that feels harvested, not manufactured.

---

## 2. Colors
Our palette is rooted in the "Deep Forest" and "Arable Soil" tones, balanced by a "Pristine Canvas" background.

*   **Primary (`#154212`):** Our signature deep green. Use this for moments of highest authority and primary actions. It represents growth and stability.
*   **Secondary (`#805533`):** The warm brown of tilled earth. Used for secondary actions and to ground the UI, providing a professional warmth that standard greys cannot.
*   **Tertiary (`#735c00`):** A sophisticated gold/ochre. Use this sparingly for "Verified" states and "Premium" accents to evoke a sense of harvest and value.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning. Boundaries between sections must be defined solely through:
1.  **Background Color Shifts:** A `surface_container_low` section sitting directly on a `surface` background.
2.  **Vertical Space:** Using the 16 (4rem) or 20 (5rem) spacing tokens to create logical breaks.

### Surface Hierarchy & Nesting
Treat the UI as physical layers of heavy-weight paper.
*   **Base:** `surface` (#faf9f8).
*   **Sectioning:** `surface_container_low` (#f4f3f2).
*   **Interactive/Cards:** `surface_container_lowest` (#ffffff) to create a natural "pop" against the lower tiers.

### The "Glass & Gradient" Rule
To add a signature "soul" to the platform, headers or floating navigation elements should utilize a **Glassmorphism effect**: `surface_container_lowest` at 85% opacity with a 12px backdrop-blur. Main CTAs should use a subtle linear gradient from `primary` (#154212) to `primary_container` (#2d5a27) at a 135-degree angle to provide tactile depth.

---

## 3. Typography
We use a high-contrast pairing to establish "The Cultivated Ledger" aesthetic.

*   **Display & Headlines (Manrope):** A modern, geometric sans-serif that feels engineered and precise.
    *   *Usage:* Use `display-lg` (3.5rem) for hero statements with a `-0.02em` letter-spacing.
    *   *Identity:* This font conveys the "Modern Investment" side of the platform.
*   **Body & Labels (Work Sans):** A friendly, highly-legible sans-serif with a slightly wider stance.
    *   *Usage:* Use `body-md` (0.875rem) for general information and `label-md` (0.75rem) for technical metadata.
    *   *Identity:* Work Sans provides the "Human/Trustworthy" element, ensuring complex agricultural data remains accessible.

---

## 4. Elevation & Depth
Depth is a function of light and stacking, not artificial lines.

*   **The Layering Principle:** Place a card using `surface_container_lowest` on a background of `surface_container_low`. The 1-tone difference creates an edge that is felt rather than seen.
*   **Ambient Shadows:** For floating elements (like a farmer's 'Verified' badge or a floating CTA), use a custom shadow: `0px 12px 32px rgba(26, 28, 28, 0.06)`. This uses the `on_surface` color as the shadow base to mimic natural, ambient light.
*   **The "Ghost Border" Fallback:** If accessibility requires a border, use the `outline_variant` token at 15% opacity. Never use a 100% opaque border.
*   **Tactile Interaction:** On hover, a card should not move "up" via shadow. Instead, it should transition its background color from `surface_container_lowest` to `surface_bright`.

---

## 5. Components

### Cards & Listings
*   **Style:** No borders. `xl` (0.75rem) corner radius.
*   **Structure:** Use an asymmetrical layout. Place the agricultural image on the left at 40% width, with the investment data on the right. 
*   **Separation:** Use `10` (2.5rem) padding internally. Never use divider lines; use the spacing scale `3` (0.75rem) to separate text groups.

### 'Verified' Badges
*   **Style:** `tertiary_container` (#cca730) background with `on_tertiary_container` (#4f3d00) text.
*   **Shape:** `full` (9999px) roundedness.
*   **Detail:** Include a 16px icon of a seal. The badge should feel like a high-end wax stamp.

### Buttons
*   **Primary:** `primary` background, `on_primary` text. `md` (0.375rem) roundedness.
*   **Secondary:** `surface_container_high` background. No border.
*   **Tertiary:** No background. `primary` text weight 600.

### Input Fields
*   **Style:** `surface_container_lowest` background. 
*   **Border:** Use the "Ghost Border" rule (outline-variant @ 20%). 
*   **Active State:** Border transitions to `primary` (#154212) at 100% opacity, 2px thickness.

### Chips (Filters)
*   **Style:** `surface_container_high` background, `on_surface_variant` text.
*   **Active:** `primary_fixed` background with `on_primary_fixed` text.

---

## 6. Do's and Don'ts

### Do
*   **Do** use asymmetrical spacing. Allow more white space on the right side of a container than the left to create an editorial "flow."
*   **Do** use `headline-lg` for card titles to give them an authoritative, newspaper-header feel.
*   **Do** use `primary_fixed` as a background for highlight cards to draw the eye to high-yield opportunities.

### Don't
*   **Don't** use 1px dividers or lines to separate list items. Use 24px of vertical space or a background shift to `surface_container_low`.
*   **Don't** use pure black (#000000). Always use `on_background` (#1a1c1c) for text to maintain the organic, "ink on paper" feel.
*   **Don't** use high-intensity shadows. If it looks like a shadow, it’s too dark. It should look like a "soft glow of absence."
*   **Don't** use `DEFAULT` or `sm` roundedness for large components. Keep the platform feeling "robust" and "accessible" with `lg` and `xl` corners.