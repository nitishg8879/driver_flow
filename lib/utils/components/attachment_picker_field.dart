import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/models/attachment_model.dart';
import '../constants/app_enums.dart';

/// Represents a file the user picked but has not uploaded yet.
class PendingAttachment {
  final String fileName;
  final Uint8List bytes;
  final AttachmentFileType fileType;

  PendingAttachment({
    required this.fileName,
    required this.bytes,
    required this.fileType,
  });
}

/// A form field that lets the user pick files, tag each with an
/// [AttachmentFileType], preview already-uploaded attachments (edit mode)
/// and remove any of them before submitting the parent form.
///
/// This widget only manages picking/removing locally — actual upload is
/// left to the caller (e.g. on Save) via [pendingAttachments] /
/// [existingAttachments] getters through the [onChanged] callback.
class AttachmentPickerField extends StatefulWidget {
  final List<AttachmentModel> initialAttachments;
  final void Function(
    List<AttachmentModel> existingAttachments,
    List<PendingAttachment> pendingAttachments,
  )
  onChanged;
  final bool enabled;

  const AttachmentPickerField({
    super.key,
    required this.onChanged,
    this.initialAttachments = const [],
    this.enabled = true,
  });

  @override
  State<AttachmentPickerField> createState() => _AttachmentPickerFieldState();
}

class _AttachmentPickerFieldState extends State<AttachmentPickerField> {
  late List<AttachmentModel> _existingAttachments;
  final List<PendingAttachment> _pendingAttachments = [];

  @override
  void initState() {
    super.initState();
    _existingAttachments = List.of(widget.initialAttachments);
  }

  void _notify() {
    widget.onChanged(_existingAttachments, _pendingAttachments);
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.isEmpty) return;

    final picked = result.files.single;
    if (picked.bytes == null) return;

    if (!mounted) return;

    final fileType = await _askFileType(context);
    if (fileType == null) return;

    setState(() {
      _pendingAttachments.add(
        PendingAttachment(
          fileName: picked.name,
          bytes: picked.bytes!,
          fileType: fileType,
        ),
      );
    });
    _notify();
  }

  Future<AttachmentFileType?> _askFileType(BuildContext context) {
    return showDialog<AttachmentFileType>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Document Type'),
          children: AttachmentFileType.values.map((type) {
            return SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(type),
              child: Text(type.displayName),
            );
          }).toList(),
        );
      },
    );
  }

  void _removeExisting(AttachmentModel attachment) {
    setState(() {
      _existingAttachments.remove(attachment);
    });
    _notify();
  }

  void _removePending(PendingAttachment attachment) {
    setState(() {
      _pendingAttachments.remove(attachment);
    });
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Documents', style: Theme.of(context).textTheme.titleSmall),
            const Spacer(),
            TextButton.icon(
              onPressed: widget.enabled ? _pickFile : null,
              icon: const Icon(Icons.attach_file, size: 18),
              label: const Text('Add Document'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_existingAttachments.isEmpty && _pendingAttachments.isEmpty)
          Text(
            'No documents added',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._existingAttachments.map(
              (attachment) => Chip(
                avatar: const Icon(Icons.description_outlined, size: 18),
                label: Text(
                  '${attachment.name} (${attachment.fileType.displayName})',
                ),
                onDeleted: widget.enabled
                    ? () => _removeExisting(attachment)
                    : null,
              ),
            ),
            ..._pendingAttachments.map(
              (attachment) => Chip(
                avatar: const Icon(Icons.upload_file, size: 18),
                label: Text(
                  '${attachment.fileName} (${attachment.fileType.displayName})',
                ),
                onDeleted: widget.enabled
                    ? () => _removePending(attachment)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
