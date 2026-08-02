import 'package:flutter/material.dart';

/// Common wrapper widget for onboarding form pages
/// Provides consistent padding and styling across all form steps
class OnboardingFormWrapper extends StatelessWidget {
  final Widget child;

  const OnboardingFormWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: child,
    );
  }
}
