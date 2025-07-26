import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../controllers/rosca_cubit.dart';
import '../../models/rosca.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../widgets/custom_button.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

  @override
  void initState() {
    super.initState();
    context.read<RoscaCubit>().loadRoscas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Calendar',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.today, color: AppColors.primary),
                        onPressed: () {
                          setState(() {
                            currentMonth = DateTime.now();
                            selectedDate = DateTime.now();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left,
                            color: AppColors.textPrimary),
                        onPressed: () {
                          setState(() {
                            currentMonth = DateTime(
                                currentMonth.year, currentMonth.month - 1);
                          });
                        },
                      ),
                      Text(
                        DateFormat('MMMM yyyy').format(currentMonth),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right,
                            color: AppColors.textPrimary),
                        onPressed: () {
                          setState(() {
                            currentMonth = DateTime(
                                currentMonth.year, currentMonth.month + 1);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Calendar
            Expanded(
              flex: 3,
              child: BlocBuilder<RoscaCubit, RoscaState>(
                builder: (context, state) {
                  if (state is RoscaLoaded) {
                    final userRoscas = state.userRoscas;
                    return _buildCalendar(userRoscas);
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),

            // Payment Details
            Expanded(
              flex: 2,
              child: BlocBuilder<RoscaCubit, RoscaState>(
                builder: (context, state) {
                  if (state is RoscaLoaded) {
                    final userRoscas = state.userRoscas;
                    return _buildPaymentDetails(userRoscas);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(List<Rosca> userRoscas) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;
    final totalDays = lastDayOfMonth.day;

    // Get payment dates for the current month
    final paymentDates = _getPaymentDatesForMonth(userRoscas, currentMonth);

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          // Weekday headers
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
            child: Row(
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: AppConstants.fontSizeSmall,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.cardBorder),

          // Calendar grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: 42, // 6 weeks * 7 days
                itemBuilder: (context, index) {
                  final dayOffset = index - firstDayWeekday;
                  final day = dayOffset + 1;

                  if (dayOffset < 0 || day > totalDays) {
                    return const SizedBox(); // Empty cells for previous/next month
                  }

                  final date =
                      DateTime(currentMonth.year, currentMonth.month, day);
                  final isToday = _isSameDay(date, DateTime.now());
                  final isSelected = _isSameDay(date, selectedDate);
                  final hasPayment =
                      paymentDates.any((pd) => _isSameDay(pd.date, date));
                  final isOverdue =
                      hasPayment && date.isBefore(DateTime.now()) && !isToday;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDate = date;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: _getDayBackgroundColor(
                            isToday, isSelected, hasPayment, isOverdue),
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            day.toString(),
                            style: TextStyle(
                              color: _getDayTextColor(
                                  isToday, isSelected, hasPayment, isOverdue),
                              fontSize: AppConstants.fontSizeSmall,
                              fontWeight: isToday || isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          if (hasPayment)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isOverdue
                                    ? AppColors.error
                                    : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails(List<Rosca> userRoscas) {
    final paymentsForSelectedDate =
        _getPaymentsForDate(userRoscas, selectedDate);

    return Container(
      margin: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppConstants.borderRadius),
                topRight: Radius.circular(AppConstants.borderRadius),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primary,
                  size: AppConstants.iconSizeMedium,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  DateFormat('MMMM dd, yyyy').format(selectedDate),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: paymentsForSelectedDate.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 48,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: AppConstants.paddingSmall),
                        Text(
                          'No payments due on this date',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    itemCount: paymentsForSelectedDate.length,
                    itemBuilder: (context, index) {
                      final payment = paymentsForSelectedDate[index];
                      return _buildPaymentCard(payment);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(PaymentInfo payment) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '${payment.rosca.currency} ');
    final isOverdue = payment.date.isBefore(DateTime.now()) &&
        !_isSameDay(payment.date, DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color:
            isOverdue ? AppColors.error.withOpacity(0.1) : AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: isOverdue ? AppColors.error : AppColors.cardBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  payment.rosca.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (isOverdue)
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
                    'OVERDUE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConstants.fontSizeSmall,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Row(
            children: [
              Icon(
                Icons.payments,
                color: AppColors.textSecondary,
                size: AppConstants.iconSizeSmall,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Payment: ${currencyFormatter.format(payment.rosca.paymentPerCycle)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.repeat,
                color: AppColors.textSecondary,
                size: AppConstants.iconSizeSmall,
              ),
              const SizedBox(width: AppConstants.paddingSmall),
              Text(
                'Cycle ${payment.rosca.currentCycle} of ${payment.rosca.totalSlots}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
          if (payment.rosca.userInfo != null) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.secondary,
                  size: AppConstants.iconSizeSmall,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Your position: #${payment.rosca.userInfo!.cyclePosition}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getDayBackgroundColor(
      bool isToday, bool isSelected, bool hasPayment, bool isOverdue) {
    if (isSelected) return AppColors.primary.withOpacity(0.2);
    if (isToday) return AppColors.secondary.withOpacity(0.1);
    if (isOverdue) return AppColors.error.withOpacity(0.1);
    if (hasPayment) return AppColors.primary.withOpacity(0.1);
    return Colors.transparent;
  }

  Color _getDayTextColor(
      bool isToday, bool isSelected, bool hasPayment, bool isOverdue) {
    if (isSelected || isToday) return AppColors.primary;
    if (isOverdue) return AppColors.error;
    if (hasPayment) return AppColors.secondary;
    return AppColors.textPrimary;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  List<PaymentInfo> _getPaymentDatesForMonth(
      List<Rosca> userRoscas, DateTime month) {
    final payments = <PaymentInfo>[];

    for (final rosca in userRoscas) {
      if (rosca.userInfo != null) {
        // Add next payment date if it's in the current month
        if (rosca.userInfo!.nextPaymentDate.year == month.year &&
            rosca.userInfo!.nextPaymentDate.month == month.month) {
          payments.add(
              PaymentInfo(rosca: rosca, date: rosca.userInfo!.nextPaymentDate));
        }

        // Add upcoming payment dates for the month
        var currentDate = rosca.userInfo!.nextPaymentDate;
        while (currentDate.year == month.year &&
            currentDate.month == month.month) {
          if (!payments.any((p) => _isSameDay(p.date, currentDate))) {
            payments.add(PaymentInfo(rosca: rosca, date: currentDate));
          }

          // Calculate next payment date based on duration
          switch (rosca.duration) {
            case RoscaDuration.monthly:
              currentDate = DateTime(
                  currentDate.year, currentDate.month + 1, currentDate.day);
              break;
            case RoscaDuration.quarterly:
              currentDate = DateTime(
                  currentDate.year, currentDate.month + 3, currentDate.day);
              break;
            case RoscaDuration.biMonthly:
              currentDate = DateTime(
                  currentDate.year, currentDate.month + 2, currentDate.day);
              break;
          }
        }
      }
    }

    return payments;
  }

  List<PaymentInfo> _getPaymentsForDate(List<Rosca> userRoscas, DateTime date) {
    final payments = <PaymentInfo>[];

    for (final rosca in userRoscas) {
      if (rosca.userInfo != null &&
          _isSameDay(rosca.userInfo!.nextPaymentDate, date)) {
        payments.add(PaymentInfo(rosca: rosca, date: date));
      }
    }

    return payments;
  }
}

class PaymentInfo {
  final Rosca rosca;
  final DateTime date;

  PaymentInfo({required this.rosca, required this.date});
}
