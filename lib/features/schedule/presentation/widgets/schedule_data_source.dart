import 'package:data_table_2/data_table_2.dart';
import 'package:driver_flow_admin/core/di/service_locator.dart';
import 'package:driver_flow_admin/features/schedule/data/repositories/schedule_repository.dart';
import 'package:driver_flow_admin/utils/components/app_data_table.dart';
import 'package:driver_flow_admin/utils/constants/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StudentsSessionTable extends StatelessWidget {
  const StudentsSessionTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppDataTable(
        minWidth: 900,
        columns: const [
          DataColumn2(label: Text('Date & Time'), size: ColumnSize.L),
          DataColumn2(label: Text('Student'), size: ColumnSize.M),
          DataColumn2(label: Text('Instructor'), size: ColumnSize.M),
          DataColumn2(label: Text('Vehicle'), size: ColumnSize.M),
          DataColumn2(label: Text('Status'), size: ColumnSize.S),
          DataColumn2(label: Text('Actions'), fixedWidth: 72),
        ],
        source: ScheduleDataSource(theme: Theme.of(context)),
      ),
    );
  }
}

class ScheduleDataSource extends AsyncDataTableSource {
  final ThemeData _theme;

  ScheduleDataSource({required this._theme});

  static final _dateFmt = DateFormat('MMM d, yyyy');
  static final _timeFmt = DateFormat('h:mm a');

  static Widget _statusChip(ScheduleStatus status) {
    final (textColor, bgColor) = switch (status) {
      ScheduleStatus.scheduled => (
        const Color(0xFF1565C0),
        const Color(0xFFE3F2FD),
      ),
      ScheduleStatus.completed => (
        const Color(0xFF2E7D32),
        const Color(0xFFE8F5E9),
      ),
      _ => (const Color(0xFFC62828), const Color(0xFFFFEBEE)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.25)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  @override
  Future<AsyncRowsResponse> getRows(int startIndex, int count) async {
    final allSchedules = await sl<ScheduleRepository>().getSchedules();
    
    final endIndex = startIndex + count;
    final paginatedSchedules = allSchedules.sublist(
      startIndex,
      endIndex > allSchedules.length ? allSchedules.length : endIndex,
    );
    
    return AsyncRowsResponse(
      allSchedules.length,
      paginatedSchedules.map((s) {
        return DataRow2(
          cells: [
            DataCell(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _dateFmt.format(s.startTime),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_timeFmt.format(s.startTime)} – ${_timeFmt.format(s.endTime)}',
                    style: _theme.textTheme.bodySmall?.copyWith(
                      color: _theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            DataCell(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.studentName,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    s.studentPermit,
                    style: _theme.textTheme.bodySmall?.copyWith(
                      color: _theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            DataCell(
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.indigo[50],
                    child: Text(
                      s.instructorName[0],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.indigo[700],
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      s.instructorName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            DataCell(Text(s.vehicleName, overflow: TextOverflow.ellipsis)),
            DataCell(_statusChip(s.status)),
            DataCell(
              PopupMenuButton<String>(
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'view', child: Text('View Details')),
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'cancel', child: Text('Cancel')),
                ],
                icon: Icon(
                  Icons.more_vert,
                  size: 18,
                  color: _theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
