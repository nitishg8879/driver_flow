import 'package:driver_flow_admin/features/profile/data/models/organization_profile_model.dart';
import 'package:driver_flow_admin/features/profile/data/repositories/profile_repository.dart';
import 'package:driver_flow_admin/features/schedule/presentation/notifier/onboarding_notifier.dart';
import 'package:driver_flow_admin/features/schedule/presentation/notifier/onboarding_providers.dart';
import 'package:driver_flow_admin/utils/components/upload_card.dart';
import 'package:driver_flow_admin/utils/extensions/string_extension.dart';
import 'package:driver_flow_admin/utils/helpers/date_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class DocumentsPaymentStep extends HookConsumerWidget {
  const DocumentsPaymentStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    final totalAmount = useMemoized(
      () =>
          (state.formData.pricePerSession ?? 0) *
          (state.formData.sessionsCount ?? 0),
      [state.formData.pricePerSession, state.formData.sessionsCount],
    );

    final installmentsCount = useState<int>(1);
    final uploadedDocuments = useState<List<String>>([]);

    final sessionDates = useMemoized(() async {
      // final workingDays = orgProfile?.workingDays ?? [];
      final orgProfile = await ref.read(profileDataProvider.future);
      final workingDays = orgProfile?.workingDays ?? [];
      final today = DateTime.now();
      final sessionsCount = state.formData.sessionsCount ?? 0;
      final startDate = DateTime(today.year, today.month, today.day);
      return DateHelper.getSessionDates(startDate, sessionsCount, workingDays);
    }, [sessionsCount, orgProfile?.workingDays]);

    final dueDateControllers = useMemoized(() {
      final controllers = <TextEditingController>[];
      for (int i = 0; i < installmentsCount.value; i++) {
        final controller = TextEditingController();
        final dueDate = DateHelper.getInstallmentDueDate(
          sessionDates,
          i,
          installmentsCount.value,
        );
        controller.text = DateFormat('MMM dd, yyyy').format(dueDate);
        controllers.add(controller);
      }
      return controllers;
    }, [installmentsCount.value]);

    final amountControllers = useMemoized(() {
      final controllers = <TextEditingController>[];
      final amountPerInstallment = totalAmount / installmentsCount.value;
      for (int i = 0; i < installmentsCount.value; i++) {
        final controller = TextEditingController();
        controller.text = amountPerInstallment.toRuppess;
        controllers.add(controller);
      }
      return controllers;
    }, [installmentsCount.value, totalAmount]);

    final formKey = useMemoized(() => GlobalKey<FormState>());

    useEffect(() {
      return () {
        for (var controller in dueDateControllers) {
          controller.dispose();
        }
        for (var controller in amountControllers) {
          controller.dispose();
        }
      };
    }, []);

    return _DocumentsPaymentStepContent(
      formKey: formKey,
      totalAmount: totalAmount,
      installmentsCount: installmentsCount.value,
      dueDateControllers: dueDateControllers,
      amountControllers: amountControllers,
      sessionDates: sessionDates,
      uploadedDocuments: uploadedDocuments.value,
      onDocumentUploaded: (docName) {
        uploadedDocuments.value = [...uploadedDocuments.value, docName];
      },
      onInstallmentChanged: (val) {
        installmentsCount.value = val;
      },
      onDateSelected: (index, formattedDate) {
        dueDateControllers[index].text = formattedDate;
      },
      onBack: () => notifier.previousStep(),
      onSubmit: () {
        if (formKey.currentState?.validate() ?? false) {
          notifier.submit();
        }
      },
    );
  }
}

class _DocumentsPaymentStepContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final double totalAmount;
  final int installmentsCount;
  final List<TextEditingController> dueDateControllers;
  final List<TextEditingController> amountControllers;
  final List<DateTime> sessionDates;
  final List<String> uploadedDocuments;
  final Function(String) onDocumentUploaded;
  final Function(int) onInstallmentChanged;
  final Function(int index, String formattedDate) onDateSelected;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const _DocumentsPaymentStepContent({
    required this.formKey,
    required this.totalAmount,
    required this.installmentsCount,
    required this.dueDateControllers,
    required this.amountControllers,
    required this.sessionDates,
    required this.uploadedDocuments,
    required this.onDocumentUploaded,
    required this.onInstallmentChanged,
    required this.onDateSelected,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RequiredDocumentsSection(
                  onDocumentUploaded: onDocumentUploaded,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: InstallmentPlannerSection(
                  totalAmount: totalAmount,
                  installmentsCount: installmentsCount,
                  dueDateControllers: dueDateControllers,
                  amountControllers: amountControllers,
                  sessionDates: sessionDates,
                  onInstallmentChanged: onInstallmentChanged,
                  onDateSelected: onDateSelected,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          StepNavigationActions(onBack: onBack, onSubmit: onSubmit),
        ],
      ),
    );
  }
}

