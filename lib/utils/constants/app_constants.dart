class AppConstants {
  // App Info
  static const String appName = 'Driver Flow Admin';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String vehiclesCollection = 'vehicles';
  static const String vehicleTypesCollection = 'vehicle_types';
  static const String schedulesCollection = 'schedules';
  static const String shiftsCollection = 'shifts';
  static const String leaveRequestsCollection = 'leave_requests';
  static const String shiftChangeRequestsCollection = 'shift_change_requests';
  static const String progressRecordsCollection = 'progress_records';
  static const String documentsCollection = 'documents';
  static const String tagsCollection = 'tags';
  static const String paymentsCollection = 'payments';
  static const String organizationCollection = 'organization';
  static const String holidaysSubcollection = 'holidays';

  // Shared Preferences Keys
  static const String isLoggedInKey = 'isLoggedIn';
  static const String userIdKey = 'userId';
  static const String userEmailKey = 'userEmail';

  // UI Constants
  static const double sidebarWidth = 280.0;
  static const double defaultPadding = 20.0;
  static const double cardBorderRadius = 16.0;
  static const double containerBorderRadius = 24.0;
  static const double buttonBorderRadius = 12.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;
}
