import 'package:driver_flow_admin/features/schedule/presentation/cubit/onboarding_cubit.dart';
import 'package:driver_flow_admin/utils/components/upload_card.dart';
import 'package:driver_flow_admin/features/schedule/presentation/screens/onboarding/onboarding_form_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DocumentsPaymentStep extends StatefulWidget {
  static final stateKey = GlobalKey<_DocumentsPaymentStepState>();

  final double pricePerSession;
  final int sessionsCount;

  const DocumentsPaymentStep({
    super.key,
    required this.pricePerSession,
    required this.sessionsCount,
  });

  @override
  State<DocumentsPaymentStep> createState() => _DocumentsPaymentStepState();
}

class _DocumentsPaymentStepState extends State<DocumentsPaymentStep> {
  final _formKey = GlobalKey<FormState>();
  int _installmentsCount = 3;
  late List<TextEditingController> _dueDateControllers;
  late List<TextEditingController> _amountControllers;
  List<String> _uploadedDocuments = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _dueDateControllers = List.generate(6, (index) => TextEditingController());
    _amountControllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _dueDateControllers) {
      controller.dispose();
    }
    for (var controller in _amountControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  bool validate() {
    bool isValid = _formKey.currentState?.validate() ?? false;
    if (_uploadedDocuments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload required documents')),
      );
      return false;
    }
    return isValid;
  }

  Map<String, dynamic> getFormData() {
    final amounts = _amountControllers
        .take(_installmentsCount)
        .map((c) => double.tryParse(c.text) ?? 0.0)
        .toList();

    final dates = _dueDateControllers
        .take(_installmentsCount)
        .map((c) => c.text)
        .toList();

    return {
      'documents': _uploadedDocuments,
      'installments': _installmentsCount,
      'amounts': amounts,
      'dates': dates,
    };
  }

  @override
  Widget build(BuildContext context) {
    final double totalAmount = widget.pricePerSession * widget.sessionsCount;

    return OnboardingFormWrapper(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Required Documents
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Required Documents',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload identity and photo documents for verification.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      UploadCard(
                        icon: Icons.description,
                        title: 'ID Proof',
                        subtitle:
                            'Upload a copy of your valid ID (Aadhar, DL, etc.)',
                        onUpload: () {
                          setState(() {
                            _uploadedDocuments.add('ID Proof');
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      UploadCard(
                        icon: Icons.photo_camera,
                        title: 'Student Photo',
                        subtitle: 'Upload a recent passport-sized photograph',
                        onUpload: () {
                          setState(() {
                            _uploadedDocuments.add('Student Photo');
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Right: Installment Planner
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Installment Planner',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        // Summary Row
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TOTAL AMOUNT',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$$totalAmount',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  border: Border.all(color: Colors.blue[300]!),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'REMAINING BALANCE',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$$totalAmount',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue[900],
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          initialValue: _installmentsCount,
                          decoration: const InputDecoration(
                            labelText: 'Number of Installments',
                            border: OutlineInputBorder(),
                          ),
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('1')),
                            DropdownMenuItem(value: 2, child: Text('2')),
                            DropdownMenuItem(value: 3, child: Text('3')),
                            DropdownMenuItem(value: 4, child: Text('4')),
                            DropdownMenuItem(value: 6, child: Text('6')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _installmentsCount = value;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    _buildTableCell(
                                      context,
                                      '#',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    _buildTableCell(
                                      context,
                                      'Due Date',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    _buildTableCell(
                                      context,
                                      'Amount',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                              ...List.generate(
                                _installmentsCount,
                                (index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      _buildTableCell(context, '${index + 1}'),
                                      SizedBox(
                                        width: 120,
                                        child: TextFormField(
                                          controller:
                                              _dueDateControllers[index],
                                          decoration: InputDecoration(
                                            labelText: 'Date',
                                            border: const OutlineInputBorder(),
                                            suffixIcon: IconButton(
                                              icon: const Icon(
                                                Icons.calendar_today,
                                                size: 18,
                                              ),
                                              onPressed: () async {
                                                final date =
                                                    await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now().add(
                                                            Duration(
                                                              days:
                                                                  (index + 1) *
                                                                  30,
                                                            ),
                                                          ),
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.now()
                                                          .add(
                                                            const Duration(
                                                              days: 365,
                                                            ),
                                                          ),
                                                    );
                                                if (date != null) {
                                                  setState(() {
                                                    _dueDateControllers[index]
                                                        .text = DateFormat(
                                                      'MMM dd',
                                                    ).format(date);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                          readOnly: true,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return 'Required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: TextFormField(
                                          controller: _amountControllers[index],
                                          decoration: const InputDecoration(
                                            labelText: 'Amount',
                                            border: OutlineInputBorder(),
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (value) {
                                            if (value?.isEmpty ?? true) {
                                              return 'Required';
                                            }
                                            if (double.tryParse(value!) ==
                                                null) {
                                              return 'Invalid';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                  ),
                  onPressed: () =>
                      context.read<OnboardingCubit>().previousStep(),
                  child: const Text('Back'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<OnboardingCubit>().submitOnboarding(
                        context.read<OnboardingCubit>().state.formData!,
                      );
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Complete Onboarding'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(
    BuildContext context,
    String text, {
    FontWeight? fontWeight,
    double width = 60,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(fontWeight: fontWeight),
      ),
    );
  }
}