class RequiredDocumentsSection extends StatelessWidget {
  final ValueChanged<String> onDocumentUploaded;

  const RequiredDocumentsSection({super.key, required this.onDocumentUploaded});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Documents',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Upload identity and photo documents for verification.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.blueGrey[500]),
        ),
        const SizedBox(height: 20),
        UploadCard(
          icon: Icons.badge_outlined,
          title: 'ID Proof',
          subtitle: 'Upload a copy of your valid Government ID',
          onUpload: () => onDocumentUploaded('ID Proof'),
        ),
        const SizedBox(height: 12),
        UploadCard(
          icon: Icons.account_box_outlined,
          title: 'Student Photo',
          subtitle: 'Upload a recent passport-sized photograph',
          onUpload: () => onDocumentUploaded('Student Photo'),
        ),
      ],
    );
  }
}

class InstallmentPlannerSection extends StatelessWidget {
  final double totalAmount;
  final int installmentsCount;
  final List<TextEditingController> dueDateControllers;
  final List<TextEditingController> amountControllers;
  final List<DateTime> sessionDates;
  final ValueChanged<int> onInstallmentChanged;
  final Function(int index, String formattedDate) onDateSelected;

  const InstallmentPlannerSection({
    super.key,
    required this.totalAmount,
    required this.installmentsCount,
    required this.dueDateControllers,
    required this.amountControllers,
    required this.sessionDates,
    required this.onInstallmentChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Installment Planner',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey[900],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$installmentsCount Payments',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: MetricCard(
                  title: 'TOTAL AMOUNT',
                  value: totalAmount.toRuppess,
                  backgroundColor: Colors.grey.shade50,
                  textColor: Colors.blueGrey[900]!,
                  borderColor: Colors.grey.shade200,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCard(
                  title: 'REMAINING BALANCE',
                  value: totalAmount.toRuppess,
                  backgroundColor: const Color(0xFFEFF6FF),
                  textColor: const Color(0xFF1E40AF),
                  borderColor: const Color(0xFFBFDBFE),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<int>(
            value: installmentsCount,
            decoration: InputDecoration(
              labelText: 'Number of Installments',
              labelStyle: TextStyle(color: Colors.blueGrey[600]),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
              ),
            ),
            items: const [1, 2, 3, 4, 6]
                .map(
                  (val) => DropdownMenuItem(
                    value: val,
                    child: Text('$val Installment${val > 1 ? 's' : ''}'),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null && value != installmentsCount) {
                onInstallmentChanged(value);
              }
            },
          ),
          const SizedBox(height: 20),
          const TableHeaderRow(),
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: installmentsCount,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return InstallmentRowItem(
                index: index,
                dueDateController: dueDateControllers[index],
                amountController: amountControllers[index],
                onDateTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(
                      Duration(days: (index + 1) * 30),
                    ),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    onDateSelected(
                      index,
                      DateFormat('MMM dd, yyyy').format(date),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 0.5,
              color: textColor.withOpacity(0.7),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class TableHeaderRow extends StatelessWidget {
  const TableHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          SizedBox(
            width: 32,
            child: Text(
              '#',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Due Date',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.blueGrey,
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              'Amount',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InstallmentRowItem extends StatelessWidget {
  final int index;
  final TextEditingController dueDateController;
  final TextEditingController amountController;
  final VoidCallback onDateTap;

  const InstallmentRowItem({
    super.key,
    required this.index,
    required this.dueDateController,
    required this.amountController,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: dueDateController,
            readOnly: true,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Select Date',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              suffixIcon: const Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: Colors.blue,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            onTap: onDateTap,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Required';
              }
              if (double.tryParse(value!) == null) {
                return 'Invalid';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class StepNavigationActions extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const StepNavigationActions({
    super.key,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onBack,
          child: const Text(
            'Back',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onSubmit,
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: const Text(
            'Complete Onboarding',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
