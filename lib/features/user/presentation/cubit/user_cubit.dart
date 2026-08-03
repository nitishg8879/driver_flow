import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_flow_admin/features/user/data/repositories/user_repository.dart';
import 'package:driver_flow_admin/utils/constants/app_enums.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;
  UserCubit(this._userRepository) : super(UserState(null));

  void updateLastDocument(DocumentSnapshot? lastDocument) {
    emit(UserState(lastDocument));
  }

  void applyFilters({
    bool? activeOnly,
    UserRole? role,
    String searchQuery = '',
  }) {
    emit(
      UserState(
        null,
        activeOnly: activeOnly,
        role: role,
        searchQuery: searchQuery,
      ),
    );
  }
}

class UserState {
  final DocumentSnapshot? lastDocument;
  final bool? activeOnly;
  final UserRole? role;
  final String searchQuery;
  const UserState(
    this.lastDocument, {
    this.activeOnly = true,
    this.role,
    this.searchQuery = '',
  });

  factory UserState.empty() {
    return const UserState(null);
  }

  UserState copyWith({
    DocumentSnapshot? lastDocument,
    bool? activeOnly,
    UserRole? role,
    String? searchQuery,
  }) {
    return UserState(
      lastDocument ?? this.lastDocument,
      activeOnly: activeOnly ?? this.activeOnly,
      role: role ?? this.role,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
