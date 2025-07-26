import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final bool isVerified;
  final int? cyclePosition; // Position in the ROSCA cycle (1-based)
  final DateTime? assignedPayoutDate; // When this member receives payout
  final bool hasReceivedPayout; // Whether member already received their payout

  const Member({
    required this.id,
    required this.name,
    this.profileImage,
    this.isVerified = false,
    this.cyclePosition,
    this.assignedPayoutDate,
    this.hasReceivedPayout = false,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image'],
      isVerified: json['is_verified'] ?? false,
      cyclePosition: json['cycle_position'],
      assignedPayoutDate: json['assigned_payout_date'] != null
          ? DateTime.parse(json['assigned_payout_date'])
          : null,
      hasReceivedPayout: json['has_received_payout'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'is_verified': isVerified,
      'cycle_position': cyclePosition,
      'assigned_payout_date': assignedPayoutDate?.toIso8601String(),
      'has_received_payout': hasReceivedPayout,
    };
  }

  Member copyWith({
    String? id,
    String? name,
    String? profileImage,
    bool? isVerified,
    int? cyclePosition,
    DateTime? assignedPayoutDate,
    bool? hasReceivedPayout,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      cyclePosition: cyclePosition ?? this.cyclePosition,
      assignedPayoutDate: assignedPayoutDate ?? this.assignedPayoutDate,
      hasReceivedPayout: hasReceivedPayout ?? this.hasReceivedPayout,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        profileImage,
        isVerified,
        cyclePosition,
        assignedPayoutDate,
        hasReceivedPayout,
      ];
}
