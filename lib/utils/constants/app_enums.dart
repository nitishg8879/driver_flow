// Application-wide enums

/// User role types
enum UserRole {
  admin,
  manager,
  viewer,
  student,
  instructor;

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.manager:
        return 'Manager';
      case UserRole.viewer:
        return 'Viewer';
      case UserRole.student:
        return 'Student';
      case UserRole.instructor:
        return 'Instructor';
    }
  }
}

/// Button style types
enum ButtonType { elevated, outlined, text }

/// Type of file stored in an attachment
enum AttachmentFileType {
  drivingLicense,
  profilePhoto,
  document,
  other;

  String get displayName {
    switch (this) {
      case AttachmentFileType.drivingLicense:
        return 'Driving License';
      case AttachmentFileType.profilePhoto:
        return 'Profile Photo';
      case AttachmentFileType.document:
        return 'Document';
      case AttachmentFileType.other:
        return 'Other';
    }
  }
}

/// Feature/module that owns an attachment
enum AttachmentSource {
  student,
  instructor,
  payment,
  vehicle;

  String get displayName {
    switch (this) {
      case AttachmentSource.student:
        return 'Student';
      case AttachmentSource.instructor:
        return 'Instructor';
      case AttachmentSource.vehicle:
        return 'Vehicle';
      case AttachmentSource.payment:
        return 'Payment';
    }
  }
}

/// Status of a scheduled driving lesson slot
enum ScheduleStatus {
  scheduled,
  completed,
  cancelledByInstructor,
  cancelledByStudent,
  adminCancelled;

  String get displayName {
    switch (this) {
      case ScheduleStatus.scheduled:
        return 'Scheduled';
      case ScheduleStatus.completed:
        return 'Completed';
      case ScheduleStatus.cancelledByInstructor:
        return 'Cancelled by Instructor';
      case ScheduleStatus.cancelledByStudent:
        return 'Cancelled by Student';
      case ScheduleStatus.adminCancelled:
        return 'Cancelled by Admin';
    }
  }

  bool get isCancelled =>
      this == ScheduleStatus.cancelledByInstructor ||
      this == ScheduleStatus.cancelledByStudent ||
      this == ScheduleStatus.adminCancelled;
}

/// Transaction type for payment transactions
enum TransactionType {
  credit,
  debit;

  String get displayName {
    switch (this) {
      case TransactionType.credit:
        return 'Credit';
      case TransactionType.debit:
        return 'Debit';
    }
  }
}
