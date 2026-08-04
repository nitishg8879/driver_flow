import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/organization_profile_model.dart';

part 'profile_repository.g.dart';

abstract class ProfileRepository {
  Future<OrganizationProfileModel?> getOrganizationProfile();
  Future<OrganizationProfileModel> updateOrganizationProfile(
    OrganizationProfileModel profile,
  );
}

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore;
  final _logger = AppLogger('ProfileRepository');

  ProfileRepositoryImpl({required this._firestore});

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(AppConstants.organizationCollection);

  @override
  Future<OrganizationProfileModel?> getOrganizationProfile() async {
    try {
      const profileId = 'profile';
      final doc = await _collection.doc(profileId).get();
      if (!doc.exists) return null;
      return OrganizationProfileModel.fromJson({
        'id': doc.id,
        ...doc.data() ?? {},
      });
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch organization profile', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<OrganizationProfileModel> updateOrganizationProfile(
    OrganizationProfileModel profile,
  ) async {
    try {
      const profileId = 'profile';
      final now = DateTime.now();
      final data = {...profile.toJson(), 'updatedAt': now};
      await _collection.doc(profileId).set(data, SetOptions(merge: true));
      _logger.info('Organization profile updated');
      return profile.copyWith(updatedAt: now);
    } catch (e, stackTrace) {
      _logger.error('Failed to update organization profile', e, stackTrace);
      rethrow;
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(firestore: FirebaseFirestore.instance),
);

@riverpod
Future<OrganizationProfileModel?> profileData(Ref ref) async {
  final repo = ref.read(profileRepositoryProvider);
  return await repo.getOrganizationProfile();
}
