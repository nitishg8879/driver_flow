# Driver Flow Admin - Copilot Instructions

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
│   ├── bloc/                  # Global BLoC observer
│   ├── di/                    # Dependency injection setup
│   ├── router/                # go_router configuration
│   ├── services/              # Core services (StorageService)
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
│   └── [other features]/
├── utils/
│   ├── components/            # Common reusable widgets
│   ├── constants/             # App constants, strings, ENUMS
│   ├── extensions/            # Dart extensions
│   └── helpers/               # Utility functions
└── main.dart
```

## Coding Conventions

### Enums
**IMPORTANT:** All application enums MUST be placed in `lib/utils/constants/app_enums.dart`
- Do NOT create enums inline in models or widgets
- Import enums from: `import 'package:driver_flow_admin/utils/constants/app_enums.dart';`
- Each enum should include a `displayName` getter for UI display

**Example:**
```dart
enum UserRole {
  admin,
  manager,
  driver,
  viewer;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      // ... other cases
    }
  }
}
```

**Current Enums:**
- `UserRole`: admin, manager, driver, viewer
- `ButtonType`: elevated, outlined, text
- `TransactionType`: credit, debit

### Data Models
- Use `freezed` for immutable data classes
- Use `json_serializable` for JSON serialization
- Place models in `features/<feature>/data/models/`
- Always include `fromJson` factory

**Template:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model_name.freezed.dart';
part 'model_name.g.dart';

@freezed
class ModelName with _$ModelName {
  const factory ModelName({
    required String id,
    // fields here
  }) = _ModelName;

  factory ModelName.fromJson(Map<String, dynamic> json) =>
      _$ModelNameFromJson(json);
}
```

### State Management
- Use `flutter_bloc` for state management
- Cubit for simple state, Bloc for complex event-driven logic
- Use freezed for state and event classes
- Place in `features/<feature>/presentation/bloc/`
- Global BLoC observer in `core/bloc/app_bloc_observer.dart` logs all events/transitions (debug-only)

### Repositories
- Abstract class + implementation in the same file
- Place in `features/<feature>/data/repositories/`
- Repository calls datasource methods
- AuthRepository must update StorageService on login/logout

### Components
- Create reusable widgets in `lib/utils/components/`
- Only create common widgets when truly reusable across features
- Feature-specific widgets go in feature's `widgets/` folder

### File Attachments Pattern
**For any feature that needs file upload/download functionality, use the standardized pattern:**

1. **UI Component:** Use `AttachmentPickerField` from `lib/utils/components/attachment_picker_field.dart`
   - Manages picking files locally (both new and existing)
   - Returns `List<AttachmentModel>` (existing) and `List<PendingAttachment>` (new to upload)
   - User controls picking/removing, NOT uploading

2. **Upload Service:** Use `AttachmentService` from `lib/core/services/attachment_service.dart`
   - Handles Firebase Storage uploads
   - Creates Firestore documents in `documents` collection
   - Auto-generates IDs, paths, and download URLs
   - Already registered in DI: `sl<AttachmentService>()`

3. **Integration Pattern (in form dialogs):**
   ```dart
   // Capture changes from AttachmentPickerField
   List<AttachmentModel> _existingAttachments = [];
   List<PendingAttachment> _pendingAttachments = [];
   
   AttachmentPickerField(
     initialAttachments: _existingAttachments,
     onChanged: (existing, pending) {
       setState(() {
         _existingAttachments = existing;
         _pendingAttachments = pending;
       });
     },
   )
   
   // On form submit, upload pending attachments
   final attachmentService = sl<AttachmentService>();
   for (final pending in _pendingAttachments) {
     final uploaded = await attachmentService.uploadAttachment(
       bytes: pending.bytes,
       fileName: pending.fileName,
       fileType: pending.fileType,
       source: AttachmentSource.yourFeature, // credit, student, etc.
       ownerId: targetId,
       uploadedBy: currentUserId,
     );
     allUrls.add(uploaded.url);
   }
   
   // Save model with all attachment URLs
   model = model.copyWith(attachments: allUrls);
   ```

4. **Feature Enum:** Add source type to `AttachmentSource` enum in `app_enums.dart`
   - Example: `AttachmentSource.payment`, `AttachmentSource.student`

