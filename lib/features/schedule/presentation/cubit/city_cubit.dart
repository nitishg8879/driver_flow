import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/repositories/state_city_repository.dart';

part 'city_cubit.freezed.dart';

@freezed
class CityCubitState with _$CityCubitState {
  const factory CityCubitState.initial() = _Initial;
  const factory CityCubitState.loading() = _Loading;
  const factory CityCubitState.success({required List<String> cities}) =
      _Success;
  const factory CityCubitState.error(String message) = _Error;
}

class CityCubit extends Cubit<CityCubitState> {
  final StateCityRepository _repository;

  CityCubit(this._repository) : super(const CityCubitState.initial());

  Future<void> loadCities(String state) async {
    try {
      emit(const CityCubitState.loading());
      final cities = await _repository.getCities(state);
      emit(CityCubitState.success(cities: cities));
    } catch (e) {
      emit(CityCubitState.error(e.toString()));
    }
  }

  void reset() {
    emit(const CityCubitState.initial());
  }
}
