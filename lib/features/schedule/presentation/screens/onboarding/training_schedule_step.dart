import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver_flow_admin/features/schedule/presentation/notifier/onboarding_providers.dart';
import 'package:driver_flow_admin/features/vehicle_type/data/models/vehicle_type_model.dart';
import 'package:driver_flow_admin/features/vehicle_type/data/repositories/vehicle_type_repository.dart';
import 'package:driver_flow_admin/utils/components/async_dropdown.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class TrainingScheduleStep extends HookConsumerWidget {
  static final stateKey = GlobalKey();

  const TrainingScheduleStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(onboardingFormDataProvider);
    final notifier = ref.read(onboardingStateProvider.notifier);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final sessionsController = useTextEditingController(
      text: formData.sessionsCount?.toString() ?? '',
    );
    final durationController = useTextEditingController(
      text: formData.sessionDuration?.toString() ?? '',
    );
    final priceController = useTextEditingController(
      text: formData.pricePerSession?.toString() ?? '',
    );
    final startDateController = useTextEditingController(
      text: formData.courseStartDate != null
          ? DateFormat('MMM dd, yyyy').format(formData.courseStartDate!)
          : '',
    );

    final selectedVehicleType = useState<VehicleTypeModel?>(
      formData.vehicleType,
    );
    final courseStartDate = useState<DateTime?>(formData.courseStartDate);
    final recurrence = useState<String>(formData.recurrence ?? 'Weekly');

    void onVehicleTypeChanged(VehicleTypeModel? vehicle) {
      selectedVehicleType.value = vehicle;
      if (vehicle != null) {
        sessionsController.text = (vehicle.numberOfSessions).toString();
        durationController.text = (vehicle.sessionDurationMinutes).toString();
        priceController.text = (vehicle.pricePerSession).toStringAsFixed(2);
      }
    }

    return _TrainingScheduleStepContent(
      formKey: formKey,
      sessionsController: sessionsController,
      durationController: durationController,
      priceController: priceController,
      startDateController: startDateController,
      selectedVehicleType: selectedVehicleType.value,
      courseStartDate: courseStartDate.value,
      recurrence: recurrence.value,
      onVehicleTypeChanged: onVehicleTypeChanged,
      onCourseStartDateChanged: (date) {
        courseStartDate.value = date;
        startDateController.text = DateFormat('MMM dd, yyyy').format(date);
      },
      onRecurrenceChanged: (value) => recurrence.value = value,
      onBack: () => notifier.previousStep(),
      onNext: () {
        if (formKey.currentState?.validate() ?? false) {
          notifier.updateTrainingScheduleInfo(
            vehicleType: selectedVehicleType.value!,
            sessionsCount: int.tryParse(sessionsController.text) ?? 0,
            pricePerSession: double.tryParse(priceController.text) ?? 0.0,
            sessionDuration: int.tryParse(durationController.text) ?? 0,
            startDate: courseStartDate.value ?? DateTime.now(),
            recurrence: recurrence.value,
          );
        }
      },
    );
  }
}

class _TrainingScheduleStepContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController sessionsController;
  final TextEditingController durationController;
  final TextEditingController priceController;
  final TextEditingController startDateController;
  final VehicleTypeModel? selectedVehicleType;
  final DateTime? courseStartDate;
  final String recurrence;
  final Function(VehicleTypeModel?) onVehicleTypeChanged;
  final Function(DateTime) onCourseStartDateChanged;
  final Function(String) onRecurrenceChanged;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const _TrainingScheduleStepContent({
    required this.formKey,
    required this.sessionsController,
    required this.durationController,
    required this.priceController,
    required this.startDateController,
    required this.selectedVehicleType,
    required this.courseStartDate,
    required this.recurrence,
    required this.onVehicleTypeChanged,
    required this.onCourseStartDateChanged,
    required this.onRecurrenceChanged,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Training Requirements Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.directions_car, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Training Requirements',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AsyncDropdown<VehicleTypeModel>(
                  fetchItems: () async {
                    final _data = await VehicleTypeRepositoryImpl(
                      firestore: FirebaseFirestore.instance,
                      storage: FirebaseStorage.instance,
                    ).getVehicleTypes();
                    return _data.items;
                  },
                  itemLabelBuilder: (vehicle) => vehicle.name,
                  value: selectedVehicleType,
                  onChanged: onVehicleTypeChanged,
                  labelText: 'Vehicle Type / Course',
                  validator: (value) {
                    if (value == null) {
                      return 'Vehicle type is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: sessionsController,
                        decoration: const InputDecoration(
                          labelText: 'Sessions Count',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Sessions count is required';
                          }
                          if (int.tryParse(value!) == null) {
                            return 'Must be a number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: durationController,
                        decoration: const InputDecoration(
                          labelText: 'Duration (mins)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Duration is required';
                          }
                          if (int.tryParse(value!) == null) {
                            return 'Must be a number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price per Session',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Price is required';
                          }
                          if (double.tryParse(value!) == null) {
                            return 'Must be a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Schedule Details Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Schedule Details',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: startDateController,
                  decoration: InputDecoration(
                    labelText: 'Course Start Date',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: courseStartDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (selectedDate != null) {
                          onCourseStartDateChanged(selectedDate);
                        }
                      },
                    ),
                  ),
                  readOnly: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Start date is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Recurrence:',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => onRecurrenceChanged('Weekly'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: recurrence == 'Weekly'
                                      ? Colors.blue[50]
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: recurrence == 'Weekly'
                                        ? Colors.blue[400]!
                                        : Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      recurrence == 'Weekly'
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: recurrence == 'Weekly'
                                          ? Colors.blue[600]
                                          : Colors.grey[600],
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('Weekly'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => onRecurrenceChanged('One-time'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: recurrence == 'One-time'
                                      ? Colors.blue[50]
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: recurrence == 'One-time'
                                        ? Colors.blue[400]!
                                        : Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      recurrence == 'One-time'
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: recurrence == 'One-time'
                                          ? Colors.blue[600]
                                          : Colors.grey[600],
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('One-time'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                onPressed: onBack,
                child: const Text('Back'),
              ),
              ElevatedButton(onPressed: onNext, child: const Text('Next')),
            ],
          ),
        ],
      ),
    );
  }
}
