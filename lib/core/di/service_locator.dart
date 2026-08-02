import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_flow_admin/features/schedule/data/repositories/onboarding_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/user/data/repositories/user_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/schedule/data/repositories/schedule_repository.dart';
import '../../features/schedule/presentation/cubit/schedule_cubit.dart';
import '../../features/user/presentation/cubit/user_cubit.dart';
import '../../features/vehicle_type/data/repositories/vehicle_type_repository.dart';
import '../../features/vehicle_type/presentation/cubit/vehicle_type_cubit.dart';
import '../../features/tags/data/repositories/tag_repository.dart';
import '../../features/tags/presentation/cubit/tags_cubit.dart';
import '../../features/payment/data/repositories/payment_repository.dart';
import '../../features/payment/presentation/cubit/payment_cubit.dart';
import '../../features/profile/data/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/schedule/presentation/cubit/onboarding_cubit.dart';
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
  sl.registerLazySingleton<ScheduleRepository>(
    () => ScheduleRepositoryImpl(),
  );
  sl.registerLazySingleton<TagRepository>(
    () => TagRepositoryImpl(firestore: sl()),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(firestore: sl(), storage: sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(firestore: sl()),
  );

  // Blocs / Cubits
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => VehicleTypeCubit(repository: sl()));
  sl.registerFactory(() => UserCubit(userRepository: sl()));
  sl.registerFactory(() => ScheduleCubit(repository: sl()));
  sl.registerFactory(() => TagsCubit(repository: sl()));
  sl.registerFactory(() => PaymentCubit(repository: sl()));
  sl.registerFactory(() => ProfileCubit(repository: sl()));
  sl.registerFactory(() => OnboardingCubit(repository: sl()));
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(),
  );
}
