import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/rosca.dart';
import '../utils/app_colors.dart';
import '../utils/app_constants.dart';
import '../views/rosca/rosca_detail_screen.dart';

class RoscaCard extends StatelessWidget {
  final Rosca rosca;

  const RoscaCard({
    super.key,
    required this.rosca,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(symbol: '${rosca.currency} ');

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
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with status - compact
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: _getStatusColor().withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      rosca.isUserMember
                          ? 'JOINED'
                          : rosca.statusDisplay.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (rosca.isFull)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                        border:
                            Border.all(color: Colors.red.shade200, width: 1),
                      ),
                      child: Text(
                        'FULL',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Title and amount in same row to save space
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rosca.title,
                          style: const TextStyle(
                            color: Color(0xFF1A1A1A),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          rosca.durationDisplay,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    currencyFormatter.format(rosca.amount),
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Bottom info - simplified
              Row(
                children: [
                  // Members count
                  Icon(
                    Icons.people_outline,
                    color: Colors.grey.shade500,
                    size: 12,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${rosca.members.length}/${rosca.totalSlots}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Fees
                  Text(
                    '${currencyFormatter.format(rosca.fees)} fees',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  // Status indicator
                  if (rosca.isUserMember && rosca.userInfo != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '#${rosca.userInfo!.cyclePosition}',
                        style: const TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  else if (rosca.availableSlots > 0)
                    Text(
                      '${rosca.availableSlots} left',
                      style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    Text(
                      'Full',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (rosca.isUserMember) {
      return const Color(0xFF2563EB); // Blue for joined
    }

    switch (rosca.status) {
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
