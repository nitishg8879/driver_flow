import 'package:flutter/material.dart';

import '../../../../core/models/attachment_model.dart';
import '../../../../utils/components/async_dropdown.dart';
import '../../../../utils/components/attachment_picker_field.dart';
import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/components/searchable_async_dropdown.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../../user/data/models/user_model.dart';
import '../../data/models/payment_model.dart';

class PaymentFormDialog extends StatefulWidget {
  final PaymentModel? existing;

  const PaymentFormDialog({super.key, this.existing});

  @override
  State<PaymentFormDialog> createState() => _PaymentFormDialogState();
}

class _PaymentFormDialogState extends State<PaymentFormDialog> {
  late final TextEditingController _txnIdController;
  late final TextEditingController _amountController;
  UserModel? _selectedStudent;
  late DateTime _txnDate;
  TransactionType _txnType = TransactionType.credit;
  // ignore: unused_field
  List<String> _selectedTagIds = [];
  List<AttachmentModel> _existingAttachments = [];
  // ignore: unused_field
  List<PendingAttachment> _pendingAttachments = [];
  bool _isSaving = false;
  String? _errorMessage;

  bool get _isEditMode => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _txnIdController = TextEditingController(text: existing?.txnId ?? '');
    _amountController = TextEditingController(
      text: existing?.amount.toString() ?? '',
    );
    _txnDate = existing?.txnDate ?? DateTime.now();
    _txnType = existing?.txnType ?? TransactionType.credit;
    _selectedTagIds = List.from(existing?.tags ?? []);

