import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/repositories/state_city_repository.dart';

part 'state_cubit.freezed.dart';

@freezed
class StateCubitState with _$StateCubitState {
  const factory StateCubitState.initial() = _Initial;
  const factory StateCubitState.loading() = _Loading;
  const factory StateCubitState.success({
    required List<String> states,
  }) = _Success;
  const factory StateCubitState.error(String message) = _Error;
}

class StateCubit extends Cubit<StateCubitState> {
  final StateCityRepository _repository;

  StateCubit(this._repository) : super(const StateCubitState.initial());

  Future<void> loadStates() async {
    try {
      emit(const StateCubitState.loading());
      final states = await _repository.getStates();
      emit(StateCubitState.success(states: states));
    } catch (e) {
      emit(StateCubitState.error(e.toString()));
    }
  }
}
