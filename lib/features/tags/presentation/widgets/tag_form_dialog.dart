import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../data/models/tag_model.dart';
import '../cubit/tags_cubit.dart';

class TagFormDialog extends StatefulWidget {
  final TagModel? existing;

  const TagFormDialog({super.key, this.existing});

  @override
  State<TagFormDialog> createState() => _TagFormDialogState();
}

class _TagFormDialogState extends State<TagFormDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _colorController;
  bool _isSaving = false;
  String? _errorMessage;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existing?.name ?? '');
    _colorController = TextEditingController(
      text: widget.existing?.color ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _errorMessage = 'Please enter a tag name');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    final cubit = context.read<TagsCubit>();
    final model = (widget.existing ?? TagModel(name: '')).copyWith(
      name: _nameController.text.trim(),
      color: _colorController.text.trim().isEmpty
          ? null
          : _colorController.text.trim(),
    );

    final error = _isEditMode
        ? await cubit.updateTag(model)
        : await cubit.createTag(model);

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _errorMessage = error;
        _isSaving = false;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditMode ? 'Edit Tag' : 'Add Tag'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
              const SizedBox(height: 16),
            ],
            CustomTextField(
              labelText: 'Tag Name',
              controller: _nameController,
              hintText: 'Enter tag name',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              labelText: 'Color (Optional)',
              controller: _colorController,
              hintText: 'Enter color code or name',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        CustomButton(
          text: _isEditMode ? 'Update' : 'Create',
          onPressed: _isSaving ? null : _submit,
        ),
      ],
    );
  }
}
