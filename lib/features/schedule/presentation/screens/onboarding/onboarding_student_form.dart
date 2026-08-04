import 'package:driver_flow_admin/features/schedule/presentation/notifier/onboarding_notifier.dart';
import 'package:driver_flow_admin/utils/components/horizontal_stepper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'documents_payment_step.dart';
import 'personal_info_step.dart';
import 'training_schedule_step.dart';

class OnboardingStudentForm extends ConsumerWidget {
  final VoidCallback? onSuccess;

  const OnboardingStudentForm({super.key, this.onSuccess});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingNotifierProvider);
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    ref.listen<OnboardingState>(onboardingNotifierProvider, (_, next) {
      if (next.isSuccess) {
        Navigator.of(context).pop();
        onSuccess?.call();
        notifier.reset();
      }
    });

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 1200,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Onboard New Student',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey[300]),
            // Horizontal Stepper
            HorizontalStepper(
              currentStep: state.currentStep,
              steps: notifier.steps,
            ),
            Divider(height: 1, color: Colors.grey[300]),
            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: _buildStepContent(state.currentStep, state.formData),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(int currentStep, formData) {
    switch (currentStep) {
      case 0:
        return PersonalInfoStep();
      case 1:
        return TrainingScheduleStep();
      case 2:
        return DocumentsPaymentStep();
      default:
        return const SizedBox.shrink();
    }
  }
}
