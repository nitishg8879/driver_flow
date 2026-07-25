import '../../../../core/bloc/paginated_repository.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/pagination_cursor.dart';
import '../../../../utils/constants/app_enums.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

/// Adapts [UserRepository] to [PaginatedRepository]&lt;[UserModel]&gt; for a
/// fixed [role], so feature cubits (StudentCubit, InstructorCubit) can
/// extend the generic [PaginatedCubit] while all of them share the same
/// underlying `users` collection.
class RoleScopedUserRepository implements PaginatedRepository<UserModel> {
  final UserRepository userRepository;
  final UserRole role;

  RoleScopedUserRepository({required this.userRepository, required this.role});

  @override
  Future<PaginatedResult<UserModel>> getPage({
    required bool activeOnly,
    required int pageSize,
    PaginationCursor? cursor,
  }) {
    return userRepository.getUsersByRole(
      role: role,
      activeOnly: activeOnly,
      pageSize: pageSize,
      cursor: cursor,
    );
  }
}
