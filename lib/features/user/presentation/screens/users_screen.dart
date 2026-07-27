import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/paginated_list_view.dart';
import '../../../../utils/extensions/context_extensions.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../data/models/user_model.dart';
import '../cubit/user_cubit.dart';
import '../widgets/user_form_dialog.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _showActive = true;

  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().load(activeOnly: _showActive);
  }

  void _onFilterChanged(bool showActive) {
    setState(() => _showActive = showActive);
    context.read<UserCubit>().load(activeOnly: showActive);
  }

  Future<void> _openForm({UserModel? existing}) async {
    final cubit = context.read<UserCubit>();
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: cubit,
        child: UserFormDialog(existing: existing),
      ),
    );

    if (result == true && mounted) {
      context.showSuccessSnackBar('User saved successfully');
    }
  }

  Future<void> _toggleActive(UserModel user) async {
    final newStatus = !user.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(newStatus ? 'Activate User' : 'Deactivate User'),
        content: Text(
          'Are you sure you want to ${newStatus ? 'activate' : 'deactivate'} "${user.name}"?',
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
      await context.read<UserCubit>().setActiveStatus(user.id!, newStatus);
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
                  'Users',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _openForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add User'),
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
                cubit: context.read<UserCubit>(),
                emptyMessage: 'No active users found',
                emptyMessageInactive: 'No inactive users found',
                itemBuilder: (context, user) {
                  final subtitleParts = <String>[];
                  if (user.role != null) {
                    subtitleParts.add(user.role!.displayName);
                  }
                  if (user.phoneNumber != null) {
                    subtitleParts.add(user.phoneNumber!);
                  }
                  if (user.role == UserRole.student &&
                      user.vehicleTypeName != null) {
                    subtitleParts.add(user.vehicleTypeName!);
                  }
                  if (user.role == UserRole.instructor &&
                      user.licenseNumber != null) {
                    subtitleParts.add(user.licenseNumber!);
                  }

                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        user.role == UserRole.instructor
                            ? Icons.badge_outlined
                            : Icons.person_outline,
                      ),
                    ),
                    title: Text(user.name ?? '-'),
                    subtitle: Text(subtitleParts.join(' • ')),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _openForm(existing: user),
                        ),
                        IconButton(
                          icon: Icon(
                            user.isActive
                                ? Icons.person_remove_outlined
                                : Icons.person_add_outlined,
                          ),
                          tooltip: user.isActive ? 'Deactivate' : 'Activate',
                          onPressed: () => _toggleActive(user),
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
