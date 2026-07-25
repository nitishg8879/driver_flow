import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/paginated_list_view.dart';
import '../../../../utils/extensions/context_extensions.dart';
import '../../../auth/data/models/user_model.dart';
import '../cubit/student_cubit.dart';
import '../widgets/student_form_dialog.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  bool _showActive = true;

  @override
  void initState() {
    super.initState();
    context.read<StudentCubit>().load(activeOnly: _showActive);
  }

  void _onFilterChanged(bool showActive) {
    setState(() => _showActive = showActive);
    context.read<StudentCubit>().load(activeOnly: showActive);
  }

  Future<void> _openForm({UserModel? existing}) async {
    final cubit = context.read<StudentCubit>();
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: StudentFormDialog(existing: existing),
      ),
    );

    if (result == true && mounted) {
      context.showSuccessSnackBar('Student saved successfully');
    }
  }

  Future<void> _toggleActive(UserModel student) async {
    final newStatus = !student.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(newStatus ? 'Activate Student' : 'Deactivate Student'),
        content: Text(
          'Are you sure you want to ${newStatus ? 'activate' : 'deactivate'} "${student.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<StudentCubit>().setActiveStatus(
        student.id!,
        newStatus,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Students',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Student'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Active')),
                ButtonSegment(value: false, label: Text('Inactive')),
              ],
              selected: {_showActive},
              onSelectionChanged: (selection) =>
                  _onFilterChanged(selection.first),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PaginatedListView<UserModel>(
                cubit: context.read<StudentCubit>(),
                emptyMessage: 'No active students found',
                emptyMessageInactive: 'No inactive students found',
                itemBuilder: (context, student) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person_outline),
                    ),
                    title: Text(student.name ?? '-'),
                    subtitle: Text(
                      '${student.phoneNumber} • ${student.vehicleTypeName ?? '-'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _openForm(existing: student),
                        ),
                        IconButton(
                          icon: Icon(
                            student.isActive
                                ? Icons.person_remove_outlined
                                : Icons.person_add_outlined,
                          ),
                          tooltip: student.isActive ? 'Deactivate' : 'Activate',
                          onPressed: () => _toggleActive(student),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
