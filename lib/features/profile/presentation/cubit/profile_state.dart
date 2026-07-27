import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/holiday_model.dart';
import '../../data/models/organization_profile_model.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState.initial() = _Initial;
  const factory ProfileState.loading() = _Loading;
  const factory ProfileState.loaded({
    required OrganizationProfileModel? profile,
    required List<HolidayModel> holidays,
  }) = _Loaded;
  const factory ProfileState.error(String message) = _Error;
}
