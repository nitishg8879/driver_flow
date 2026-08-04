import 'package:driver_flow_admin/core/di/service_locator.dart';
import 'package:driver_flow_admin/features/schedule/data/repositories/state_city_repository.dart';
import 'package:driver_flow_admin/features/schedule/presentation/notifier/onboarding_providers.dart';
import 'package:driver_flow_admin/utils/components/async_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PersonalInfoStep extends HookConsumerWidget {
  static final stateKey = GlobalKey();

  const PersonalInfoStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(onboardingFormDataProvider);
    final notifier = ref.read(onboardingStateProvider.notifier);

    final formKey = useMemoized(() => GlobalKey<FormState>());
    final fullNameController = useTextEditingController(
      text: formData.fullName ?? '',
    );
    final phoneController = useTextEditingController(
      text: formData.phoneNumber ?? '',
    );
    final emailController = useTextEditingController(
      text: formData.email ?? '',
    );
    final streetController = useTextEditingController(
      text: formData.streetAddress ?? '',
    );
    final zipController = useTextEditingController(
      text: formData.zipCode ?? '',
    );

    final selectedState = useState<String?>(formData.state);
    final selectedCity = useState<String?>(formData.city);

    return _PersonalInfoStepContent(
      formKey: formKey,
      fullNameController: fullNameController,
      phoneController: phoneController,
      emailController: emailController,
      streetController: streetController,
      zipController: zipController,
      selectedState: selectedState.value,
      selectedCity: selectedCity.value,
      onStateChanged: (value) => selectedState.value = value,
      onCityChanged: (value) => selectedCity.value = value,
      onNext: () {
        if (formKey.currentState?.validate() ?? false) {
          notifier.updatePersonalInfo(
            fullName: fullNameController.text,
            phoneNumber: phoneController.text,
            email: emailController.text,
            streetAddress: streetController.text,
            states: selectedState.value ?? '',
            city: selectedCity.value ?? '',
            zipCode: zipController.text,
          );
        }
      },
    );
  }
}

class _PersonalInfoStepContent extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController streetController;
  final TextEditingController zipController;
  final String? selectedState;
  final String? selectedCity;
  final Function(String?) onStateChanged;
  final Function(String?) onCityChanged;
  final VoidCallback onNext;

  const _PersonalInfoStepContent({
    required this.formKey,
    required this.fullNameController,
    required this.phoneController,
    required this.emailController,
    required this.streetController,
    required this.zipController,
    required this.selectedState,
    required this.selectedCity,
    required this.onStateChanged,
    required this.onCityChanged,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: formKey,
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
                          child: AsyncDropdown<String>(
                            fetchItems: () => ref
                                .read(stateCityRepositoryProvider)
                                .getStates(),
                            itemLabelBuilder: (state) => state,
                            value: selectedState,
                            onChanged: (value) {
                              onStateChanged(value);
                              onCityChanged(null);
                            },
                            labelText: 'State',
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return 'State is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: selectedState == null
                              ? DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'City',
                                    border: OutlineInputBorder(),
                                  ),
                                  items: const [],
                                  onChanged: null,
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'City is required';
                                    }
                                    return null;
                                  },
                                )
                              : AsyncDropdown<String>(
                                  fetchItems: () => sl<StateCityRepository>()
                                      .getCities(selectedState!),
                                  itemLabelBuilder: (city) => city,
                                  value: selectedCity,
                                  onChanged: onCityChanged,
                                  labelText: 'City',
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
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
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
                      _buildTipBullet(
                        context,
                        'Prefer mobile number for SMS alerts',
                      ),
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
              ElevatedButton(onPressed: onNext, child: const Text('Next')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipBullet(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text('•', style: Theme.of(context).textTheme.bodySmall),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
