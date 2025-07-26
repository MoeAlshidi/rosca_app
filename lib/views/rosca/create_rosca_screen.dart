import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../controllers/rosca_cubit.dart';
import '../../models/rosca.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class CreateRoscaScreen extends StatefulWidget {
  const CreateRoscaScreen({super.key});

  @override
  State<CreateRoscaScreen> createState() => _CreateRoscaScreenState();
}

class _CreateRoscaScreenState extends State<CreateRoscaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _feesController = TextEditingController();
  final _slotsController = TextEditingController();
  final _descriptionController = TextEditingController();

  RoscaDuration _selectedDuration = RoscaDuration.monthly;
  String _currency = 'EGP';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _feesController.dispose();
    _slotsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create ROSCA',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocListener<RoscaCubit, RoscaState>(
        listener: (context, state) {
          if (state is RoscaCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ROSCA created successfully!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else if (state is RoscaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.1),
                          AppColors.secondary.withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius),
                      border:
                          Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.add_circle,
                              color: AppColors.primary,
                              size: AppConstants.iconSizeLarge,
                            ),
                            const SizedBox(width: AppConstants.paddingMedium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create New ROSCA',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  Text(
                                    'Start a new savings circle with your community',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
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

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Basic Information
                  _buildSectionTitle('Basic Information'),
                  const SizedBox(height: AppConstants.paddingMedium),

                  CustomTextField(
                    controller: _titleController,
                    label: 'ROSCA Title',
                    hint: 'Enter a descriptive title',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a title';
                      }
                      if (value.trim().length < 3) {
                        return 'Title must be at least 3 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppConstants.paddingMedium),

                  CustomTextField(
                    controller: _descriptionController,
                    label: 'Description (Optional)',
                    hint: 'Describe your ROSCA purpose',
                    maxLines: 3,
                  ),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Financial Details
                  _buildSectionTitle('Financial Details'),
                  const SizedBox(height: AppConstants.paddingMedium),

                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomTextField(
                          controller: _amountController,
                          label: 'Amount per Cycle',
                          hint: '0.00',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return 'Please enter a valid amount';
                            }
                            if (amount < 100) {
                              return 'Minimum amount is 100';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingMedium),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingMedium,
                            vertical: AppConstants.paddingMedium,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                                AppConstants.borderRadius),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Text(
                            _currency,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.paddingMedium),

                  CustomTextField(
                    controller: _feesController,
                    label: 'Fees per Payment ($_currency)',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter fees amount';
                      }
                      final fees = double.tryParse(value);
                      if (fees == null || fees < 0) {
                        return 'Please enter a valid fees amount';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // ROSCA Settings
                  _buildSectionTitle('ROSCA Settings'),
                  const SizedBox(height: AppConstants.paddingMedium),

                  CustomTextField(
                    controller: _slotsController,
                    label: 'Number of Slots',
                    hint: 'How many members?',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of slots';
                      }
                      final slots = int.tryParse(value);
                      if (slots == null || slots < 2) {
                        return 'Minimum 2 slots required';
                      }
                      if (slots > 50) {
                        return 'Maximum 50 slots allowed';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: AppConstants.paddingMedium),

                  // Duration Selection
                  Text(
                    'Payment Duration',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),

                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingSmall),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      children: [
                        _buildDurationOption(
                          RoscaDuration.monthly,
                          'Monthly',
                          'Payments every month',
                          Icons.calendar_month,
                        ),
                        _buildDurationOption(
                          RoscaDuration.biMonthly,
                          'Bi-Monthly',
                          'Payments every 2 months',
                          Icons.calendar_view_month,
                        ),
                        _buildDurationOption(
                          RoscaDuration.quarterly,
                          'Quarterly',
                          'Payments every 3 months',
                          Icons.calendar_view_week,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Summary
                  _buildSummaryCard(),

                  const SizedBox(height: AppConstants.paddingLarge),

                  // Create Button
                  BlocBuilder<RoscaCubit, RoscaState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'Create ROSCA',
                        isLoading: state is RoscaCreating,
                        onPressed: _createRosca,
                      );
                    },
                  ),

                  const SizedBox(height: AppConstants.paddingMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildDurationOption(
    RoscaDuration duration,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedDuration == duration;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDuration = duration;
          });
        },
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            border: isSelected ? Border.all(color: AppColors.primary) : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: AppConstants.iconSizeMedium,
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Radio<RoscaDuration>(
                value: duration,
                groupValue: _selectedDuration,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedDuration = value;
                    });
                  }
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final fees = double.tryParse(_feesController.text) ?? 0;
    final slots = int.tryParse(_slotsController.text) ?? 0;
    final paymentPerCycle = amount + fees;
    final totalSavings = paymentPerCycle * slots;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          _buildSummaryRow(
              'Payment per Cycle',
              NumberFormat.currency(symbol: '$_currency ')
                  .format(paymentPerCycle)),
          _buildSummaryRow('Total Members', '$slots people'),
          _buildSummaryRow('Duration', _selectedDuration.name.toUpperCase()),
          _buildSummaryRow(
              'Total Pool Size',
              NumberFormat.currency(symbol: '$_currency ')
                  .format(totalSavings)),
          if (slots > 0) ...[
            const Divider(height: AppConstants.paddingMedium * 2),
            Text(
              'Each member will receive ${NumberFormat.currency(symbol: '$_currency ').format(amount)} when it\'s their turn.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  void _createRosca() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text.trim();
      final amount = double.parse(_amountController.text);
      final fees = double.parse(_feesController.text);
      final slots = int.parse(_slotsController.text);
      final description = _descriptionController.text.trim();

      context.read<RoscaCubit>().createRosca(
            title: title,
            amount: amount,
            currency: _currency,
            duration: _selectedDuration,
            totalSlots: slots,
            fees: fees,
            description: description.isNotEmpty ? description : null,
          );
    }
  }
}
