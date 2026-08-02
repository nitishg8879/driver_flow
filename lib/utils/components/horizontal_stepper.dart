import 'package:flutter/material.dart';

/// A horizontal stepper widget displaying step indicators in a row.
/// Shows circles with step numbers, connected by divider lines.
/// Completed steps show a checkmark icon.
class HorizontalStepper extends StatelessWidget {
  final int currentStep;
  final List<String> steps;
  final ValueChanged<int>? onStepTapped;
  final EdgeInsets padding;

  const HorizontalStepper({
    super.key,
    required this.currentStep,
    required this.steps,
    this.onStepTapped,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: padding,
      child: Row(
        // Aligns the top of each column so circles stay perfectly horizontal 
        // even if text wraps to multiple lines below.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (index) {
          final isActive = index <= currentStep;
          final isCompleted = index < currentStep;
          final textColor = isActive
              ? colorScheme.onSurface
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.6);

          return Expanded(
            // Every step takes exactly an equal fraction of the screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TOP SECTION: Left Line -> Circle -> Right Line
                Row(
                  children: [
                    // Left connecting line
                    Expanded(
                      child: Container(
                        height: 2,
                        // Make transparent if it's the very first step
                        color: index == 0
                            ? Colors.transparent
                            : (isActive ? colorScheme.primary : Colors.grey[300]),
                      ),
                    ),
                    // The Circle Node
                    GestureDetector(
                      onTap: () => onStepTapped?.call(index),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? colorScheme.primary : Colors.grey[200],
                          border: Border.all(
                            color: isActive ? colorScheme.primary : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? const Icon(Icons.check, color: Colors.white, size: 20)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive ? Colors.white : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    // Right connecting line
                    Expanded(
                      child: Container(
                        height: 2,
                        // Make transparent if it's the very last step
                        color: index == steps.length - 1
                            ? Colors.transparent
                            : (isCompleted ? colorScheme.primary : Colors.grey[300]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // BOTTOM SECTION: Text Label
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    steps[index],
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: textColor,
                          fontWeight:
                              index <= currentStep ? FontWeight.w600 : null,
                        ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}