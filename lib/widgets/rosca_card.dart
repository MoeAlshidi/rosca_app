import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/rosca.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../views/rosca/rosca_detail_screen.dart';
import '../views/profile/user_details_screen.dart';

class RoscaCard extends StatelessWidget {
  final Rosca rosca;
  final Color backgroundColor;

  const RoscaCard({
    super.key,
    required this.rosca,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: '${rosca.currency} ');
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoscaDetailScreen(rosca: rosca),
          ),
        );
      },
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      rosca.categoryDisplay,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: AppConstants.fontSizeSmall,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (rosca.isFull)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'FULL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                currencyFormatter.format(rosca.amount),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: AppConstants.fontSizeXXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${rosca.durationDisplay} • ${rosca.fees} ${rosca.currency} fees',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppConstants.fontSizeMedium,
                ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
                             Row(
                 children: [
                   _buildMemberAvatars(context),
                   const SizedBox(width: AppConstants.paddingSmall),
                  Text(
                    '${rosca.members.length} Members',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppConstants.fontSizeSmall,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${rosca.availableSlots} free slot${rosca.availableSlots != 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppConstants.fontSizeSmall,
                    ),
                  ),
                ],
              ),
              if (rosca.nextPaymentDate != null && rosca.isUserMember) ...[
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  'Next payment: ${DateFormat('MMM dd').format(rosca.nextPaymentDate!)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: AppConstants.fontSizeSmall,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberAvatars(BuildContext context) {
    const maxDisplay = 3;
    final displayMembers = rosca.members.take(maxDisplay).toList();
    final remainingCount = rosca.members.length - maxDisplay;

    return SizedBox(
      width: maxDisplay * 16.0 + (remainingCount > 0 ? 16.0 : 0),
      height: 24,
      child: Stack(
        children: [
          ...displayMembers.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            return Positioned(
              left: index * 16.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserDetailsScreen(),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.cardBorder,
                  backgroundImage: member.profileImage != null
                      ? NetworkImage(member.profileImage!)
                      : null,
                  child: member.profileImage == null
                      ? Text(
                          member.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        )
                      : null,
                ),
              ),
            );
          }),
          if (remainingCount > 0)
            Positioned(
              left: maxDisplay * 16.0,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.textLight,
                child: Text(
                  '+$remainingCount',
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getCategoryColor() {
    switch (rosca.category) {
      case RoscaCategory.recommend:
        return AppColors.warning;
      case RoscaCategory.highDemand:
        return AppColors.error;
      case RoscaCategory.discoverMore:
        return AppColors.secondary;
    }
  }
} 