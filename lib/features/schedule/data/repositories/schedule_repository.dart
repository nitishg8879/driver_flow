import 'package:flutter/material.dart';
import '../../../../utils/constants/app_enums.dart';
import '../models/schedule_model.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleModel>> getSchedules({
    String? instructorId,
    String? studentId,
    ScheduleStatus? status,
    DateTimeRange? dateRange,
  });
  Future<List<ScheduleInstructorOption>> getInstructors();
  Future<List<ScheduleStudentOption>> getStudents();
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  static final _now = DateTime.now();

  static DateTime _dt(int daysOffset, int hour, int minute) {
    final d = _now.add(Duration(days: daysOffset));
    return DateTime(d.year, d.month, d.day, hour, minute);
  }

  static final _mockSchedules = [
    ScheduleModel(
      id: 's1',
      studentId: 'st1',
      studentName: 'James Doe',
      studentPermit: 'Permit #84920',
      instructorId: 'i1',
      instructorName: 'Sarah Jenkins',
      vehicleId: 'v1',
      vehicleName: 'Toyota Corolla (A)',
      startTime: _dt(0, 9, 0),
      endTime: _dt(0, 11, 0),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's2',
      studentId: 'st2',
      studentName: 'Alice Smith',
      studentPermit: 'Permit #93012',
      instructorId: 'i2',
      instructorName: 'Mike Torres',
      vehicleId: 'v2',
      vehicleName: 'Honda Civic (M)',
      startTime: _dt(0, 13, 30),
      endTime: _dt(0, 15, 30),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's3',
      studentId: 'st3',
      studentName: 'Emma Watson',
      studentPermit: 'Permit #11204',
      instructorId: 'i3',
      instructorName: 'David Chen',
      vehicleId: 'v3',
      vehicleName: 'Ford Focus (A)',
      startTime: _dt(-1, 10, 0),
      endTime: _dt(-1, 12, 0),
      status: ScheduleStatus.cancelledByStudent,
    ),
    ScheduleModel(
      id: 's4',
      studentId: 'st4',
      studentName: 'Liam Neeson',
      studentPermit: 'Permit #55490',
      instructorId: 'i1',
      instructorName: 'Sarah Jenkins',
      vehicleId: 'v1',
      vehicleName: 'Toyota Corolla (A)',
      startTime: _dt(1, 14, 0),
      endTime: _dt(1, 16, 0),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's5',
      studentId: 'st5',
      studentName: 'Nina Patel',
      studentPermit: 'Permit #32180',
      instructorId: 'i2',
      instructorName: 'Mike Torres',
      vehicleId: 'v2',
      vehicleName: 'Honda Civic (M)',
      startTime: _dt(2, 9, 0),
      endTime: _dt(2, 11, 0),
      status: ScheduleStatus.completed,
    ),
    ScheduleModel(
      id: 's6',
      studentId: 'st6',
      studentName: 'Carlos Rivera',
      studentPermit: 'Permit #77661',
      instructorId: 'i3',
      instructorName: 'David Chen',
      vehicleId: 'v3',
      vehicleName: 'Ford Focus (A)',
      startTime: _dt(3, 11, 0),
      endTime: _dt(3, 13, 0),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's7',
      studentId: 'st7',
      studentName: 'Priya Mehta',
      studentPermit: 'Permit #41230',
      instructorId: 'i1',
      instructorName: 'Sarah Jenkins',
      vehicleId: 'v4',
      vehicleName: 'Suzuki Swift (M)',
      startTime: _dt(5, 8, 0),
      endTime: _dt(5, 10, 0),
      status: ScheduleStatus.adminCancelled,
    ),
    ScheduleModel(
      id: 's8',
      studentId: 'st2',
      studentName: 'Alice Smith',
      studentPermit: 'Permit #93012',
      instructorId: 'i2',
      instructorName: 'Mike Torres',
      vehicleId: 'v2',
      vehicleName: 'Honda Civic (M)',
      startTime: _dt(6, 15, 0),
      endTime: _dt(6, 17, 0),
      status: ScheduleStatus.completed,
    ),
    ScheduleModel(
      id: 's9',
      studentId: 'st8',
      studentName: 'Tom Bradley',
      studentPermit: 'Permit #22394',
      instructorId: 'i3',
      instructorName: 'David Chen',
      vehicleId: 'v1',
      vehicleName: 'Toyota Corolla (A)',
      startTime: _dt(7, 9, 30),
      endTime: _dt(7, 11, 30),
      status: ScheduleStatus.scheduled,
    ),
    ScheduleModel(
      id: 's10',
      studentId: 'st1',
      studentName: 'James Doe',
      studentPermit: 'Permit #84920',
      instructorId: 'i2',
      instructorName: 'Mike Torres',
      vehicleId: 'v3',
      vehicleName: 'Ford Focus (A)',
      startTime: _dt(8, 14, 0),
      endTime: _dt(8, 16, 0),
      status: ScheduleStatus.cancelledByInstructor,
    ),
  ];

  static final _mockInstructors = [
    const ScheduleInstructorOption(id: 'i1', name: 'Sarah Jenkins'),
    const ScheduleInstructorOption(id: 'i2', name: 'Mike Torres'),
    const ScheduleInstructorOption(id: 'i3', name: 'David Chen'),
  ];

  static final _mockStudents = [
    const ScheduleStudentOption(id: 'st1', name: 'James Doe', permit: 'Permit #84920'),
    const ScheduleStudentOption(id: 'st2', name: 'Alice Smith', permit: 'Permit #93012'),
    const ScheduleStudentOption(id: 'st3', name: 'Emma Watson', permit: 'Permit #11204'),
    const ScheduleStudentOption(id: 'st4', name: 'Liam Neeson', permit: 'Permit #55490'),
    const ScheduleStudentOption(id: 'st5', name: 'Nina Patel', permit: 'Permit #32180'),
    const ScheduleStudentOption(id: 'st6', name: 'Carlos Rivera', permit: 'Permit #77661'),
    const ScheduleStudentOption(id: 'st7', name: 'Priya Mehta', permit: 'Permit #41230'),
    const ScheduleStudentOption(id: 'st8', name: 'Tom Bradley', permit: 'Permit #22394'),
  ];

  @override
  Future<List<ScheduleModel>> getSchedules({
    String? instructorId,
    String? studentId,
    ScheduleStatus? status,
    DateTimeRange? dateRange,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockSchedules.where((s) {
      if (instructorId != null && s.instructorId != instructorId) return false;
      if (studentId != null && s.studentId != studentId) return false;
      if (status != null && s.status != status) return false;
      if (dateRange != null) {
        final start = DateTime(
          dateRange.start.year, dateRange.start.month, dateRange.start.day,
        );
        final end = DateTime(
          dateRange.end.year, dateRange.end.month, dateRange.end.day, 23, 59, 59,
        );
        if (s.startTime.isBefore(start) || s.startTime.isAfter(end)) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<List<ScheduleInstructorOption>> getInstructors() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockInstructors;
  }

  @override
  Future<List<ScheduleStudentOption>> getStudents() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return _mockStudents;
  }
}
