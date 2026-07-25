# Driver Flow Admin - Architecture Documentation

## Project Overview
Admin panel for motor training school management. Web-only Flutter application targeting school owners to manage students, instructors, vehicles, and schedules.

## Tech Stack
- **Framework:** Flutter Web
- **Backend:** Firebase (Auth, Firestore, Storage)
- **State Management:** flutter_bloc
- **Routing:** go_router
- **Dependency Injection:** get_it
- **Code Generation:** build_runner, freezed, json_serializable

## Architecture Pattern
Clean Architecture with feature-based folder structure separating UI and Data layers.

## Folder Structure
```
lib/
├── core/
│   ├── di/                    # Dependency injection setup
│   ├── router/                # go_router configuration
│   └── theme/                 # Material 3 theme configuration
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/   # Firebase datasource
│   │   │   ├── models/        # Data models (freezed)
│   │   │   └── repositories/  # Repository implementation
│   │   └── presentation/
│   │       ├── bloc/          # State management
│   │       ├── screens/       # Login, splash screens
│   │       └── widgets/       # Feature-specific widgets
│   ├── dashboard/
│   │   └── [same structure]
│   └── [other features]/
├── utils/
│   ├── components/            # Common reusable widgets
│   ├── constants/             # App constants
│   ├── extensions/            # Dart extensions
│   └── helpers/               # Utility functions
└── main.dart
```

## Design Principles
- **Material 3:** Modern UI with Material 3 components
- **Simplicity:** Avoid over-engineering, create common widgets only when needed
- **Separation of Concerns:** Clear separation between UI and Data layers
- **Scalability:** Easy to add new features and switch datasources

## Data Layer Pattern
1. **Models:** Immutable data classes using freezed + json_serializable
2. **Datasources:** Abstract interface + concrete implementation (Firebase)
   - Easy to swap datasource in future (e.g., REST API)
3. **Repositories:** Abstract class + implementation in same file
   - Repository calls appropriate datasource methods

## State Management
- **flutter_bloc** for predictable state management
- Use Cubit for simple state, Bloc for complex event-driven logic
- State classes using freezed for immutability

## Routing
- **go_router** with authentication guards
- Route protection based on auth state
- Deep linking support for web

## Authentication Flow
```
Splash Screen (check auth) 
    ├─> Not Authenticated → Login Screen
    └─> Authenticated → Root Layout → Dashboard
```

## Key Features
- Student management (onboarding, documents, progress tracking)
- Instructor management (leave approval)
- Vehicle CRUD operations
- Schedule calendar view
- Shift change request approval
- Automated notifications

## Development Workflow
1. Create feature folder with data + presentation layers
2. Define models with freezed
3. Create datasource interface + implementation
4. Build repository with abstract class + impl
5. Set up bloc/cubit for state management
6. Build UI screens and widgets
7. Register dependencies in get_it
8. Add routes to go_router
9. Run `flutter pub run build_runner build --delete-conflicting-outputs`

## Code Generation Commands
```bash
# Generate freezed and json_serializable code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for development
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Firebase Setup Required
- Firebase Authentication (Email/Password)
- Cloud Firestore (Database)
- Firebase Storage (Document uploads)
- Configure web app in Firebase Console

## Running the App
- Target: Chrome (Web)
- Use launch configurations in `.vscode/launch.json`
