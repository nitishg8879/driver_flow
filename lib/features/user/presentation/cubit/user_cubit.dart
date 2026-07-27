import '../../../../core/bloc/paginated_cubit.dart';
import '../../../../core/bloc/paginated_repository.dart';
import '../../../../core/bloc/paginated_state.dart';
import '../../../../core/models/paginated_result.dart';
import '../../../../core/models/pagination_cursor.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../../utils/helpers/app_logger.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository.dart';

/// Cubit for the unified user feature.
///
/// Users are stored in a shared `users` collection, and different roles
/// (student/instructor/manager/driver/viewer) are represented using the
/// [UserModel.role] field.
class UserCubit extends PaginatedCubit<UserModel> {
  final UserRepository _userRepository;
  final _logger = AppLogger('UserCubit');

  UserCubit({required UserRepository userRepository})
    : _userRepository = userRepository,
      super(repository: AllUsersRepository(userRepository: userRepository));

  /// Load users with optional filters for search query and role
  Future<void> loadFiltered({
    bool activeOnly = true,
    String searchQuery = '',
    UserRole? role,
  }) async {
    emit(const PaginatedState.loading());
    try {
      final page = await _userRepository.getUsers(
        activeOnly: activeOnly,
        pageSize: pageSize,
        searchQuery: searchQuery,
        role: role,
      );
      emit(
        PaginatedState.loaded(
          items: page.items,
          hasMore: page.hasMore,
          activeOnly: activeOnly,
          totalCount: page.totalCount,
        ),
      );
    } catch (e, stackTrace) {
      _logger.error('Failed to load users', e, stackTrace);
      emit(PaginatedState.error(e.toString()));
    }
  }

  Future<UserModel?> createUser(UserModel user) async {
    try {
      final created = await _userRepository.createUser(user);
      await refresh();
      return created;
    } catch (e, stackTrace) {
      _logger.error('Failed to create user', e, stackTrace);
      return null;
    }
  }

  Future<UserModel?> updateUser(UserModel user) async {
    try {
      final updated = await _userRepository.updateUser(user);
      await refresh();
      return updated;
    } catch (e, stackTrace) {
      _logger.error('Failed to update user', e, stackTrace);
      return null;
    }
  }

  Future<bool> setActiveStatus(String id, bool isActive) async {
    try {
      await _userRepository.setActiveStatus(id, isActive);
      await refresh();
      return true;
    } catch (e, stackTrace) {
      _logger.error('Failed to update user status', e, stackTrace);
      return false;
    }
  }
}

class AllUsersRepository implements PaginatedRepository<UserModel> {
  final UserRepository userRepository;

  AllUsersRepository({required this.userRepository});

  @override
  Future<PaginatedResult<UserModel>> getPage({
    required bool activeOnly,
    required int pageSize,
    PaginationCursor? cursor,
  }) {
    return userRepository.getUsers(
      activeOnly: activeOnly,
      pageSize: pageSize,
      cursor: cursor,
    );
  }
}
