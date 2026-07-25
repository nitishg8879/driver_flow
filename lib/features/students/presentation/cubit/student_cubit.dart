import '../../../../core/bloc/paginated_cubit.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/data/repositories/role_scoped_user_repository.dart';
import '../../../auth/data/repositories/user_repository.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/helpers/app_logger.dart';

/// Student list cubit built on top of the generic [PaginatedCubit].
/// Students are [UserModel] records with `role == UserRole.student` —
/// there is no separate Student model/collection. Adds student-specific
/// mutations (create/update/setActiveStatus) that refresh the paginated
/// list afterwards.
class StudentCubit extends PaginatedCubit<UserModel> {
  final UserRepository _userRepository;
  final _logger = AppLogger('StudentCubit');

  StudentCubit({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(
        repository: RoleScopedUserRepository(
          userRepository: userRepository,
          role: UserRole.student,
        ),
      );

  Future<UserModel?> createStudent(UserModel student) async {
    try {
      final created = await _userRepository.createUser(
        student.copyWith(role: UserRole.student),
      );
      await refresh();
      return created;
    } catch (e, stackTrace) {
      _logger.error('Failed to create student', e, stackTrace);
      return null;
    }
  }

  Future<UserModel?> updateStudent(UserModel student) async {
    try {
      final updated = await _userRepository.updateUser(student);
      await refresh();
      return updated;
    } catch (e, stackTrace) {
      _logger.error('Failed to update student', e, stackTrace);
      return null;
    }
  }

  Future<bool> setActiveStatus(String id, bool isActive) async {
    try {
      await _userRepository.setActiveStatus(id, isActive);
      await refresh();
      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to update student status', e, stackTrace);
      return false;
    }
  }
}
