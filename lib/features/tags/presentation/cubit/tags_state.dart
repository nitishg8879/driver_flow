part of 'tags_cubit.dart';

@freezed
class TagsState with _$TagsState {
  const factory TagsState.initial() = _Initial;
  const factory TagsState.loading() = _Loading;
  const factory TagsState.loaded(
    List<TagModel> tags, {
    @Default(1) int currentPage,
    @Default(1) int totalPages,
    @Default('') String searchQuery,
  }) = _Loaded;
  const factory TagsState.error(String message) = _Error;
}
