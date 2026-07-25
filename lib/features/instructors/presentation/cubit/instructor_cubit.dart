import '../../../../core/bloc/paginated_cubit.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/repositories/role_scoped_user_repository.dart';
import '../../../auth/data/repositories/user_repository.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/helpers/app_logger.dart';

/// Instructor list cubit built on top of the generic [PaginatedCubit].
/// Instructors are [UserModel] records with `role == UserRole.instructor`
/// — there is no separate Instructor model/collection.
class InstructorCubit extends PaginatedCubit<UserModel> {
  final UserRepository _userRepository;
  final _logger = AppLogger('InstructorCubit');

  InstructorCubit({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(
        repository: RoleScopedUserRepository(
          userRepository: userRepository,
          role: UserRole.instructor,
        ),
      );

  Future<UserModel?> createInstructor(UserModel instructor) async {
    try {
      final created = await _userRepository.createUser(
        instructor.copyWith(role: UserRole.instructor),
      );
      await refresh();
      return created;
    } catch (e, stackTrace) {
      _logger.error('Failed to create instructor', e, stackTrace);
      return null;
    }
  }

  Future<UserModel?> updateInstructor(UserModel instructor) async {
    try {
      final updated = await _userRepository.updateUser(instructor);
      await refresh();
      return updated;
    } catch (e, stackTrace) {
      _logger.error('Failed to update instructor', e, stackTrace);
      return null;
    }
  }

  Future<bool> setActiveStatus(String id, bool isActive) async {
    try {
      await _userRepository.setActiveStatus(id, isActive);
      await refresh();
      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to update instructor status', e, stackTrace);
      return false;
    }
  }
}
