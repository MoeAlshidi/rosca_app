import 'package:equatable/equatable.dart';
import 'member.dart';
import 'rosca_slot.dart';

enum RoscaDuration { monthly, quarterly, biMonthly }

enum RoscaCategory { recommend, highDemand, discoverMore }

enum RoscaStatus { upcoming, active, completed, cancelled }

class UserRoscaInfo {
  final int cyclePosition; // User's position in the cycle (1-based)
  final DateTime nextPaymentDate; // When user needs to pay next
  final DateTime payoutDate; // When user will receive their payout
  final double totalPaid; // How much user has paid so far
  final double totalToSave; // Total amount user will save (amount * totalSlots)
  final bool hasReceivedPayout; // Whether user already received their payout
  final int cyclesRemaining; // How many payment cycles are left

  const UserRoscaInfo({
    required this.cyclePosition,
    required this.nextPaymentDate,
    required this.payoutDate,
    required this.totalPaid,
    required this.totalToSave,
    this.hasReceivedPayout = false,
    required this.cyclesRemaining,
  });

  factory UserRoscaInfo.fromJson(Map<String, dynamic> json) {
    return UserRoscaInfo(
      cyclePosition: json['cycle_position'],
      nextPaymentDate: DateTime.parse(json['next_payment_date']),
      payoutDate: DateTime.parse(json['payout_date']),
      totalPaid: json['total_paid'].toDouble(),
      totalToSave: json['total_to_save'].toDouble(),
      hasReceivedPayout: json['has_received_payout'] ?? false,
      cyclesRemaining: json['cycles_remaining'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cycle_position': cyclePosition,
      'next_payment_date': nextPaymentDate.toIso8601String(),
      'payout_date': payoutDate.toIso8601String(),
      'total_paid': totalPaid,
      'total_to_save': totalToSave,
      'has_received_payout': hasReceivedPayout,
      'cycles_remaining': cyclesRemaining,
    };
  }
}

class Rosca extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String currency;
  final RoscaDuration duration;
  final RoscaCategory category;
  final RoscaStatus status;
  final int totalSlots;
  final int availableSlots;
  final double fees;
  final List<Member> members;
  final List<RoscaSlot> slots;
  final DateTime startDate;
  final DateTime endDate; // Calculated end date
  final DateTime? nextPaymentDate;
  final Member? nextCollector;
  final int currentCycle; // Current cycle number (1-based)
  final bool isUserMember;
  final bool isFull;
  final UserRoscaInfo?
      userInfo; // User's specific information if they're a member
  final String? description; // Optional description

  const Rosca({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.duration,
    required this.category,
    required this.status,
    required this.totalSlots,
    required this.availableSlots,
    required this.fees,
    required this.members,
    required this.slots,
    required this.startDate,
    required this.endDate,
    this.nextPaymentDate,
    this.nextCollector,
    required this.currentCycle,
    this.isUserMember = false,
    this.isFull = false,
    this.userInfo,
    this.description,
  });

  factory Rosca.fromJson(Map<String, dynamic> json) {
    return Rosca(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      currency: json['currency'] ?? 'EGP',
      duration: RoscaDuration.values.firstWhere(
        (d) => d.name == json['duration'],
        orElse: () => RoscaDuration.monthly,
      ),
      category: RoscaCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => RoscaCategory.recommend,
      ),
      status: RoscaStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => RoscaStatus.upcoming,
      ),
      totalSlots: json['total_slots'],
      availableSlots: json['available_slots'],
      fees: json['fees'].toDouble(),
      members:
          (json['members'] as List?)?.map((m) => Member.fromJson(m)).toList() ??
              [],
      slots: (json['slots'] as List?)
              ?.map((s) => RoscaSlot.fromJson(s))
              .toList() ??
          [],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      nextPaymentDate: json['next_payment_date'] != null
          ? DateTime.parse(json['next_payment_date'])
          : null,
      nextCollector: json['next_collector'] != null
          ? Member.fromJson(json['next_collector'])
          : null,
      currentCycle: json['current_cycle'] ?? 1,
      isUserMember: json['is_user_member'] ?? false,
      isFull: json['is_full'] ?? false,
      userInfo: json['user_info'] != null
          ? UserRoscaInfo.fromJson(json['user_info'])
          : null,
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'currency': currency,
      'duration': duration.name,
      'category': category.name,
      'status': status.name,
      'total_slots': totalSlots,
      'available_slots': availableSlots,
      'fees': fees,
      'members': members.map((m) => m.toJson()).toList(),
      'slots': slots.map((s) => s.toJson()).toList(),
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'next_payment_date': nextPaymentDate?.toIso8601String(),
      'next_collector': nextCollector?.toJson(),
      'current_cycle': currentCycle,
      'is_user_member': isUserMember,
      'is_full': isFull,
      'user_info': userInfo?.toJson(),
      'description': description,
    };
  }

  String get durationDisplay {
    switch (duration) {
      case RoscaDuration.monthly:
        return 'Monthly';
      case RoscaDuration.quarterly:
        return 'Quarterly';
      case RoscaDuration.biMonthly:
        return 'Bi-Monthly';
    }
  }

  String get categoryDisplay {
    switch (category) {
      case RoscaCategory.recommend:
        return 'Recommend';
      case RoscaCategory.highDemand:
        return 'High Demand';
      case RoscaCategory.discoverMore:
        return 'Discover More';
    }
  }

  String get statusDisplay {
    switch (status) {
      case RoscaStatus.upcoming:
        return 'Starting Soon';
      case RoscaStatus.active:
        return 'Active';
      case RoscaStatus.completed:
        return 'Completed';
      case RoscaStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Calculate total amount user will save (contribution per cycle * total cycles)
  double get totalSavingGoal => amount * totalSlots;

  // Calculate payment per cycle (amount + fees)
  double get paymentPerCycle => amount + fees;

  // Calculate progress percentage for active ROSCAs
  double get progressPercentage {
    if (status != RoscaStatus.active) return 0.0;
    return (currentCycle - 1) / totalSlots;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        currency,
        duration,
        category,
        status,
        totalSlots,
        availableSlots,
        fees,
        members,
        slots,
        startDate,
        endDate,
        nextPaymentDate,
        nextCollector,
        currentCycle,
        isUserMember,
        isFull,
        userInfo,
        description,
      ];
}
