import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../services/storage_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core Services
  final storageService = await StorageService.getInstance();
  sl.registerLazySingleton<StorageService>(() => storageService);

  // External Dependencies
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepoImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      storageService: sl(),
    ),
  );

  // Blocs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
}
