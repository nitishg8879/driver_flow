import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/paginated_list_view.dart';
import '../../../../utils/extensions/context_extensions.dart';
import '../../../auth/data/models/user_model.dart';
import '../cubit/instructor_cubit.dart';
import '../widgets/instructor_form_dialog.dart';

class InstructorsScreen extends StatefulWidget {
  const InstructorsScreen({super.key});

  @override
  State<InstructorsScreen> createState() => _InstructorsScreenState();
}

class _InstructorsScreenState extends State<InstructorsScreen> {
  bool _showActive = true;

  @override
  void initState() {
    super.initState();
    context.read<InstructorCubit>().load(activeOnly: _showActive);
  }

  void _onFilterChanged(bool showActive) {
    setState(() => _showActive = showActive);
    context.read<InstructorCubit>().load(activeOnly: showActive);
  }

  Future<void> _openForm({UserModel? existing}) async {
    final cubit = context.read<InstructorCubit>();
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: InstructorFormDialog(existing: existing),
      ),
    );

    if (result == true && mounted) {
      context.showSuccessSnackBar('Instructor saved successfully');
    }
  }

  Future<void> _toggleActive(UserModel instructor) async {
    final newStatus = !instructor.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          newStatus ? 'Activate Instructor' : 'Deactivate Instructor',
        ),
        content: Text(
          'Are you sure you want to ${newStatus ? 'activate' : 'deactivate'} "${instructor.name}"?',
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
      await context.read<InstructorCubit>().setActiveStatus(
        instructor.id!,
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
                  'Instructors',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Instructor'),
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
                cubit: context.read<InstructorCubit>(),
                emptyMessage: 'No active instructors found',
                emptyMessageInactive: 'No inactive instructors found',
                itemBuilder: (context, instructor) {
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.badge_outlined),
                    ),
                    title: Text(instructor.name ?? '-'),
                    subtitle: Text(
                      '${instructor.phoneNumber}${instructor.licenseNumber != null ? ' • ${instructor.licenseNumber}' : ''}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _openForm(existing: instructor),
                        ),
                        IconButton(
                          icon: Icon(
                            instructor.isActive
                                ? Icons.person_remove_outlined
                                : Icons.person_add_outlined,
                          ),
                          tooltip: instructor.isActive
                              ? 'Deactivate'
                              : 'Activate',
                          onPressed: () => _toggleActive(instructor),
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
