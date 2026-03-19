```markdown
# Design System Specification: Cognitive Sanctuary

## 1. Overview & Creative North Star
**Creative North Star: The Academic Monolith**
This design system moves away from the "gamified" aesthetic typical of mobile trainers. Instead, it adopts a high-end editorial feel—think of a prestigious scientific journal meets a premium minimalist timepiece. We are building a "Cognitive Sanctuary": a space where the UI recedes to allow the user’s focus to take center stage. 

The system breaks the standard "mobile app" template by using intentional asymmetry in layout, generous white space (macro-typography), and a sophisticated layering of surfaces that replaces traditional borders. We are not just building a grid; we are building an environment for mental clarity.

---

## 2. Colors
Our palette is anchored in intellectual rigor. We use a deep, focused blue (`primary: #2559bd`) against a sophisticated range of cool grays and off-whites.

*   **The "No-Line" Rule:** Explicitly prohibit 1px solid borders for sectioning. Boundaries between the Schulte Grid and the surrounding UI must be defined solely through background color shifts. For example, the main navigation or header should sit on `surface`, while the training area transitions to `surface-container-low`.
*   **Surface Hierarchy & Nesting:** Treat the UI as a series of nested physical layers. 
    *   **Level 0 (Base):** `background: #f8f9fa`
    *   **Level 1 (Sectioning):** `surface-container-low: #f1f4f6`
    *   **Level 2 (Active Components):** `surface-container-lowest: #ffffff`
*   **The "Glass & Gradient" Rule:** Use `surface-variant` with a 60% opacity and a 20px backdrop-blur for floating modals or pause screens. Main action buttons (CTAs) should utilize a subtle linear gradient from `primary` (#2559bd) to `primary_dim` (#0f4db0) at a 135-degree angle to provide a sense of tactile depth and premium polish.

---

## 3. Typography
The system employs a dual-typeface strategy to balance academic authority with modern readability.

*   **Headlines (Manrope):** Use Manrope for all `display` and `headline` roles. Its geometric construction feels engineered and professional. Use `display-lg` for high-impact screens like "Session Complete" to create an editorial, high-contrast moment.
*   **The Interface (Inter):** Use Inter for all `title`, `body`, and `label` roles. Specifically, the numbers within the Schulte Grid must use `title-lg` or `headline-sm` to ensure zero friction during rapid scanning.
*   **Hierarchy as Identity:** Create "breathing room" by setting `headline-md` titles with a `spacing-8` (2.75rem) bottom margin. This authoritative use of white space signals that the content is important and the environment is calm.

---

## 4. Elevation & Depth
We eschew the heavy shadows of the 2010s in favor of **Tonal Layering**.

*   **The Layering Principle:** To lift an element, change its container color. A Schulte Grid cell (the "Focus Vessel") should be `surface-container-lowest` (#ffffff) sitting on a `surface-container` (#eaeff1) field. This creates a soft, natural lift.
*   **Ambient Shadows:** For floating elements (e.g., a "New Record" toast), use an extra-diffused shadow: `0px 24px 48px rgba(43, 52, 55, 0.06)`. Note the color: we use a tinted version of `on-surface` (#2b3437) at very low opacity to mimic natural ambient light.
*   **The "Ghost Border" Fallback:** If a cell requires a state-based border (e.g., a "correct" tap), use the `outline-variant` (#abb3b7) at 20% opacity. Never use 100% opaque borders.
*   **Glassmorphism:** Use semi-transparent `surface_bright` with a 12px blur for the grid overlay when a session is paused. This keeps the user "tethered" to the grid without allowing it to distract.

---

## 5. Components

### Grid Cells (The Focus Vessels)
*   **Visuals:** No borders. Background: `surface-container-lowest`. Shape: `lg` (0.5rem) roundedness. 
*   **Interaction:** On tap, briefly transition background to `primary-container` (#dae2ff).
*   **Spacing:** Use `spacing-2` (0.7rem) for the gap between cells.

### Buttons
*   **Primary:** Background: Gradient `primary` to `primary-dim`. Text: `on-primary` (#f8f7ff). Roundedness: `full`.
*   **Secondary:** Background: `surface-container-highest` (#dbe4e7). Text: `on-surface` (#2b3437). No border.
*   **Tertiary:** Text: `primary`. No background. Use for "Skip" or "Back" actions.

### Progress Indicators
*   **The "Breath" Bar:** Instead of a thick loading bar, use a 2px high line of `primary` atop a full-width `outline-variant` (at 10% opacity) line. It should feel like a fine needle on a gauge.

### Cards & Lists
*   **Forbid Dividers:** Do not use horizontal rules. Separate session history items using vertical white space (`spacing-3`: 1rem) and subtle background shifts (alternating `surface-container-low` and `surface`).

### Input Fields
*   **Visuals:** `surface-container-low` background. A 2px bottom-only "active" border using `primary` when focused. Labels should use `label-md` in `on-surface-variant` (#586064).

---

## 6. Do's and Don'ts

### Do
*   **Use Asymmetric Margins:** Push the main headline to the left and the grid to the right (on tablets) to create a sophisticated, editorial layout.
*   **Embrace Macro-Spacing:** Use `spacing-16` (5.5rem) to separate major functional areas.
*   **Prioritize Legibility:** Ensure numbers in the grid are perfectly centered within their cells with high contrast (Inter `title-lg` on `surface-container-lowest`).

### Don't
*   **No "Heavy" Shadows:** Never use the default #000000 shadows. They muddy the clean, academic feel.
*   **No Grid Lines:** Do not put 1px lines between numbers. The "ghost" of the grid is formed by the gaps between the surface containers.
*   **No Vibrating Colors:** Avoid using `error` (#9f403d) too aggressively. Use it only for critical failures, keeping the experience "calming" even during mistakes.
*   **No Standard Icons:** If icons are needed, use ultra-thin (1pt or 1.5pt) stroke weights to match the Manrope/Inter aesthetic. Avoid filled, "bubbly" icons.