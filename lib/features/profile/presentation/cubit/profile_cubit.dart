import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/helpers/app_logger.dart';
import '../../data/models/holiday_model.dart';
import '../../data/models/organization_profile_model.dart';
import '../../data/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  final _logger = AppLogger('ProfileCubit');

  ProfileCubit({required this._repository})
    : super(const ProfileState.initial());

  Future<void> loadProfile() async {
    emit(const ProfileState.loading());
    try {
      _logger.info('Loading organization profile');
      final profile = await _repository.getOrganizationProfile();
      final holidays = await _repository.getHolidays();
      emit(ProfileState.loaded(profile: profile, holidays: holidays));
    } catch (e, stackTrace) {
      _logger.error('Failed to load profile', e, stackTrace);
      emit(ProfileState.error('Failed to load profile: $e'));
    }
  }

  Future<void> updateProfile(OrganizationProfileModel profile) async {
    try {
      _logger.info('Updating organization profile');
      final updated = await _repository.updateOrganizationProfile(profile);
      final holidays = await _repository.getHolidays();
      emit(ProfileState.loaded(profile: updated, holidays: holidays));
      _logger.debug('Profile updated successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to update profile', e, stackTrace);
      emit(ProfileState.error('Failed to update profile: $e'));
    }
  }

  Future<void> addHoliday(HolidayModel holiday) async {
    try {
      _logger.info('Adding holiday');
      await _repository.addHoliday(holiday);
      await loadProfile();
      _logger.debug('Holiday added successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to add holiday', e, stackTrace);
      emit(ProfileState.error('Failed to add holiday: $e'));
    }
  }

  Future<void> updateHoliday(HolidayModel holiday) async {
    try {
      _logger.info('Updating holiday');
      await _repository.updateHoliday(holiday);
      await loadProfile();
      _logger.debug('Holiday updated successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to update holiday', e, stackTrace);
      emit(ProfileState.error('Failed to update holiday: $e'));
    }
  }

  Future<void> deleteHoliday(String holidayId) async {
    try {
      _logger.info('Deleting holiday');
      await _repository.deleteHoliday(holidayId);
      await loadProfile();
      _logger.debug('Holiday deleted successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to delete holiday', e, stackTrace);
      emit(ProfileState.error('Failed to delete holiday: $e'));
    }
  }

  Future<void> markTodayAsHoliday(bool isHoliday, bool isHalfDay) async {
    try {
      _logger.info('Marking today: Holiday=$isHoliday, HalfDay=$isHalfDay');
      await _repository.markTodayAsHoliday(isHoliday, isHalfDay);
      await loadProfile();
      _logger.debug('Today status updated successfully');
    } catch (e, stackTrace) {
      _logger.error('Failed to mark today', e, stackTrace);
      emit(ProfileState.error('Failed to mark today: $e'));
    }
  }
}
