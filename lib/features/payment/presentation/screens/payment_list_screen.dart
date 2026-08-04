import 'package:flutter/material.dart';

import '../../../../utils/components/custom_button.dart';
import '../../../../utils/components/custom_text_field.dart';
import '../../../../utils/constants/app_enums.dart';
import '../../data/models/payment_model.dart';
import '../widgets/payment_form_dialog.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  late final TextEditingController _txnIdSearchController;
  late final TextEditingController _studentNameSearchController;
  TransactionType? _selectedTxnType;
  DateTime? _selectedMonth;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _txnIdSearchController = TextEditingController();
    _studentNameSearchController = TextEditingController();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _loadPayments();
  }

  @override
  void dispose() {
    _txnIdSearchController.dispose();
    _studentNameSearchController.dispose();
    super.dispose();
  }

  void _loadPayments() {
    context.read<PaymentCubit>().listPayments(
      monthFilter: _selectedMonth,
      txnIdSearch: _txnIdSearchController.text.trim().isEmpty
          ? null
          : _txnIdSearchController.text.trim(),
      studentNameSearch: _studentNameSearchController.text.trim().isEmpty
          ? null
          : _studentNameSearchController.text.trim(),
      txnTypeFilter: _selectedTxnType,
      pageNumber: _currentPage,
    );
  }

  void _resetFilters() {
    setState(() {
      _txnIdSearchController.clear();
      _studentNameSearchController.clear();
      _selectedTxnType = null;
      _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
      _currentPage = 1;
    });
    _loadPayments();
  }

  void _showPaymentDialog([PaymentModel? existing]) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<PaymentCubit>(),
        child: PaymentFormDialog(existing: existing),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              text: 'Add Payment',
              onPressed: _showPaymentDialog,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 12,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Search TXN ID',
                        controller: _txnIdSearchController,
                        onChanged: (_) => _loadPayments(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        labelText: 'Search Student Name',
                        controller: _studentNameSearchController,
                        onChanged: (_) => _loadPayments(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<TransactionType?>(
                          value: _selectedTxnType,
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('All Types'),
                              ),
                            ),
                            ...TransactionType.values.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text(type.displayName),
                                ),
                              );
                            }),
                          ],
                          onChanged: (type) {
                            setState(() => _selectedTxnType = type);
                            _loadPayments();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedMonth!,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedMonth = DateTime(
                                picked.year,
                                picked.month,
                              );
                              _currentPage = 1;
                            });
                            _loadPayments();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_selectedMonth!.year}-${_selectedMonth!.month.toString().padLeft(2, '0')}',
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Reset Filters',
                      onPressed: _resetFilters,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // Payments List
          Expanded(
            child: BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (payments, currentPage, totalPages) {
                    if (payments.isEmpty) {
                      return const Center(
                        child: Text('No payments found for selected filters'),
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: payments.length,
                            itemBuilder: (context, index) {
                              final payment = payments[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${payment.txnId} - ${payment.studentName}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        'Amount: ${payment.amount} | Type: ${payment.txnType.displayName}',
                                      ),
                                      Text(
                                        'Date: ${payment.txnDate.toString().split(' ')[0]}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: const Text('Edit'),
                                        onTap: () =>
                                            _showPaymentDialog(payment),
                                      ),
                                      PopupMenuItem(
                                        child: const Text('Delete'),
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text(
                                                'Delete Payment?',
                                              ),
                                              content: const Text(
                                                'Are you sure you want to delete this payment?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    context
                                                        .read<PaymentCubit>()
                                                        .deletePayment(
                                                          payment.id!,
                                                        );
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Delete'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        // Pagination Controls
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (currentPage > 1)
                                CustomButton(
                                  text: 'Previous',
                                  onPressed: () {
                                    setState(() => _currentPage--);
                                    _loadPayments();
                                  },
                                ),
                              const SizedBox(width: 16),
                              Text('Page $currentPage of $totalPages'),
                              const SizedBox(width: 16),
                              if (currentPage < totalPages)
                                CustomButton(
                                  text: 'Next',
                                  onPressed: () {
                                    setState(() => _currentPage++);
                                    _loadPayments();
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
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
}
