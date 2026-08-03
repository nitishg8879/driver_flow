import 'package:driver_flow_admin/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../utils/extensions/context_extensions.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';
import '../widgets/user_form_dialog.dart';
import '../widgets/users_table.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late UsersTable userTable;
  @override
  void initState() {
    super.initState();
    userTable = UsersTable(role: null, activeOnly: true, searchQuery: '');
  }

  Future<void> _openForm({UserModel? existing}) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => UserFormDialog(existing: existing),
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
      await sl<UserRepository>().setActiveStatus(user.id!, newStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          userTable = UsersTable(
            role: state.role,
            activeOnly: state.activeOnly ?? true,
            searchQuery: state.searchQuery ?? '',
          );
        },
        builder: (context, state) {
          return Padding(
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
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        onChanged: (value) {
                          context.read<UserCubit>().applyFilters(
                            searchQuery: value,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Search by name...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownMenu<UserRole?>(
                        initialSelection: state.role,
                        onSelected: (role) {
                          context.read<UserCubit>().applyFilters(role: role);
                        },
                        dropdownMenuEntries: [
                          const DropdownMenuEntry<UserRole?>(
                            value: null,
                            label: 'All Roles',
                          ),
                          ...UserRole.values.map(
                            (role) => DropdownMenuEntry<UserRole?>(
                              value: role,
                              label: role.displayName,
                            ),
                          ),
                        ],
                        label: const Text('Role'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: true, label: Text('Active')),
                    ButtonSegment(value: false, label: Text('Inactive')),
                  ],
                  selected: {state.activeOnly ?? true},
                  onSelectionChanged: (selection) => context
                      .read<UserCubit>()
                      .applyFilters(activeOnly: selection.first),
                ),
                const SizedBox(height: 16),
                userTable,
              ],
            ),
          );
        },
      ),
    );
  }
}