### Constants
- **Strings:** `lib/utils/constants/app_strings.dart`
- **Enums:** `lib/utils/constants/app_enums.dart`
- **Other constants:** `lib/utils/constants/app_constants.dart`

### Logging
- Use `AppLogger` from `lib/utils/helpers/app_logger.dart` for all logging
- Logs only appear in debug mode (automatically disabled in release)
- Create logger instance: `final _logger = AppLogger('ClassName');`
- Available methods: `debug()`, `info()`, `warning()`, `error()`
- Always log in repositories and critical operations

**Example:**
```dart
import '../../../../utils/helpers/app_logger.dart';

class MyRepository {
  final _logger = AppLogger('MyRepository');
  
  Future<void> someMethod() async {
    try {
      _logger.info('Starting operation');
      // ... code
      _logger.debug('Operation details: $data');
    } catch (e, stackTrace) {
      _logger.error('Operation failed', e, stackTrace);
      rethrow;
    }
  }
}

### Local Storage
- Use `StorageService` singleton from `lib/core/services/storage_service.dart`
- Initialized in `main.dart` before app starts
- Stores persistent flags (`isLoggedIn`, `userId`, `userEmail`)
- AuthRepository updates storage on login/logout
- Router uses storage to check auth state

**Usage:**
```dart
final storage = sl<StorageService>();
if (storage.isLoggedIn) {
  // User is logged in
}
```
```

## Design Principles
- **Material 3:** Use modern Material 3 components
- **Simplicity:** Avoid over-engineering, create common widgets only when needed
- **Separation of Concerns:** Clear separation between UI and Data layers
- **Scalability:** Easy to add new features and switch datasources

## Data Layer Pattern
1. **Models:** Immutable data classes using freezed + json_serializable
2. **Datasources:** Abstract interface + concrete implementation (Firebase)
   - Easy to swap datasource in future (e.g., REST API)
3. **Repositories:** Abstract class + implementation in same file
   - Repository calls appropriate datasource methods

## Development Workflow
1. Create feature folder with data + presentation layers
2. Define models with freezed (add enums to `app_enums.dart` first)
3. Create datasource interface + implementation
4. Build repository with abstract class + impl (add logging with AppLogger)
5. Set up bloc/cubit for state management
6. Build UI screens and widgets
7. Register dependencies in get_it
8. Add routes to go_router
9. Run build_runner: `flutter pub run build_runner build --delete-conflicting-outputs`

## Code Generation
**Always run after modifying:**
- Freezed models
- JSON serializable classes
- Any file with `part` directives

