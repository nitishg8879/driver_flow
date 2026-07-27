import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../models/holiday_model.dart';
import '../models/organization_profile_model.dart';

abstract class ProfileRepository {
  Future<OrganizationProfileModel?> getOrganizationProfile();
  Future<OrganizationProfileModel> updateOrganizationProfile(
    OrganizationProfileModel profile,
  );
  Future<List<HolidayModel>> getHolidays();
  Future<HolidayModel> addHoliday(HolidayModel holiday);
  Future<HolidayModel> updateHoliday(HolidayModel holiday);
  Future<void> deleteHoliday(String holidayId);
  Future<void> markTodayAsHoliday(bool isHoliday, bool isHalfDay);
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

  @override
  Future<List<HolidayModel>> getHolidays() async {
    try {
      const profileId = 'profile';
      final snapshot = await _collection
          .doc(profileId)
          .collection(AppConstants.holidaysSubcollection)
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => HolidayModel.fromJson({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch holidays', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<HolidayModel> addHoliday(HolidayModel holiday) async {
    try {
      const profileId = 'profile';
      final now = DateTime.now();
      final docRef = await _collection
          .doc(profileId)
          .collection(AppConstants.holidaysSubcollection)
          .add({...holiday.toJson(), 'createdAt': now, 'updatedAt': now});
      _logger.info('Holiday added: ${docRef.id}');
      return holiday.copyWith(id: docRef.id, createdAt: now, updatedAt: now);
    } catch (e, stackTrace) {
      _logger.error('Failed to add holiday', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<HolidayModel> updateHoliday(HolidayModel holiday) async {
    try {
      const profileId = 'profile';
      final now = DateTime.now();
      await _collection
          .doc(profileId)
          .collection(AppConstants.holidaysSubcollection)
          .doc(holiday.id)
          .update({...holiday.toJson(), 'updatedAt': now});
      _logger.info('Holiday updated: ${holiday.id}');
      return holiday.copyWith(updatedAt: now);
    } catch (e, stackTrace) {
      _logger.error('Failed to update holiday', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteHoliday(String holidayId) async {
    try {
      const profileId = 'profile';
      await _collection
          .doc(profileId)
          .collection(AppConstants.holidaysSubcollection)
          .doc(holidayId)
          .delete();
      _logger.info('Holiday deleted: $holidayId');
    } catch (e, stackTrace) {
      _logger.error('Failed to delete holiday', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> markTodayAsHoliday(bool isHoliday, bool isHalfDay) async {
    try {
      const profileId = 'profile';
      await _collection.doc(profileId).update({
        'isHolidayToday': isHoliday,
        'isHalfDayToday': isHalfDay,
        'updatedAt': DateTime.now(),
      });
      _logger.info(
        'Today status updated: Holiday=$isHoliday, HalfDay=$isHalfDay',
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to mark today as holiday', e, stackTrace);
      rethrow;
    }
  }
}
