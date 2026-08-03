import 'package:driver_flow_admin/features/profile/data/models/organization_profile_model.dart';
import 'package:driver_flow_admin/utils/helpers/app_logger.dart';

final _logger = AppLogger('DateHelper');

/// Utility functions for date calculations considering organization working days
class DateHelper {
  /// Calculates which week of month a date falls into (1-4)
  /// Used for Saturday pattern matching (e.g., 1st Saturday, 3rd Saturday)
  static int getWeekOfMonth(DateTime date) {
    return ((date.day - 1) ~/ 7) + 1;
  }

  /// Checks if a specific date matches the organization's working days
  /// Supports both simple days (Monday-Sunday) and Saturday patterns (1st/3rd, etc.)
  static bool isWorkingDay(DateTime date, List<OrgWorkingDay> workingDays) {
    if (workingDays.isEmpty) {
      return true; // If no working days specified, all days are working
    }

    final dayOfWeek = date.weekday; // 1 = Monday, 7 = Sunday
    final dateOrgWorkingDay = _dateToOrgWorkingDay(dayOfWeek);

    // Check for exact day match
    if (workingDays.contains(dateOrgWorkingDay)) {
      return true;
    }

    // Check for Saturday pattern matches
    if (dayOfWeek == 6) {
      // Saturday
      final weekOfMonth = getWeekOfMonth(date);
      for (final workingDay in workingDays) {
        if (_matchesSaturdayPattern(workingDay, weekOfMonth)) {
          return true;
        }
      }
    }

    return false;
  }

  /// Converts DateTime weekday (1-7) to OrgWorkingDay enum for simple days
  static OrgWorkingDay _dateToOrgWorkingDay(int weekday) {
    switch (weekday) {
      case 1:
        return OrgWorkingDay.monday;
      case 2:
        return OrgWorkingDay.tuesday;
      case 3:
        return OrgWorkingDay.wednesday;
      case 4:
        return OrgWorkingDay.thursday;
      case 5:
        return OrgWorkingDay.friday;
      case 6:
        return OrgWorkingDay.saturday;
      case 7:
        return OrgWorkingDay.sunday;
      default:
        return OrgWorkingDay.monday;
    }
  }

  /// Checks if a Saturday pattern matches the given week of month
  static bool _matchesSaturdayPattern(OrgWorkingDay pattern, int weekOfMonth) {
    switch (pattern) {
      case OrgWorkingDay.firstAndThirdSaturday:
        return weekOfMonth == 1 || weekOfMonth == 3;
      case OrgWorkingDay.secondAndFourthSaturday:
        return weekOfMonth == 2 || weekOfMonth == 4;
      case OrgWorkingDay.firstAndSecondSaturday:
        return weekOfMonth == 1 || weekOfMonth == 2;
      case OrgWorkingDay.thirdAndFourthSaturday:
        return weekOfMonth == 3 || weekOfMonth == 4;
      default:
        return false;
    }
  }

  /// Advances a date by a specified number of working days
  /// Returns the date after advancing by the given working days, skipping non-working days
  static DateTime calculateNextWorkingDate(
    DateTime startDate,
    int workingDaysToAdd,
    List<OrgWorkingDay> workingDays,
  ) {
    if (workingDaysToAdd <= 0) {
      return startDate;
    }

    DateTime currentDate = startDate;
    int workingDaysAdded = 0;

    while (workingDaysAdded < workingDaysToAdd) {
      currentDate = currentDate.add(const Duration(days: 1));
      if (isWorkingDay(currentDate, workingDays)) {
        workingDaysAdded++;
      }
    }

    return currentDate;
  }

  /// Generates a list of N session dates, starting from startDate
  /// Each session occurs on a different working day (1 session per working day)
  static List<DateTime> getSessionDates(
    DateTime startDate,
    int sessionCount,
    List<OrgWorkingDay> workingDays,
  ) {
    if (sessionCount <= 0) {
      return [];
    }

    final sessionDates = <DateTime>[];
    DateTime currentDate = startDate;

    // First session starts from the first working day from startDate (inclusive if working day)
    if (isWorkingDay(currentDate, workingDays)) {
      sessionDates.add(currentDate);
    } else {
      currentDate = calculateNextWorkingDate(currentDate, 1, workingDays);
      sessionDates.add(currentDate);
    }

    // Generate remaining session dates
    for (int i = 1; i < sessionCount; i++) {
      currentDate = calculateNextWorkingDate(currentDate, 1, workingDays);
      sessionDates.add(currentDate);
    }

    _logger.debug('Generated ${sessionDates.length} session dates');
    return sessionDates;
  }

  /// Calculates the due date for an installment based on session distribution
  /// Due date = the date of the last session in that installment
  static DateTime getInstallmentDueDate(
    List<DateTime> sessionDates,
    int installmentIndex,
    int totalInstallments,
  ) {
    if (sessionDates.isEmpty ||
        installmentIndex < 0 ||
        installmentIndex >= totalInstallments) {
      return DateTime.now();
    }

    final sessionsPerInstallment = (sessionDates.length / totalInstallments)
        .ceil();
    final lastSessionIndex =
        ((installmentIndex + 1) * sessionsPerInstallment - 1).clamp(
          0,
          sessionDates.length - 1,
        );

    return sessionDates[lastSessionIndex];
  }
}
