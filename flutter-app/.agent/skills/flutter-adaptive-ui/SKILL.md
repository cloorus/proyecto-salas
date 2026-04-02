---
name: flutter-adaptive-ui
description: Building responsive and adaptive UIs for multiple screen sizes (mobile, tablet, desktop).
triggers:
  - responsive
  - adaptive
  - screen size
  - LayoutBuilder
  - MediaQuery
role: UI specialist
scope: design
---

# Flutter Adaptive UI

Guidelines for creating UIs that work beautifully across all platforms.

## Breakpoints

- **Mobile**: < 600px
- **Tablet**: 600px - 1024px
- **Desktop**: > 1024px

## Techniques

- Use **LayoutBuilder** for container-relative constraints.
- Use **MediaQuery** for screen-relative information.
- Prefer **Flexible** and **Expanded** over hardcoded sizes.
- Implement **adaptive navigation** (BottomNav on mobile, NavRail/Drawer on desktop).
- Handle text scaling with capped values to prevent layout breakage.
