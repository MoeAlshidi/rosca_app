import 'package:equatable/equatable.dart';

class Member extends Equatable {
  final String id;
  final String name;
  final String? profileImage;
  final bool isVerified;

  const Member({
    required this.id,
    required this.name,
    this.profileImage,
    this.isVerified = false,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      name: json['name'],
      profileImage: json['profile_image'],
      isVerified: json['is_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_image': profileImage,
      'is_verified': isVerified,
    };
  }

  @override
  List<Object?> get props => [id, name, profileImage, isVerified];
} 