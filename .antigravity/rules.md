# Flutter Architecture & Standards Specification

## 1. Directory Structure (Feature-First MVVM / Clean Architecture)
Always adhere strictly to this directory structure inside `lib/`:

lib/
├── core/
│   ├── caching/
│   │   ├── shared_pref_service.dart      # SharedPreferences for general caching
│   │   └── secure_storage_service.dart   # flutter_secure_storage for tokens and sensitive keys
│   ├── services/
│   │   ├── get_it_service.dart           # Service locator & dependency injection
│   │   └── api_service.dart              # Dio implementation for network calls
│   ├── errors/
│   │   ├── failures.dart                 # Failure classes used with Dartz (Either<Failure, T>)
│   │   └── exceptions.dart               # Custom server/cache exceptions
│   ├── theme/
│   │   ├── app_colors.dart               # Global color palette
│   │   ├── app_styles.dart               # Text styles & typography
│   │   └── app_font_weight.dart          # Font weight constants
│   ├── routes/
│   │   ├── app_route_name.dart           # Static string constants for route names/paths
│   │   └── app_router.dart               # GoRouter configuration & route definitions
│   ├── constants/
│   │   └── app_constants.dart            # Constant keys (endpoints, storage keys, etc.)
│   └── shared_components/
│       ├── app_text_form_field.dart      # Reusable styled text input fields
│       ├── app_validator.dart            # Form input validation logic
│       └── app_button.dart               # Reusable app buttons
│
└── features/
    └── [feature_name]/
        ├── presentation/
        │   ├── views/                   # Feature screens / pages
        │   └── components/              # Sub-widgets specific to this feature
        ├── data/
        │   ├── models/                  # Data classes and JSON serialization
        │   └── repos/                  # Repositories returning Either<Failure, T>
        └── logic/
            ├── [feature]_cubit.dart     # Cubit managing UI state
            └── [feature]_state.dart     # States handling initial, loading, success, failure

## 2. Mandatory Dependencies
Ensure the following packages are always configured and used:
- Functional Error Handling: dartz
- Navigation: go_router
- State Management: flutter_bloc (specifically Cubit)
- Networking: dio
- Dependency Injection: get_it
- Storage: shared_preferences, flutter_secure_storage
- UI & Responsiveness: flutter_screenutil, skeletonizer, toastification
- Debugging: device_preview

## 3. Strict Development Rules
- **Error Handling & Repositories:** All repository functions in `data/repos/` must return `Future<Either<Failure, Type>>` using `dartz`. Handle network exceptions inside the repo and return a `Left(Failure)` on errors, and `Right(data)` on success.
- **State Management:** In `logic/`, the Cubit must fold the `Either` result (`result.fold((failure) => emit(ErrorState(failure.message)), (data) => emit(SuccessState(data)))`).
- **Styling & Colors:** Colors must be strictly referenced from `core/theme/app_colors.dart`. Never define colors in `shared_components/`.
- **Navigation:** Exclusively use `go_router` referencing paths defined in `app_route_name.dart`.
- **Inputs & Validation:** Reuse `app_text_form_field.dart`, `app_button.dart`, and validate using `app_validator.dart` from `core/shared_components/`.
- **Security:** Tokens and sensitive information must strictly use `flutter_secure_storage`.