import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../utils/helpers/app_logger.dart';

abstract class StateCityRepository {
  Future<List<String>> getStates();
  Future<List<String>> getCities(String state);
}

class StateCityRepositoryImpl implements StateCityRepository {
  final _logger = AppLogger('StateCityRepository');

  Map<String, dynamic>? _cachedData;

  Future<Map<String, dynamic>> _loadStateCityData() async {
    if (_cachedData != null) {
      return _cachedData!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/state_city.json');
      _cachedData = jsonDecode(jsonString) as Map<String, dynamic>;
      _logger.info('State-City data loaded successfully');
      return _cachedData!;
    } catch (e, stackTrace) {
      _logger.error('Failed to load state-city data', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<String>> getStates() async {
    try {
      final data = await _loadStateCityData();
      final states = data.keys.toList();
      _logger.debug('Fetched ${states.length} states');
      return states;
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch states', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<List<String>> getCities(String state) async {
    try {
      final data = await _loadStateCityData();
      final cities = data[state] as List<dynamic>?;

      if (cities == null) {
        _logger.warning('No cities found for state: $state');
        return [];
      }

      final citiesList = cities.cast<String>().toList();
      _logger.debug('Fetched ${citiesList.length} cities for state: $state');
      return citiesList;
    } catch (e, stackTrace) {
      _logger.error('Failed to fetch cities for state: $state', e, stackTrace);
      rethrow;
    }
  }
}
