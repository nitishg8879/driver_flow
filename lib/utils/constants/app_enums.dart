// Application-wide enums

/// User role types
enum UserRole {
  admin,
  manager,
  driver,
  viewer,
  student;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.driver:
        return 'Driver';
      case UserRole.viewer:
        return 'Viewer';
      case UserRole.student:
        return 'Student';
    }
  }
}

/// Button style types
enum ButtonType { elevated, outlined, text }