    // Pre-create student object in edit mode (minimal info for display)
    if (existing != null) {
      _selectedStudent = UserModel(
        id: existing.studentId,
        name: existing.studentName,
        email: '',
        role: UserRole.student,
        isActive: true,
      );
    }
  }

  @override
  void dispose() {
    _txnIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _generateTxnId() {
    if (_selectedStudent == null) return '';
    final now = DateTime.now();
    final dateTime =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    return 'TXN_${_selectedStudent!.id!}_$dateTime';
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _txnDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _txnDate = picked);
    }
  }

  Future<void> _submit() async {
    // if (_selectedStudent == null) {
    //   setState(() => _errorMessage = 'Please select a student');
    //   return;
    // }

    // if (_txnIdController.text.trim().isEmpty) {
    //   setState(() => _errorMessage = 'TXN ID cannot be empty');
    //   return;
    // }

    // if (_amountController.text.trim().isEmpty) {
    //   setState(() => _errorMessage = 'Please enter an amount');
    //   return;
    // }

    // final amount = double.tryParse(_amountController.text.trim());
    // if (amount == null || amount <= 0) {
    //   setState(() => _errorMessage = 'Please enter a valid amount');
    //   return;
    // }

    // setState(() {
    //   _isSaving = true;
    //   _errorMessage = null;
    // });

    // try {
    //   // Upload pending attachments using AttachmentService
    //   final attachmentService = sl<AttachmentService>();
    //   final uploadedAttachments = <AttachmentModel>[];

    //   for (final pending in _pendingAttachments) {
    //     final uploaded = await attachmentService.uploadAttachment(
    //       bytes: pending.bytes,
    //       fileName: pending.fileName,
    //       fileType: pending.fileType,
    //       source: AttachmentSource.payment,
    //       ownerId: _selectedStudent!.id!,
    //       uploadedBy: 'admin', // TODO: Get from auth user
    //     );
    //     uploadedAttachments.add(uploaded);
    //   }

    //   final cubit = context.read<PaymentCubit>();
    //   final allAttachmentUrls = [
    //     ..._existingAttachments.map((a) => a.url),
    //     ...uploadedAttachments.map((a) => a.url),
    //   ];

    //   final model =
    //       (widget.existing ??
    //               PaymentModel(
    //                 txnId: '',
    //                 studentId: '',
    //                 studentName: '',
    //                 amount: 0,
    //                 txnDate: _txnDate,
    //               ))
    //           .copyWith(
    //             txnId: _txnIdController.text.trim(),
    //             studentId: _selectedStudent!.id!,
    //             studentName: _selectedStudent!.name ?? '',
    //             amount: amount,
    //             txnType: _txnType,
    //             txnDate: _txnDate,
    //             tags: _selectedTagIds,
    //             attachments: allAttachmentUrls,
    //           );

    //   final error = _isEditMode
    //       ? await cubit.updatePayment(model)
    //       : await cubit.createPayment(model);

    //   if (!mounted) return;

    //   if (error != null) {
    //     setState(() {
    //       _errorMessage = error;
    //       _isSaving = false;
    //     });
    //   } else {
    //     Navigator.pop(context);
    //   }
    // } catch (e) {
    //   if (!mounted) return;
    //   setState(() {
    //     _errorMessage = 'Failed to upload attachments: $e';
    //     _isSaving = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEditMode ? 'Edit Payment' : 'Add Payment',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
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
            // Student Selection
            SearchableAsyncDropdown<UserModel>(
              labelText: 'Student',
              value: _selectedStudent,
              onChanged: (student) {
                setState(() {
                  _selectedStudent = student;
                  if (student != null && !_isEditMode) {
                    _txnIdController.text = _generateTxnId();
                  }
                });
              },
              searchItems: (query) {
                //   return sl<UserRepository>().searchActiveByRole(
                //   role: UserRole.student,
                //   query: query,
                // );
                return Future.value(
                  [],
                ); // Placeholder for actual search implementation
              },
              itemLabelBuilder: (user) => user.name ?? 'Unknown',
            ),
            const SizedBox(height: 16),
            // TXN ID (Only shown after student selection)
            if (_selectedStudent != null) ...[
              CustomTextField(
                labelText: 'Transaction ID',
                controller: _txnIdController,
                hintText: 'Auto-generated',
                enabled: false,
              ),
              const SizedBox(height: 16),
            ],
            // Amount
            CustomTextField(
              labelText: 'Amount',
              controller: _amountController,
              hintText: 'Enter amount',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 16),
            // Transaction Type
            AsyncDropdown<TransactionType>(
              labelText: 'Transaction Type',
              value: _txnType,
              onChanged: (type) =>
                  setState(() => _txnType = type ?? TransactionType.credit),
              fetchItems: () => Future.value(TransactionType.values.toList()),
              itemLabelBuilder: (type) => type.displayName,
            ),
            const SizedBox(height: 16),
            // Transaction Date
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transaction Date',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: _selectDate,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_txnDate.year}-${_txnDate.month.toString().padLeft(2, '0')}-${_txnDate.day.toString().padLeft(2, '0')}',
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Tags Multi-Select
            // Builder(
            //   builder: (context) {
            //     return FutureBuilder<void>(
            //       future: Future(
            //         () => context.read<TagsCubit>().listTags(activeOnly: true),
            //       ),
            //       builder: (context, snapshot) {
            //         return BlocBuilder<TagsCubit, TagsState>(
            //           builder: (context, tagsState) {
            //             return tagsState.maybeWhen(
            //               loaded:
            //                   (
            //                     allTags,
            //                     currentPage,
            //                     totalPages,
            //                     searchQuery,
            //                   ) => Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       const Text(
            //                         'Tags',
            //                         style: TextStyle(
            //                           fontWeight: FontWeight.w500,
            //                         ),
            //                       ),
            //                       const SizedBox(height: 8),
            //                       Wrap(
            //                         spacing: 8,
            //                         children: allTags.map((tag) {
            //                           final isSelected = _selectedTagIds
            //                               .contains(tag.id);
            //                           return FilterChip(
            //                             label: Text(tag.name),
            //                             selected: isSelected,
            //                             onSelected: (selected) {
            //                               setState(() {
            //                                 if (selected) {
            //                                   _selectedTagIds.add(tag.id!);
            //                                 } else {
            //                                   _selectedTagIds.remove(tag.id);
            //                                 }
            //                               });
            //                             },
            //                           );
            //                         }).toList(),
            //                       ),
            //                     ],
            //                   ),
            //               loading: () => const CircularProgressIndicator(),
            //               orElse: () => const SizedBox.shrink(),
            //             );
            //           },
            //         );
            //       },
            //     );
            //   },
            // ),
            const SizedBox(height: 16),
            // Attachments
            AttachmentPickerField(
              initialAttachments: _existingAttachments,
              onChanged: (existingAttachments, pendingAttachments) {
                setState(() {
                  _existingAttachments = existingAttachments;
                  _pendingAttachments = pendingAttachments;
                });
              },
            ),
            const SizedBox(height: 24),
            // Created At Display (Edit Mode Only)
            if (_isEditMode && widget.existing?.createdAt != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Created At:'),
                    Text(
                      widget.existing!.createdAt!.toString().split('.')[0],
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSaving ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: _isEditMode ? 'Update' : 'Create',
                  onPressed: _isSaving ? null : _submit,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
