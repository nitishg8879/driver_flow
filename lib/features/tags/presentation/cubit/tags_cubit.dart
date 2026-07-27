import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/tag_model.dart';
import '../../data/repositories/tag_repository.dart';

part 'tags_cubit.freezed.dart';
part 'tags_state.dart';

class TagsCubit extends Cubit<TagsState> {
  final TagRepository repository;
  static const int pageSize = 20;

  TagsCubit({required this.repository}) : super(const TagsState.initial());

  Future<void> listTags({
    bool activeOnly = true,
    String? searchQuery,
    int pageNumber = 1,
  }) async {
    try {
      emit(const TagsState.loading());
      final tags = await repository.getTags(
        activeOnly: activeOnly,
        searchQuery: searchQuery,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );
      final totalCount = await repository.getTagsCount(
        activeOnly: activeOnly,
        searchQuery: searchQuery,
      );
      final totalPages = (totalCount / pageSize).ceil();
      emit(
        TagsState.loaded(
          tags,
          currentPage: pageNumber,
          totalPages: totalPages,
          searchQuery: searchQuery ?? '',
        ),
      );
    } catch (e) {
      emit(TagsState.error(e.toString()));
    }
  }

  Future<String?> createTag(TagModel tag) async {
    try {
      await repository.createTag(tag);
      // Reload tags after creation
      await listTags(activeOnly: false);
      return null; // No error
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> updateTag(TagModel tag) async {
    try {
      await repository.updateTag(tag);
      // Reload tags after update
      await listTags(activeOnly: false);
      return null; // No error
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> setActiveStatus(String id, bool isActive) async {
    try {
      await repository.setActiveStatus(id, isActive);
      // Reload tags after status change
      await listTags(activeOnly: false);
      return null; // No error
    } catch (e) {
      return e.toString();
    }
  }
}