```bash
# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode for development
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Firebase Integration
- **Authentication:** Email/Password provider
- **Firestore:** User documents must include role field matching UserRole enum values
- **Security:** Use role-based access control

**User Document Structure:**
```json
{
  "id": "uid",
  "email": "user@example.com",
  "name": "User Name",
  "role": "admin",  // Must match UserRole enum: admin, manager, driver, viewer
  "phoneNumber": "+1234567890",
  "isActive": true,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## Formatting
- Always use `dart format` before committing
- Available as VS Code task: "flutter: format"

## Key Features
- Student management (onboarding, documents, progress tracking)
- Instructor management (leave approval)
- Vehicle CRUD operations
- Schedule calendar view
- Shift change request approval
- Automated notifications

## Existing Features

### 1. Authentication (`features/auth/`)
Handles user authentication and authorization with role-based access control.

**Components:**
- **Login Screen**: Email/password authentication with form validation
- **Splash Screen**: Initial loading screen with app branding
- **Root Layout**: Main navigation wrapper with sidebar and app bar
- **Auth Bloc**: State management for authentication flow
- **User Model**: Freezed data model with UserRole enum (admin, manager, driver, viewer)

**User Roles:**
- `admin`: Full system access and management
- `manager`: Manage operations and view reports
- `driver`: Limited access for drivers
- `viewer`: Read-only access

### 2. Dashboard (`features/dashboard/`)
Main overview screen displaying key metrics and statistics.

**Features:**
- Statistics cards for Total Students, Active Instructors, Total Vehicles, Today's Schedule
- Grid layout with color-coded cards
- Real-time data updates (planned)

### 3. Tags (`features/tags/`)
Reusable tag management system for organizing and filtering data across features.

**Model:** `TagModel` with fields:
- `id` (String, nullable)
- `name` (String, required)
- `color` (String, optional - for UI customization)
- `isActive` (bool, default true)
- `createdAt` / `updatedAt` (DateTime, auto-managed)

**Features:**
- Full CRUD operations (Create, Read, Update, Delete)
- Toggle active/inactive status
- Used by Payment feature for transaction categorization
- Extensible for future use across other features

**Firestore Collection:** `tags`

### 4. Payment (`features/payment/`)
Transaction management system for tracking student payments and fees.

**Model:** `PaymentModel` with fields:
- `id` (String, Firestore document ID)
- `txnId` (String, auto-generated unique identifier)
- `studentId` (String, references UserModel with role "student")
- `studentName` (String, denormalized for display)
- `amount` (double)
- `txnType` (TransactionType enum: credit/debit)
- `txnDate` (DateTime, user-selected)
- `tags` (List<String>, tag IDs for categorization)
- `attachments` (List<String>, Firebase Storage URLs)
- `isActive` (bool, default true)
- `createdAt` / `updatedAt` (DateTime, auto-managed)

**Features:**
- List all transactions for current month with pagination
- Filter by:
  - Transaction ID (search)
  - Student name (search with dropdown)
  - Transaction type (credit/debit)
  - Tags (multi-select)
  - Month (date picker)
- Create new payment with auto-generated transaction ID
- Edit existing payment (reuses same dialog)
- Delete payments with attachment cleanup
- File attachments (PDF, images, docs)

**Firestore Collection:** `payments`
**Storage Path:** `payments/{paymentId}/{fileName}`

**UI Components:**
- `PaymentListScreen`: Main list with filters and pagination
- `PaymentFormDialog`: Unified create/edit dialog with:
  - Auto-generated txnId (read-only in edit mode)
  - Student selection (SearchableAsyncDropdown)
  - Amount input
  - Transaction type dropdown (AsyncDropdown)
  - Transaction date picker
  - Multi-select tags (filter chips from TagsCubit)
  - File attachments with preview/remove
  - Read-only createdAt display in edit mode

## Firebase Setup

### Prerequisites
- Firebase Project created
- Flutter SDK (3.12.1 or higher)
- Chrome browser (for web development)

### Required Firebase Services
1. **Authentication**: Email/Password provider
2. **Cloud Firestore**: Database for user data, students, instructors, vehicles, schedules
3. **Firebase Storage**: Document uploads

### Initial Setup Steps
1. Create Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication > Email/Password provider
3. Create Firestore database (production or test mode)
4. Enable Firebase Storage
5. Register Web App and copy configuration
6. Update `lib/main.dart` with Firebase config:

```dart
await Firebase.initializeApp(
  options: const FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
  ),
);
```

### Create Initial Admin User
1. Firebase Console > Authentication > Add user (email/password)
2. Copy the user UID
3. Firestore Database > Create `users` collection
4. Create document with UID as document ID
5. Add fields: `id`, `email`, `name`, `role: "admin"`, `phoneNumber`, `isActive: true`, `createdAt`, `updatedAt`

**Important**: `role` field must match UserRole enum values: `admin`, `manager`, `driver`, `viewer`

## Available VS Code Tasks
Use Ctrl+Shift+P > "Tasks: Run Task":
- **flutter: pub get** - Install dependencies
- **flutter: build runner (build)** - Generate code
- **flutter: build runner (watch)** - Watch and generate code
- **flutter: clean** - Clean build files
- **flutter: build web** - Build for production
- **flutter: analyze** - Analyze code
- **flutter: format** - Format code

## Quick Start Commands
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d chrome
```

## Troubleshooting
- **Firebase initialization error**: Verify all config values in `lib/main.dart`
- **Build runner errors**: Run `flutter clean`, then `flutter pub get`, then build_runner
- **Authentication errors**: Check Email/Password is enabled in Firebase Console
- **Navigation issues**: Ensure admin user document exists in Firestore with matching UID

## When Creating New Features
1. Ask if new enums are needed → add to `app_enums.dart`
2. Follow Clean Architecture layers (data/presentation)
3. Use existing patterns from auth feature
4. Add logging with AppLogger in repositories and critical operations
5. Register in dependency injection (get_it)
6. Add routes to go_router
7. Run build_runner after creating models
8. Document feature in this file under "Existing Features"
