import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../data/models/tag_model.dart';
import '../cubit/tags_cubit.dart';
import '../widgets/tag_form_dialog.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  late TextEditingController _searchController;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<TagsCubit>().listTags(
      activeOnly: false,
      pageNumber: _currentPage,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadTags() {
    _currentPage = 1;
    context.read<TagsCubit>().listTags(
      activeOnly: false,
      searchQuery: _searchController.text.isEmpty
          ? null
          : _searchController.text,
      pageNumber: _currentPage,
    );
  }

  void _nextPage(int totalPages) {
    if (_currentPage < totalPages) {
      _currentPage++;
      context.read<TagsCubit>().listTags(
        activeOnly: false,
        searchQuery: _searchController.text.isEmpty
            ? null
            : _searchController.text,
        pageNumber: _currentPage,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      context.read<TagsCubit>().listTags(
        activeOnly: false,
        searchQuery: _searchController.text.isEmpty
            ? null
            : _searchController.text,
        pageNumber: _currentPage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tags'), actions: []),
      body: Column(
        children: [
          // Search Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              spacing: 16,
              children: [
                Expanded(
                  child: CustomTextField(
                    labelText: 'Search Tags',
                    controller: _searchController,
                    hintText: 'Enter tag name...',
                    onChanged: (_) => _loadTags(),
                  ),
                ),
                CustomButton(
                  text: 'Add Tag',
                  onPressed: () => _showTagDialog(context),
                ),
              ],
            ),
          ),
          // Tags List
          Expanded(
            child: BlocBuilder<TagsCubit, TagsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (tags, currentPage, totalPages, searchQuery) =>
                      tags.isEmpty
                      ? const Center(child: Text('No tags found'))
                      : Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: tags.length,
                                itemBuilder: (context, index) {
                                  final tag = tags[index];
                                  return ListTile(
                                    title: Text(tag.name),
                                    subtitle: Text(tag.color ?? 'No color'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              _showTagDialog(context, tag),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            tag.isActive
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () => context
                                              .read<TagsCubit>()
                                              .setActiveStatus(
                                                tag.id!,
                                                !tag.isActive,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Pagination Controls
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(
                                    text: 'Previous',
                                    onPressed: _currentPage > 1
                                        ? () => _previousPage()
                                        : null,
                                  ),
                                  Text(
                                    'Page $_currentPage of $totalPages',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  CustomButton(
                                    text: 'Next',
                                    onPressed: _currentPage < totalPages
                                        ? () => _nextPage(totalPages)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  error: (message) => Center(child: Text('Error: $message')),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTagDialog(BuildContext context, [TagModel? existing]) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<TagsCubit>(),
        child: TagFormDialog(existing: existing),
      ),
    );
  }
}
