# 📋 Sala Thimar (سلة ثمار) - Project Architecture & Engineering Rules

## 1. Project Overview & Multi-Role Architecture
- **Application Type**: Multi-Role E-Commerce & On-Demand Delivery Flutter App (Client & Driver in a single codebase).
- **Target Market**: Saudi Arabia (KSA) - Full RTL (Right-to-Left) Arabic layout with SAR currency.
- **User Roles**:
  - `UserType.client`: Normal customer (browse products, cart, checkout, track orders, favorites).
  - `UserType.driver`: Delivery partner (incoming order requests, accept/deliver orders, route navigation, earnings & wallet).
- **Role Resolution**:
  - `user_type` is returned from backend auth responses.
  - Role is persisted locally in secure/shared storage.
  - App navigation guards route dynamically to `ClientShell` or `DriverShell` based on `user_type`.

---

## 2. Directory Structure Conventions

```
lib/
├── core/                         # Shared foundations across the entire app
│   ├── constants/                # API endpoints, assets paths, storage keys
│   ├── network/                  # Dio client, interceptors, error handler
│   ├── router/                   # GoRouter config, route names, role-based guards
│   ├── shared_widgets/           # Reusable UI components (buttons, text fields, cards)
│   ├── theme/                    # Design tokens (colors, typography, dimensions, theme)
│   └── utils/                    # Extensions, formatters, validators
│
├── features/                     # Feature modules (Feature-First Clean Architecture)
│   ├── client/                   # All customer-facing features
│   │   ├── auth/                 # Client login, registration, OTP
│   │   ├── home/
│   │   ├── cart/
│   │   ├── checkout/
│   │   ├── orders/
│   │   └── favorites/
│   │
│   └── driver/                   # All delivery partner features
│       ├── auth/                 # Driver registration (vehicle/IBAN), driver login
│       ├── orders/               # New requests & active deliveries
│       ├── map/                  # Route navigation & customer location
│       ├── wallet/               # Driver earnings, commission, cash collection
│       └── profile/              # Driver vehicle info, IBAN, verification
└── main.dart                     # Application bootstrap & dependency registration
```

---

## 3. Clean Architecture Layer Rules for Features

Every feature within `features/` (whether in `auth`, `client`, or `driver`) must adhere to 3 distinct layers:

1. **Presentation Layer (`presentation/`)**:
   - `screens/`: Page widgets (scaffolds) that listen to or trigger cubits/blocs.
   - `widgets/`: Feature-specific sub-widgets (extracted to avoid rebuilds and keep files small).
   - `cubit/` or `bloc/`: State management handling UI states (Loading, Success, Failure).
   - **Rule**: NO direct API calls or business logic inside UI widgets.

2. **Domain Layer (`domain/`)**:
   - `entities/`: Pure Dart models with essential fields (no JSON parsing logic).
   - `repositories/`: Abstract repository contracts (interfaces).
   - `usecases/`: Single-responsibility business actions (e.g., `GetProductsUseCase`, `AcceptOrderUseCase`).
   - **Rule**: Pure Dart only — ZERO Flutter UI or third-party framework dependencies.

3. **Data Layer (`data/`)**:
   - `models/`: Data transfer objects (DTOs) with `fromJson` and `toJson` methods extending domain entities.
   - `datasources/`: Remote (API calls) and Local (cache/storage) data sources.
   - `repositories/`: Concrete implementations of domain repository interfaces.
   - **Rule**: Handles raw network responses, maps errors to domain failures.

---

## 4. Design System & UI Specifications

1. **Brand Colors**:
   - Primary Green: `#4C8613`
   - Secondary / Light Green: `#61B80C`, `#8AC253`
   - Card Backgrounds: `#F3F8EE`, `#EDF5E6`
   - Surface / White: `#FFFFFF`
   - Danger / Alert: `#FF0000`
   - Grays: `#9C9C9C`, `#707070`, `#F5F5F5`

2. **Typography**:
   - Font Family: `Tajawal` (via Google Fonts).
   - Weights: Light (300), Regular (400), Medium (500), Bold (700), ExtraBold (800).

3. **Responsiveness & Dimensions**:
   - Base design reference: `375 × 812` (iPhone dimensions from Figma).
   - Use `flutter_screenutil` (`.w`, `.h`, `.r`, `.sp`) for sizes, margins, paddings, and font sizes.
   - Standard button height: `60.h`, default border radius: `15.r`.

4. **Localization & Directionality**:
   - Always enforce RTL (Right-to-Left) directionality across all screens and components.
   - Texts, icons (e.g. back arrows), and form inputs must naturally align with Arabic reading order.

---

## 5. Senior Engineering Best Practices

- **Separation of Concerns**: Client and Driver features must remain decoupled. Shared logic lives strictly in `core/` or `features/auth/`.
- **State Management**: Use `flutter_bloc` / `cubit`. States must be immutable (`Equatable`).
- **Dependency Injection**: Use `get_it` service locator to inject datasources, repositories, and cubits.
- **Error Handling**: Use functional error handling (`Either<Failure, T>` via `dartz` or custom Result type).
- **Clean Code**: Keep functions under 30 lines, split large widgets into smaller private or dedicated widget files.
