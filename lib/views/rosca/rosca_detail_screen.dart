import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../controllers/rosca_cubit.dart';
import '../../models/rosca.dart';
import '../../models/rosca_slot.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../widgets/custom_button.dart';
import 'join_confirmation_screen.dart';

class RoscaDetailScreen extends StatefulWidget {
  final Rosca rosca;

  const RoscaDetailScreen({super.key, required this.rosca});

  @override
  State<RoscaDetailScreen> createState() => _RoscaDetailScreenState();
}

class _RoscaDetailScreenState extends State<RoscaDetailScreen> {
  RoscaSlot? selectedSlot;

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '${widget.rosca.currency} ');

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
          'Pick slot',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.warning),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(AppConstants.paddingMedium),
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingSmall),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: AppColors.secondary,
                        size: AppConstants.iconSizeMedium,
                      ),
                    ),
                    const SizedBox(width: AppConstants.paddingMedium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Circle Value',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                          Text(
                            currencyFormatter.format(widget.rosca.amount),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Row(
                  children: [
                    _buildInfoItem('Payout', currencyFormatter.format(widget.rosca.amount)),
                    _buildInfoItem('Duration', widget.rosca.durationDisplay),
                    _buildInfoItem('Starting', DateFormat('MMM dd').format(widget.rosca.startDate)),
                    _buildInfoItem('End', 'Jan 21'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(DateTime.now()),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  Expanded(
                    child: _buildCalendarGrid(),
                  ),
                ],
              ),
            ),
          ),
          if (selectedSlot != null)
            Container(
              color: AppColors.error.withOpacity(0.1),
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Row(
                children: [
                  const Icon(Icons.card_giftcard, color: AppColors.error),
                  const SizedBox(width: AppConstants.paddingSmall),
                  Expanded(
                    child: Text(
                      'The next chance you join this you\'ll win.\nJoin now and enjoy up to 1,500 EGP',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.error,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: CustomButton(
              text: selectedSlot != null ? 'Pick' : 'Select a slot',
              onPressed: selectedSlot != null
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinConfirmationScreen(
                            rosca: widget.rosca,
                            selectedSlot: selectedSlot!,
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: AppConstants.fontSizeSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: AppConstants.paddingSmall,
        mainAxisSpacing: AppConstants.paddingSmall,
      ),
      itemCount: widget.rosca.slots.length,
      itemBuilder: (context, index) {
        final slot = widget.rosca.slots[index];
        final isSelected = selectedSlot?.id == slot.id;
        
        return GestureDetector(
          onTap: slot.isAvailable
              ? () {
                  setState(() {
                    selectedSlot = isSelected ? null : slot;
                  });
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: _getSlotColor(slot, isSelected),
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (slot.assignedMember != null)
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.cardBorder,
                    backgroundImage: slot.assignedMember!.profileImage != null
                        ? NetworkImage(slot.assignedMember!.profileImage!)
                        : null,
                    child: slot.assignedMember!.profileImage == null
                        ? Text(
                            slot.assignedMember!.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          )
                        : null,
                  )
                else if (slot.isAvailable)
                  const Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: 24,
                  )
                else
                  const Icon(
                    Icons.close,
                    color: AppColors.textLight,
                    size: 24,
                  ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd').format(slot.date),
                  style: TextStyle(
                    color: slot.isAvailable
                        ? AppColors.textPrimary
                        : AppColors.textLight,
                    fontSize: AppConstants.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getSlotColor(RoscaSlot slot, bool isSelected) {
    if (isSelected) {
      return AppColors.primary.withOpacity(0.1);
    }
    if (slot.assignedMember != null) {
      return AppColors.cardBorder.withOpacity(0.3);
    }
    if (slot.isAvailable) {
      return AppColors.surface;
    }
    return AppColors.background;
  }
} 