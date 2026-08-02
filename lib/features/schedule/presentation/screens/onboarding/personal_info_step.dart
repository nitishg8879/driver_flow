import 'package:driver_flow_admin/features/schedule/presentation/cubit/onboarding_cubit.dart';
import 'package:driver_flow_admin/features/schedule/presentation/providers/state_city_provider.dart';
import 'package:driver_flow_admin/features/schedule/presentation/screens/onboarding/onboarding_form_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfoStep extends StatefulWidget {
  static final stateKey = GlobalKey<_PersonalInfoStepState>();
  
  const PersonalInfoStep({super.key});

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController streetController;
  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController zipController;
  String? _selectedState;
  List<String> _cities = [];

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    streetController = TextEditingController();
    cityController = TextEditingController();
    stateController = TextEditingController();
    zipController = TextEditingController();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.dispose();
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }

  Map<String, String> getFormData() {
    return {
      'fullName': fullNameController.text,
      'phone': phoneController.text,
      'email': emailController.text,
      'street': streetController.text,
      'city': cityController.text,
      'state': stateController.text,
      'zip': zipController.text,
    };
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingFormWrapper(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Form column
                Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Phone is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Email is required';
                          }
                          if (!value!.contains('@')) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(
                    labelText: 'Street Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Street address is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final statesAsync = ref.watch(statesProvider);
                          return statesAsync.when(
                            data: (states) => DropdownButtonFormField<String>(
                              initialValue: _selectedState,
                              decoration: const InputDecoration(
                                labelText: 'State',
                                border: OutlineInputBorder(),
                              ),
                              items: states
                                  .map((state) => DropdownMenuItem(
                                        value: state,
                                        child: Text(state),
                                      ))
                                  .toList(),
                              onChanged: (value) async {
                                setState(() {
                                  _selectedState = value;
                                  stateController.text = value ?? '';
                                  cityController.clear();
                                });
                                if (value != null) {
                                  final cities = await ref
                                      .read(citiesProvider(value).future);
                                  setState(() {
                                    _cities = cities;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'State is required';
                                }
                                return null;
                              },
                            ),
                            loading: () =>
                                const Center(child: CircularProgressIndicator()),
                            error: (err, stack) => Center(
                              child: Text('Error: $err'),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: cityController.text.isEmpty
                            ? null
                            : cityController.text,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(),
                        ),
                        items: _cities
                            .map((city) => DropdownMenuItem(
                                  value: city,
                                  child: Text(city),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            cityController.text = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'City is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: zipController,
                        decoration: const InputDecoration(
                          labelText: 'Zip Code',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Zip code is required';
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
          const SizedBox(width: 24),
          // Tips card column
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Registration Tips',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[900],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ensure accurate information for proper verification and communication.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  _buildTipBullet(context, 'Verify legal name matches ID'),
                  const SizedBox(height: 8),
                  _buildTipBullet(context, 'Prefer mobile number for SMS alerts'),
                  const SizedBox(height: 8),
                  _buildTipBullet(context, 'Use primary residence address'),
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<OnboardingCubit>().nextStep();
                    }
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipBullet(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '•',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}