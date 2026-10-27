# Flutter Architecture & Guidelines

## 1. Project Directory Structure
Strictly adhere to the following directory structure inside `lib/`:

lib/        # Data models & 
├── core/
│   ├── services/
│   │   ├── get_it_service.dart          # Dependency injection setup
│   │   └── api_service.dart            # Dio / API calling service
│   ├── caching/
│   │   ├── shared_pref_service.dart     # SharedPreferences
│   │   └── secure_storage_service.dart  # flutter_secure_storage for tokens
│   └── theme : app colors , app Styls , appFontWeight , 
       utils / widgets : appButton , appInput , and shared widgets in applicaion 
        
│
└── features/
    └── [feature_name]/
        ├── presentation/
        │   ├── views/                  # Screens / Pages
        │   └── components/             # Sub-widgets specific to this feature
        ├── data/
        │   ├── models/         JSON serialization
        │   └── repos/                  # Repositories fetching from api_service
        └── logic/
            ├── [feature]_cubit.dart
            └── [feature]_state.dart

## 2. Mandatory Dependencies
Whenever initiating a new project, adding dependencies, or scaffolding code, ensure the following packages are installed and utilized:
- State Management: flutter_bloc
- Networking: dio
- Dependency Injection: get_it
- Storage: shared_preferences, flutter_secure_storage 
- UI & Responsiveness: flutter_screenutil, skeletonizer, toastification
- Debugging & Testing UI: device_preview
- 

## 3. Implementation Rules
- Always use `Cubit` (from `flutter_bloc`) inside `features/[feature]/logic/`.
- Never put API calls directly inside UI views; route them through `repos` in `data/` using `ApiService` from `core/services/`.
- Tokens and sensitive data must strictly use `flutter_secure_storage`.
- Standard UI inputs, buttons, colors, and validators must be reused from `core/shared/`.
- Responsive designs must utilize `flutter_screenutil` (e.g., `.w`, `.h`, `.sp`).