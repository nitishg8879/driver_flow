import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/data/repositories/user_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/instructors/presentation/cubit/instructor_cubit.dart';
import '../../features/schedule/data/repositories/schedule_repository.dart';
import '../../features/schedule/presentation/cubit/schedule_cubit.dart';
import '../../features/students/presentation/cubit/student_cubit.dart';
import '../../features/vehicle_type/data/repositories/vehicle_type_repository.dart';
import '../../features/vehicle_type/presentation/cubit/vehicle_type_cubit.dart';
import '../../features/vehicles/data/repositories/vehicle_repository.dart';
import '../../features/vehicles/presentation/cubit/vehicle_cubit.dart';
import '../services/attachment_service.dart';
import '../services/storage_service.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core Services
  final storageService = await StorageService.getInstance();
  sl.registerLazySingleton<StorageService>(() => storageService);

  // External Dependencies
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // Shared Services
  sl.registerLazySingleton<AttachmentService>(
    () => AttachmentService(firestore: sl(), storage: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepoImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      storageService: sl(),
    ),
  );
  sl.registerLazySingleton<VehicleTypeRepository>(
    () => VehicleTypeRepositoryImpl(firestore: sl(), storage: sl()),
  );
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(firestore: sl()),
  );
  sl.registerLazySingleton<VehicleRepository>(
    () => VehicleRepositoryImpl(firestore: sl()),
  );
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(firestore: sl()),
  );

  // Blocs / Cubits
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => VehicleTypeCubit(repository: sl()));
  sl.registerFactory(() => StudentCubit(userRepository: sl()));
  sl.registerFactory(() => VehicleCubit(repository: sl()));
  sl.registerFactory(() => InstructorCubit(userRepository: sl()));
  sl.registerFactory(() => ScheduleCubit(repository: sl()));
}
