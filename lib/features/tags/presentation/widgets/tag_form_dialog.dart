import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../data/models/tag_model.dart';
import '../../data/repositories/tag_repository.dart';

class TagFormDialog extends HookConsumerWidget {
  final TagModel? existing;

  const TagFormDialog({super.key, this.existing});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController(text: existing?.name ?? '');
    final colorController = useTextEditingController(
      text: existing?.color ?? '',
    );
    final isSaving = useState(false);
    final errorMessage = useState<String?>(null);

    final isEditMode = existing != null;
    final repository = sl<TagRepository>();

    Future<void> submit() async {
      if (nameController.text.trim().isEmpty) {
        errorMessage.value = 'Please enter a tag name';
        return;
      }

      isSaving.value = true;
      errorMessage.value = null;

      try {
        final model = (existing ?? TagModel(name: '')).copyWith(
          name: nameController.text.trim(),
          color: colorController.text.trim().isEmpty
              ? null
              : colorController.text.trim(),
        );

        if (isEditMode) {
          await repository.updateTag(model);
        } else {
          await repository.createTag(model);
        }

        if (context.mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        errorMessage.value = e.toString();
        isSaving.value = false;
      }
    }

    return AlertDialog(
      title: Text(isEditMode ? 'Edit Tag' : 'Add Tag'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (errorMessage.value != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  errorMessage.value!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
              const SizedBox(height: 16),
            ],
            CustomTextField(
              labelText: 'Tag Name',
              controller: nameController,
              hintText: 'Enter tag name',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Color (Optional)',
              controller: colorController,
              hintText: 'Enter color code or name',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving.value ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        CustomButton(
          text: isEditMode ? 'Update' : 'Create',
          onPressed: isSaving.value ? null : submit,
        ),
      ],
    );
  }
}
