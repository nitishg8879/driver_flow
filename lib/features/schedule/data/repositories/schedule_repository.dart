import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/schedule_model.dart';

/// Thrown when a new/updated schedule would overlap an existing active
/// schedule for the same instructor or vehicle.
class ScheduleConflictException implements Exception {
  final String message;
  ScheduleConflictException(this.message);

  @override
  String toString() => message;
}

abstract class ScheduleRepository {
  /// Fetches all active schedules for [date], optionally filtered by
  /// [instructorId] and/or [studentId]. Not paginated — a single day's
  /// schedule is expected to be a small, bounded set.
  Future<List<ScheduleModel>> getSchedulesForDate({
    required DateTime date,
    String? instructorId,
    String? studentId,
  });

  Future<ScheduleModel> createSchedule(ScheduleModel schedule);
  Future<ScheduleModel> updateSchedule(ScheduleModel schedule);
  Future<void> setActiveStatus(String id, bool isActive);
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final FirebaseFirestore _firestore;
  final _logger = AppLogger('ScheduleRepository');

  ScheduleRepositoryImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.schedulesCollection);

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

  @override
  Future<List<ScheduleModel>> getSchedulesForDate({
    required DateTime date,
    String? instructorId,
    String? studentId,
  }) async {
    try {
      final start = _startOfDay(date);
      final end = _endOfDay(date);

      Query<Map<String, dynamic>> query = _collection
          .where('isActive', isEqualTo: true)
          .where(
            'date',
            isGreaterThanOrEqualTo: start.toIso8601String(),
            isLessThanOrEqualTo: end.toIso8601String(),
          );

      if (instructorId != null) {
        query = query.where('instructorId', isEqualTo: instructorId);
      }
      if (studentId != null) {
        query = query.where('studentId', isEqualTo: studentId);
      }

      final snapshot = await query.get();
      final schedules = snapshot.docs
          .map((doc) => ScheduleModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
      schedules.sort((a, b) => a.startTime.compareTo(b.startTime));
      return schedules;
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch schedules for date', e, stackTrace);
      rethrow;
    }
  }

  bool _timesOverlap(
    DateTime aStart,
    DateTime aEnd,
    DateTime bStart,
    DateTime bEnd,
  ) {
    return aStart.isBefore(bEnd) && bStart.isBefore(aEnd);
  }

  /// Checks whether [schedule] would overlap any existing active,
  /// non-cancelled schedule for the same instructor or same vehicle on the
  /// same date. [excludeId] should be set to the schedule's own id when
  /// updating, so it doesn't conflict with itself.
  Future<void> _validateNoConflict(
    ScheduleModel schedule, {
    String? excludeId,
  }) async {
    final start = _startOfDay(schedule.date);
    final end = _endOfDay(schedule.date);

    final dateRangeQuery = _collection
        .where('isActive', isEqualTo: true)
        .where(
          'date',
          isGreaterThanOrEqualTo: start.toIso8601String(),
          isLessThanOrEqualTo: end.toIso8601String(),
        );

    final instructorSnapshot = await dateRangeQuery
        .where('instructorId', isEqualTo: schedule.instructorId)
        .get();
    final vehicleSnapshot = await dateRangeQuery
        .where('vehicleId', isEqualTo: schedule.vehicleId)
        .get();

    final candidates = {
      for (final doc in [...instructorSnapshot.docs, ...vehicleSnapshot.docs])
        doc.id: doc,
    };

    for (final doc in candidates.values) {
      if (doc.id == excludeId) continue;

      final existing = ScheduleModel.fromJson({'id': doc.id, ...doc.data()});
      if (existing.status.isCancelled) continue;

      final sameInstructor = existing.instructorId == schedule.instructorId;
      final sameVehicle = existing.vehicleId == schedule.vehicleId;
      if (!sameInstructor && !sameVehicle) continue;

      if (_timesOverlap(
        schedule.startTime,
        schedule.endTime,
        existing.startTime,
        existing.endTime,
      )) {
        final conflictOn = sameInstructor ? 'instructor' : 'vehicle';
        throw ScheduleConflictException(
          'This slot conflicts with an existing schedule for the same $conflictOn',
        );
      }
    }
  }

  @override
  Future<ScheduleModel> createSchedule(ScheduleModel schedule) async {
    try {
      await _validateNoConflict(schedule);

      final docRef = _collection.doc();
      final data = schedule.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await docRef.set(data.toJson()..remove('id'));
      _logger.info('Schedule created: ${docRef.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to create schedule', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<ScheduleModel> updateSchedule(ScheduleModel schedule) async {
    try {
      if (schedule.id == null) {
        throw Exception('Schedule id is required for update');
      }

      await _validateNoConflict(schedule, excludeId: schedule.id);

      final data = schedule.copyWith(updatedAt: DateTime.now());
      await _collection.doc(schedule.id).update(data.toJson()..remove('id'));
      _logger.info('Schedule updated: ${schedule.id}');
      return data;
    } catch (e, stackTrace) {
      _logger.error('Failed to update schedule', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> setActiveStatus(String id, bool isActive) async {
    try {
      await _collection.doc(id).update({
        'isActive': isActive,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      _logger.info('Schedule $id active status set to $isActive');
    } catch (e, stackTrace) {
      _logger.error('Failed to update schedule status', e, stackTrace);
      rethrow;
    }
  }
}
