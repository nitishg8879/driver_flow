import 'package:driver_flow_admin/features/schedule/presentation/cubit/onboarding_cubit.dart';
import 'package:driver_flow_admin/features/schedule/presentation/cubit/onboarding_state.dart';
import 'package:driver_flow_admin/utils/components/horizontal_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'documents_payment_step.dart';
import 'personal_info_step.dart';
import 'training_schedule_step.dart';

class OnboardingStudentForm extends StatefulWidget {
  final VoidCallback onSuccess;

  const OnboardingStudentForm({super.key, required this.onSuccess});

  @override
  State<OnboardingStudentForm> createState() => _OnboardingStudentFormState();
}

class _OnboardingStudentFormState extends State<OnboardingStudentForm> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: BlocListener<OnboardingCubit, OnboardingState>(
        listener: (context, state) {
          if (state is OnboardingSuccess) {
            Navigator.of(context).pop();
            widget.onSuccess();
          } else if (state is OnboardingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.message}')));
          }
        },
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
          child: BlocBuilder<OnboardingCubit, OnboardingState>(
            builder: (context, state) {
              return Column(
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
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
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
                    steps: const [
                      'Personal Info',
                      'Training & Schedule',
                      'Documents & Payment',
                    ],
                  ),
                  Divider(height: 1, color: Colors.grey[300]),
                  // Content Area
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: _buildStepContent(state.currentStep),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(int currentStep) {
    final formData = context.read<OnboardingCubit>().state.formData;
    switch (currentStep) {
      case 0:
        return PersonalInfoStep(key: PersonalInfoStep.stateKey);
      case 1:
        return TrainingScheduleStep(key: TrainingScheduleStep.stateKey);
      case 2:
        return DocumentsPaymentStep(
          key: DocumentsPaymentStep.stateKey,
          pricePerSession: formData.pricePerSession ?? 0.0,
          sessionsCount: formData.sessionsCount ?? 0,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
