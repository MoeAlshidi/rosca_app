import 'package:equatable/equatable.dart';
import 'member.dart';
import 'rosca_slot.dart';

enum RoscaDuration { monthly, quarterly, biMonthly }

enum RoscaCategory { recommend, highDemand, discoverMore }

class Rosca extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String currency;
  final RoscaDuration duration;
  final RoscaCategory category;
  final int totalSlots;
  final int availableSlots;
  final double fees;
  final List<Member> members;
  final List<RoscaSlot> slots;
  final DateTime startDate;
  final DateTime? nextPaymentDate;
  final Member? nextCollector;
  final bool isUserMember;
  final bool isFull;

  const Rosca({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.duration,
    required this.category,
    required this.totalSlots,
    required this.availableSlots,
    required this.fees,
    required this.members,
    required this.slots,
    required this.startDate,
    this.nextPaymentDate,
    this.nextCollector,
    this.isUserMember = false,
    this.isFull = false,
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
      totalSlots: json['total_slots'],
      availableSlots: json['available_slots'],
      fees: json['fees'].toDouble(),
      members: (json['members'] as List?)
              ?.map((m) => Member.fromJson(m))
              .toList() ??
          [],
      slots: (json['slots'] as List?)
              ?.map((s) => RoscaSlot.fromJson(s))
              .toList() ??
          [],
      startDate: DateTime.parse(json['start_date']),
      nextPaymentDate: json['next_payment_date'] != null
          ? DateTime.parse(json['next_payment_date'])
          : null,
      nextCollector: json['next_collector'] != null
          ? Member.fromJson(json['next_collector'])
          : null,
      isUserMember: json['is_user_member'] ?? false,
      isFull: json['is_full'] ?? false,
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
      'total_slots': totalSlots,
      'available_slots': availableSlots,
      'fees': fees,
      'members': members.map((m) => m.toJson()).toList(),
      'slots': slots.map((s) => s.toJson()).toList(),
      'start_date': startDate.toIso8601String(),
      'next_payment_date': nextPaymentDate?.toIso8601String(),
      'next_collector': nextCollector?.toJson(),
      'is_user_member': isUserMember,
      'is_full': isFull,
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

  @override
  List<Object?> get props => [
        id,
        title,
        amount,
        currency,
        duration,
        category,
        totalSlots,
        availableSlots,
        fees,
        members,
        slots,
        startDate,
        nextPaymentDate,
        nextCollector,
        isUserMember,
        isFull,
      ];
} 