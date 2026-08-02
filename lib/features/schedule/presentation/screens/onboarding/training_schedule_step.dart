import 'package:driver_flow_admin/core/di/service_locator.dart';
import 'package:driver_flow_admin/features/schedule/presentation/cubit/onboarding_cubit.dart';
import 'package:driver_flow_admin/features/vehicle_type/data/repositories/vehicle_type_repository.dart';
import 'package:driver_flow_admin/features/vehicle_type/data/models/vehicle_type_model.dart';
import 'package:driver_flow_admin/utils/components/async_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TrainingScheduleStep extends StatefulWidget {
  static final stateKey = GlobalKey<_TrainingScheduleStepState>();

  const TrainingScheduleStep({super.key});

  @override
  State<TrainingScheduleStep> createState() => _TrainingScheduleStepState();
}

class _TrainingScheduleStepState extends State<TrainingScheduleStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController sessionsController;
  late TextEditingController durationController;
  late TextEditingController priceController;
  late TextEditingController startDateController;

  VehicleTypeModel? _selectedVehicleType;
  DateTime? _courseStartDate;
  String _recurrence = 'Weekly';

  @override
  void initState() {
    super.initState();
    sessionsController = TextEditingController();
    durationController = TextEditingController();
    priceController = TextEditingController();
    startDateController = TextEditingController();
  }

  @override
  void dispose() {
    sessionsController.dispose();
    durationController.dispose();
    priceController.dispose();
    startDateController.dispose();
    super.dispose();
  }

  
  void _onVehicleTypeChanged(VehicleTypeModel? vehicle) {
    setState(() {
      _selectedVehicleType = vehicle;
      if (vehicle != null) {
        sessionsController.text = (vehicle.numberOfSessions).toString();
        durationController.text = (vehicle.sessionDurationMinutes).toString();
        priceController.text = (vehicle.pricePerSession).toStringAsFixed(2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
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
                  fetchItems: () =>
                      sl<VehicleTypeRepository>().getVehicleTypes(),
                  itemLabelBuilder: (vehicle) => vehicle.name,
                  value: _selectedVehicleType,
                  onChanged: _onVehicleTypeChanged,
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
                          initialDate: _courseStartDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (selectedDate != null) {
                          setState(() {
                            _courseStartDate = selectedDate;
                            startDateController.text = DateFormat(
                              'MMM dd, yyyy',
                            ).format(selectedDate);
                          });
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
                              onTap: () =>
                                  setState(() => _recurrence = 'Weekly'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _recurrence == 'Weekly'
                                      ? Colors.blue[50]
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _recurrence == 'Weekly'
                                        ? Colors.blue[400]!
                                        : Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _recurrence == 'Weekly'
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: _recurrence == 'Weekly'
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
                              onTap: () =>
                                  setState(() => _recurrence = 'One-time'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: _recurrence == 'One-time'
                                      ? Colors.blue[50]
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: _recurrence == 'One-time'
                                        ? Colors.blue[400]!
                                        : Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _recurrence == 'One-time'
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: _recurrence == 'One-time'
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
                onPressed: () => context.read<OnboardingCubit>().previousStep(),
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    context.read<OnboardingCubit>().updateTrainingScheduleInfo(
                      vehicleTypeId: _selectedVehicleType?.id ?? '',
                      sessionsCount: int.tryParse(sessionsController.text) ?? 0,
                      pricePerSession:
                          double.tryParse(priceController.text) ?? 0.0,
                      sessionDuration:
                          int.tryParse(durationController.text) ?? 0,
                      startDate: _courseStartDate ?? DateTime.now(),
                      recurrence: _recurrence,
                    );
                  }
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
