import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../controllers/rosca_cubit.dart';
import '../../models/rosca.dart';
import '../../models/member.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../../widgets/custom_button.dart';

class RoscaDetailScreen extends StatefulWidget {
  final Rosca rosca;

  const RoscaDetailScreen({super.key, required this.rosca});

  @override
  State<RoscaDetailScreen> createState() => _RoscaDetailScreenState();
}

class _RoscaDetailScreenState extends State<RoscaDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '${widget.rosca.currency} ');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade700),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.rosca.isUserMember ? 'My ROSCA' : 'ROSCA Details',
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Colors.grey.shade600),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              _buildHeaderCard(currencyFormatter),
              const SizedBox(height: 20),

              // User's Position Card (if member)
              if (widget.rosca.isUserMember && widget.rosca.userInfo != null)
                _buildUserPositionCard(currencyFormatter),

              if (widget.rosca.isUserMember && widget.rosca.userInfo != null)
                const SizedBox(height: 20),

              // Savings Overview
              _buildSavingsOverviewCard(currencyFormatter),
              const SizedBox(height: 20),

              // ROSCA Details
              _buildDetailsCard(currencyFormatter),
              const SizedBox(height: 20),

              // Members Section
              _buildMembersSection(),
              const SizedBox(height: 20),

              // Progress Indicator (if active)
              if (widget.rosca.status == RoscaStatus.active)
                _buildProgressSection(),

              if (widget.rosca.status == RoscaStatus.active)
                const SizedBox(height: 20),

              // Action Button
              if (!widget.rosca.isUserMember && !widget.rosca.isFull)
                _buildJoinButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(NumberFormat currencyFormatter) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: _getStatusColor().withOpacity(0.3), width: 1),
                ),
                child: Text(
                  widget.rosca.isUserMember
                      ? 'JOINED'
                      : widget.rosca.statusDisplay.toUpperCase(),
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Spacer(),
              if (widget.rosca.isFull)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200, width: 1),
                  ),
                  child: Text(
                    'FULL',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.rosca.title,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          if (widget.rosca.description != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.rosca.description!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Colors.grey.shade500,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Circle Value',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            currencyFormatter.format(widget.rosca.amount),
            style: const TextStyle(
              color: Color(0xFF2563EB),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPositionCard(NumberFormat currencyFormatter) {
    final userInfo = widget.rosca.userInfo!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFF2563EB).withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: const Color(0xFF2563EB),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Your Position',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildUserInfoItem(
                  'Position',
                  '#${userInfo.cyclePosition}',
                  'of ${widget.rosca.totalSlots}',
                  Icons.numbers,
                ),
              ),
              Expanded(
                child: _buildUserInfoItem(
                  'Next Payment',
                  DateFormat('MMM dd').format(userInfo.nextPaymentDate),
                  DateFormat('yyyy').format(userInfo.nextPaymentDate),
                  Icons.schedule,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildUserInfoItem(
                  'Payout Date',
                  DateFormat('MMM dd').format(userInfo.payoutDate),
                  DateFormat('yyyy').format(userInfo.payoutDate),
                  Icons.card_giftcard,
                ),
              ),
              Expanded(
                child: _buildUserInfoItem(
                  'Cycles Left',
                  '${userInfo.cyclesRemaining}',
                  'payments',
                  Icons.repeat,
                ),
              ),
            ],
          ),
          if (userInfo.payoutDate.difference(DateTime.now()).inDays <= 30 &&
              userInfo.payoutDate.isAfter(DateTime.now())) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200, width: 1),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.celebration,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You\'re getting paid in ${userInfo.payoutDate.difference(DateTime.now()).inDays} days!',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserInfoItem(
      String title, String value, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.grey.shade500,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1A1A1A),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSavingsOverviewCard(NumberFormat currencyFormatter) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Savings Overview',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSavingsItem(
                  'Payment per Cycle',
                  currencyFormatter.format(widget.rosca.paymentPerCycle),
                  'Amount + fees',
                  Icons.payment,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSavingsItem(
                  'Total Savings Goal',
                  currencyFormatter.format(widget.rosca.totalSavingGoal),
                  'Full circle value',
                  Icons.savings,
                ),
              ),
            ],
          ),
          if (widget.rosca.isUserMember && widget.rosca.userInfo != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSavingsItem(
                    'Amount Paid',
                    currencyFormatter.format(widget.rosca.userInfo!.totalPaid),
                    'So far',
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSavingsItem(
                    'Remaining',
                    currencyFormatter.format(
                        widget.rosca.userInfo!.totalToSave -
                            widget.rosca.userInfo!.totalPaid),
                    'To complete',
                    Icons.hourglass_empty,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSavingsItem(
      String title, String value, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF2563EB), size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF2563EB),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(NumberFormat currencyFormatter) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ROSCA Details',
            style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Duration', widget.rosca.durationDisplay),
          _buildDetailRow('Start Date',
              DateFormat('MMMM dd, yyyy').format(widget.rosca.startDate)),
          _buildDetailRow('End Date',
              DateFormat('MMMM dd, yyyy').format(widget.rosca.endDate)),
          _buildDetailRow('Total Slots', '${widget.rosca.totalSlots}'),
          _buildDetailRow('Available Slots', '${widget.rosca.availableSlots}'),
          _buildDetailRow(
              'Fees per Payment', currencyFormatter.format(widget.rosca.fees)),
          if (widget.rosca.status == RoscaStatus.active)
            _buildDetailRow('Current Cycle',
                '${widget.rosca.currentCycle} of ${widget.rosca.totalSlots}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Members',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${widget.rosca.members.length}/${widget.rosca.totalSlots}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (widget.rosca.members.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.rosca.members
                  .map((member) => _buildMemberChip(member))
                  .toList(),
            )
          else
            Center(
              child: Text(
                'No members yet',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMemberChip(Member member) {
    final isCurrentUser = member.id == 'user_1';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? const Color(0xFF2563EB).withOpacity(0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCurrentUser
              ? const Color(0xFF2563EB).withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: member.profileImage != null
                ? NetworkImage(member.profileImage!)
                : null,
            child: member.profileImage == null
                ? Text(
                    member.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            isCurrentUser ? 'You' : member.name,
            style: TextStyle(
              color: isCurrentUser
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF1A1A1A),
              fontSize: 13,
              fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          if (member.cyclePosition != null) ...[
            const SizedBox(width: 4),
            Text(
              '#${member.cyclePosition}',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    final progress = widget.rosca.progressPercentage;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'ROSCA Progress',
                style: TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            'Cycle ${widget.rosca.currentCycle} of ${widget.rosca.totalSlots} completed',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton() {
    return BlocListener<RoscaCubit, RoscaState>(
      listener: (context, state) {
        if (state is RoscaJoined) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Successfully joined the ROSCA!'),
              backgroundColor: Colors.green.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
          Navigator.pop(context);
        } else if (state is RoscaError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.shade600,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          );
        }
      },
      child: BlocBuilder<RoscaCubit, RoscaState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: state is RoscaJoining
                  ? null
                  : () => _showJoinConfirmation(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: state is RoscaJoining
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Join This ROSCA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  void _showJoinConfirmation(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '${widget.rosca.currency} ');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Join ROSCA',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to join "${widget.rosca.title}"?'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Payment per cycle:'),
                        Text(
                          currencyFormatter
                              .format(widget.rosca.paymentPerCycle),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total savings goal:'),
                        Text(
                          currencyFormatter
                              .format(widget.rosca.totalSavingGoal),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your slot will be automatically assigned.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<RoscaCubit>().joinRosca(widget.rosca.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Join'),
            ),
          ],
        );
      },
    );
  }

  Color _getStatusColor() {
    if (widget.rosca.isUserMember) {
      return const Color(0xFF2563EB);
    }

    switch (widget.rosca.status) {
      case RoscaStatus.upcoming:
        return Colors.orange.shade600;
      case RoscaStatus.active:
        return Colors.green.shade600;
      case RoscaStatus.completed:
        return Colors.grey.shade600;
      case RoscaStatus.cancelled:
        return Colors.red.shade600;
    }
  }
}
