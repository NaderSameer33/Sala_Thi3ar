---
description: Architecture, multi-role structure (client & driver), design system, and clean code rules for Sala Thimar
trigger: always_on
---

# Sala Thimar Engineering & Architecture Rules

## 1. Multi-Role Single App Policy
- Single codebase supporting both `client` and `driver`.
- Authentication returns `user_type` ('client' or 'driver').
- Store `user_type` in local storage; router directs to `ClientShell` or `DriverShell`.
- Do not mix client widgets into driver screens or vice-versa.

## 2. Directory Structure
- `lib/core/`: Design system tokens (colors, text styles, dimensions, theme), shared widgets, network (Dio), router (GoRouter).
- `lib/features/client/`: All customer-facing features (auth, home, cart, checkout, orders, favorites).
- `lib/features/driver/`: All driver-specific features (auth, orders/requests, map/navigation, wallet/earnings, profile/vehicle).

## 3. Clean Architecture Standards per Feature
- `presentation/`: Screens, sub-widgets, and Cubits/Blocs. No business logic in UI widgets.
- `domain/`: Entities, repository interfaces, and UseCases. Pure Dart only.
- `data/`: Models (DTOs with fromJson/toJson), Remote/Local DataSources, and Repository implementations.

## 4. UI & Design System Rules
- Colors: Primary Green `#4C8613`, Secondary `#61B80C`, Backgrounds `#F3F8EE`, `#EDF5E6`.
- Font: Google Fonts `Tajawal` with exact weights (300 to 800).
- Directionality: Arabic RTL is mandatory.
- Responsive sizing: Base 375x812 with `flutter_screenutil`.
- Reusability: Common buttons, text fields, headers must be reused from `core/shared_widgets`.
