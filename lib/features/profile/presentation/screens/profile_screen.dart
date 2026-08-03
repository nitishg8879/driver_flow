import 'package:driver_flow_admin/features/profile/data/models/holiday_model.dart';
import 'package:driver_flow_admin/features/profile/data/models/organization_profile_model.dart';
import 'package:driver_flow_admin/utils/extensions/context_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/repositories/profile_repository.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/holiday_dialog.dart';
import '../widgets/profile_form_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showProfileDialog(
              context.read<ProfileCubit>().state.maybeWhen(
                loaded: (profile, _) => profile,
                orElse: () => null,
              ),
            ),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          bloc: context.read<ProfileCubit>(),
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (profile, holidays) {
                if (profile == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'No profile created yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _showProfileDialog,
                          icon: const Icon(Icons.add),
                          label: const Text('Create Profile'),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(profile),
                    const SizedBox(height: 32),
                    _buildHolidaysList(context, holidays),
                  ],
                );
              },
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ProfileCubit>().loadProfile(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              orElse: () => const Center(child: CircularProgressIndicator()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(OrganizationProfileModel profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Organization Name', profile.organizationName ?? ''),
            const SizedBox(height: 12),
            _buildInfoRow('Phone Number', profile.phoneNumber ?? ''),
            const SizedBox(height: 12),
            _buildInfoRow('About Us', profile.aboutUs ?? ''),
            const SizedBox(height: 12),
            if ((profile.websiteUrls ?? []).isNotEmpty) ...[
              const Text(
                'Website URLs',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...(profile.websiteUrls ?? []).map(
                (url) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '• $url',
                    style: TextStyle(
                      color: Colors.blue[700],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
            if ((profile.workingDays ?? []).isNotEmpty) ...[
              const Text(
                'Working Days',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: (profile.workingDays ?? [])
                    .map((day) => Chip(label: Text(day.displayName)))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label:', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 12),
        Expanded(child: Text(value)),
      ],
    );
  }

  Widget _buildHolidaysList(BuildContext context, List<HolidayModel> holidays) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Holidays (${holidays.length})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton.icon(
              onPressed: _showHolidayDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Holiday'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (holidays.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Text('No holidays added yet'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: holidays.length,
            itemBuilder: (context, index) {
              final holiday = holidays[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(holiday.label ?? 'N/A'),
                  subtitle: Text(holiday.date.toFormattedDate),
                  trailing: PopupMenuButton(
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        child: const Text('Edit'),
                        onTap: () => _showHolidayDialog(holiday),
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: () {
                          context.read<ProfileCubit>().deleteHoliday(
                            holiday.id!,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _showProfileDialog([OrganizationProfileModel? profile]) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final profileWithEmail =
        profile ?? OrganizationProfileModel(email: currentUser?.email);
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: ProfileFormDialog(existing: profileWithEmail),
      ),
    );
  }

  void _showHolidayDialog([HolidayModel? holiday]) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileCubit>(),
        child: HolidayDialog(existing: holiday),
      ),
    );
  }
}
