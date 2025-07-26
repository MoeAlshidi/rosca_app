import 'package:equatable/equatable.dart';
import 'member.dart';

class RoscaSlot extends Equatable {
  final String id;
  final DateTime date;
  final Member? assignedMember;
  final bool isAvailable;
  final bool isPast;

  const RoscaSlot({
    required this.id,
    required this.date,
    this.assignedMember,
    this.isAvailable = true,
    this.isPast = false,
  });

  factory RoscaSlot.fromJson(Map<String, dynamic> json) {
    return RoscaSlot(
      id: json['id'],
      date: DateTime.parse(json['date']),
      assignedMember: json['assigned_member'] != null
          ? Member.fromJson(json['assigned_member'])
          : null,
      isAvailable: json['is_available'] ?? true,
      isPast: json['is_past'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'assigned_member': assignedMember?.toJson(),
      'is_available': isAvailable,
      'is_past': isPast,
    };
  }

  @override
  List<Object?> get props => [id, date, assignedMember, isAvailable, isPast];
} 