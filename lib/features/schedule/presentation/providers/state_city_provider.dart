import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/state_city_repository.dart';

final stateCityRepositoryProvider = Provider<StateCityRepository>((ref) {
  return StateCityRepositoryImpl();
});

final statesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(stateCityRepositoryProvider);
  return repository.getStates();
});

final citiesProvider = FutureProvider.family<List<String>, String>((ref, state) async {
  final repository = ref.watch(stateCityRepositoryProvider);
  return repository.getCities(state);
});
