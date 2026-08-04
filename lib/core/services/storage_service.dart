import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/helpers/app_logger.dart';

/// Singleton service for local storage
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;
  final _logger = AppLogger('StorageService');

  StorageService._();

  static Future<StorageService> init() async {
    _instance ??= StorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  static StorageService getInstance() {
    if (_instance == null || _preferences == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _instance!;
  }

  // Keys
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _userIdKey = 'userId';
  static const String _userEmailKey = 'userEmail';

  // Getters
  bool get isLoggedIn => _preferences?.getBool(_isLoggedInKey) ?? false;
  String? get userId => _preferences?.getString(_userIdKey);
  String? get userEmail => _preferences?.getString(_userEmailKey);

  // Save login state
  Future<void> saveLoginState({
    required String userId,
    required String email,
  }) async {
    try {
      await _preferences?.setBool(_isLoggedInKey, true);
      await _preferences?.setString(_userIdKey, userId);
      await _preferences?.setString(_userEmailKey, email);
      _logger.info('Login state saved for user: $userId');
    } catch (e, stackTrace) {
      _logger.error('Failed to save login state', e, stackTrace);
    }
  }

  // Clear login state
  Future<void> clearLoginState() async {
    try {
      await _preferences?.remove(_isLoggedInKey);
      await _preferences?.remove(_userIdKey);
      await _preferences?.remove(_userEmailKey);
      _logger.info('Login state cleared');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear login state', e, stackTrace);
    }
  }

  // Clear all data
  Future<void> clearAll() async {
    try {
      await _preferences?.clear();
      await clearLoginState();
      _logger.info('All storage data cleared');
    } catch (e, stackTrace) {
      _logger.error('Failed to clear storage', e, stackTrace);
    }
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService.getInstance();
});
