import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/services/storage_service.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../../../user/data/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Stream<User?> get authStateChanges;
}

class FirebaseAuthRepoImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final StorageService _storageService;
  final _logger = AppLogger('FirebaseAuthRepo');

  FirebaseAuthRepoImpl({
    required this._firebaseAuth,
    required this._firestore,
    required this._storageService,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      _logger.info('Attempting login for email: $email');

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        _logger.error('Login failed: User credential is null');
        throw Exception('Login failed');
      }

      _logger.debug(
        'Fetching user data from Firestore for UID: ${userCredential.user!.uid}',
      );

      // Fetch user data from Firestore
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        _logger.error(
          'User data not found in Firestore for UID: ${userCredential.user!.uid}',
        );
        throw Exception('User data not found');
      }

      final user = UserModel.fromJson({'id': userDoc.id, ...userDoc.data()!});

      // Save login state to storage
      if (user.id == null || user.email == null) {
        _logger.error('User ID or email is null, cannot save login state');
        throw Exception('Invalid user data');
      }
      await _storageService.saveLoginState(
        userId: user.id!,
        email: user.email!,
      );

      _logger.info('Login successful for user: ${userCredential.user!.uid}');
      return user;
    } on FirebaseAuthException catch (e) {
      _logger.error(
        'Firebase authentication error: ${e.code}',
        e,
        e.stackTrace,
      );
      throw _handleAuthException(e);
    } catch (e, stackTrace) {
      _logger.error('Login error', e, stackTrace);
      throw Exception('An error occurred during login: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      _logger.info('Logging out user');
      await _firebaseAuth.signOut();
      await _storageService.clearLoginState();
      _logger.info('Logout successful');
    } catch (e, stackTrace) {
      _logger.error('Logout error', e, stackTrace);
      throw Exception('An error occurred during logout: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        _logger.debug('No current user found');
        return null;
      }

      _logger.debug('Fetching current user data for UID: ${currentUser.uid}');

      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        _logger.warning('Current user document not found in Firestore');
        return null;
      }

      _logger.debug('Current user data fetched successfully');
      return UserModel.fromJson({'id': userDoc.id, ...userDoc.data()!});
    } catch (e, stackTrace) {
      _logger.error('Error fetching current user', e, stackTrace);
      throw Exception('An error occurred while fetching user: ${e.toString()}');
    }
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This user account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return 'An authentication error occurred: ${e.message}';
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepoImpl(
    firebaseAuth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    storageService: ref.watch(storageServiceProvider),
  );
});
