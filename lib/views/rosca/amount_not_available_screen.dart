import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/rosca.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/rosca_card.dart';

class AmountNotAvailableScreen extends StatelessWidget {
  final double requestedAmount;
  final List<Rosca> recommendedRoscas;

  const AmountNotAvailableScreen({
    super.key,
    required this.requestedAmount,
    required this.recommendedRoscas,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(symbol: 'EGP ');

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
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            const SizedBox(height: AppConstants.paddingXLarge),
            const Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.secondary,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'Amount isn\'t\nAvailable to October',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              'You can choose one of these slots instead.\nWith the available amounts or check our recommended circle.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            Container(
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
                        padding:
                            const EdgeInsets.all(AppConstants.paddingSmall),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_month,
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
                              'Next payment',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            Text(
                              currencyFormatter.format(10000),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        text: 'Choose',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  const Divider(),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(AppConstants.paddingSmall),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_month,
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
                              'Next payment',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                            Text(
                              currencyFormatter.format(6000),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        text: 'Choose',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            if (recommendedRoscas.isNotEmpty) ...[
              Text(
                'Recommended Circle',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              SizedBox(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedRoscas.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < recommendedRoscas.length - 1
                            ? AppConstants.paddingMedium
                            : 0,
                      ),
                      child: RoscaCard(
                        rosca: recommendedRoscas[index],
                      ),
                    );
                  },
                ),
              ),
            ],
            const Spacer(),
            CustomButton(
              text: 'Cancel',
              isOutlined: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
