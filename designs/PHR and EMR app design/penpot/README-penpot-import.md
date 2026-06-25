# Importing Clinical Curator designs into Penpot

You have two things to bring into Penpot: **design tokens** (colors, spacing, type) and the **screen layouts** themselves. Penpot handles each differently.

---

## 1. Design Tokens — native import (recommended)

Penpot has a built-in design-tokens engine that reads the **W3C DTCG** JSON format. The file `penpot/design-tokens.tokens.json` is already in that format.

**Steps:**
1. Open your Penpot file.
2. Left panel → click the **Tokens** tab (the `{}` icon).
3. Click the **⋯ menu → Import**.
4. Upload `penpot/design-tokens.tokens.json`.
5. All colors, spacing, radius, font sizes and weights appear as token sets you can apply to any shape.

This is the cleanest path — tokens stay editable and update everywhere when changed, matching how the Flutter `app_colors.dart` / `app_theme.dart` constants work in your codebase.

---

## 2. Screen layouts — two options

Penpot **cannot** import live HTML/CSS directly. Pick one:

### Option A — SVG import (fastest, keeps vectors editable)
1. Open each `.dc.html` design in the browser (PHR / EMR / Admin).
2. Take a full-resolution screenshot of each screen frame, **or** ask me to export each frame as **SVG/PNG** (I can generate these).
3. In Penpot: **File → Import → SVG/PNG**. SVG keeps shapes, text and icons as editable vector layers; PNG is flat (reference only).

> SVG is the better choice — icons and text stay as real objects you can restyle with the imported tokens.

### Option B — Rebuild natively using tokens (highest fidelity, most work)
Use the imported tokens + the screenshots as a visual reference and rebuild each screen as a Penpot board. Best if Penpot is your long-term source of truth before Flutter implementation.

---

## 3. Recommended workflow for your presentation

1. Import `design-tokens.tokens.json` first (1 min).
2. Ask me to **export all 13 screens as SVG** — I'll drop them in `penpot/svg/`.
3. Drag the SVGs onto Penpot boards, grouped into three pages: **PHR**, **Clinician (EMR)**, **Admin**.
4. Apply token colors where you want to tweak live.

---

## Token → Flutter mapping

The token names mirror your codebase so handoff is 1:1:

- `color.primary` → `AppColors.primary` (#004AC6)
- `color.critical` → `AppColors.error` (#BA1A1A)
- `color.vital-*` → clinical vital-sign palette
- `radius.card` (16px), `radius.button` (10px) → shadcn_flutter component radii
- `font-weight.*` → Geist weights

All screens are FHIR R4-aware (LOINC / RxNorm / SNOMED / ICD-10 codes shown in records & encounters) for interoperability.
