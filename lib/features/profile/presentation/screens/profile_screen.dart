import 'package:driver_flow_admin/features/profile/data/models/organization_profile_model.dart';
import 'package:driver_flow_admin/features/profile/data/repositories/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/profile_form_dialog.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileDataProvider);

    void showProfileDialog([OrganizationProfileModel? profile]) {
      final currentUser = FirebaseAuth.instance.currentUser;
      final profileWithEmail =
          profile ?? OrganizationProfileModel(email: currentUser?.email);
      showDialog(
        context: context,
        builder: (_) => ProfileFormDialog(
          existing: profileWithEmail,
          onSaved: () => ref.invalidate(profileDataProvider),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Profile'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => showProfileDialog(profileAsync.valueOrNull),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: profileAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(e.toString()),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.invalidate(profileDataProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (profile) {
            if (profile == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No profile created yet',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => showProfileDialog(),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Profile'),
                    ),
                  ],
                ),
              );
            }

            return _buildProfileCard(context, profile);
          },
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, OrganizationProfileModel profile) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile Information', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            _buildInfoRow('Organization Name', profile.organizationName ?? ''),
            const SizedBox(height: 12),
            _buildInfoRow('Phone Number', profile.phoneNumber ?? ''),
            const SizedBox(height: 12),
            _buildInfoRow('About Us', profile.aboutUs ?? ''),
            const SizedBox(height: 12),
            if (profile.officeStartTime != null || profile.officeEndTime != null) ...[
              _buildInfoRow(
                'Office Hours',
                '${_formatTime(profile.officeStartTime)} – ${_formatTime(profile.officeEndTime)}',
              ),
              const SizedBox(height: 12),
            ],
            if (profile.vechileStartTime != null || profile.vechileEndTime != null) ...[
              _buildInfoRow(
                'Vehicle Hours',
                '${_formatTime(profile.vechileStartTime)} – ${_formatTime(profile.vechileEndTime)}',
              ),
              const SizedBox(height: 12),
            ],
            if ((profile.workingDays ?? []).isNotEmpty) ...[
              const Text('Working Days', style: TextStyle(fontWeight: FontWeight.w600)),
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

  String _formatTime(TimeOfDay? t) {
    if (t == null) return 'N/A';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
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

}
