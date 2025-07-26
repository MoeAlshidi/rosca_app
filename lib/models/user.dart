import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? profileImage;
  final bool isHrLetterVerified;
  final bool isUtilityBillVerified;
  final bool isNationalIdVerified;
  final bool isIncomeInfoVerified;
  final bool isMobileNumberVerified;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.profileImage,
    this.isHrLetterVerified = false,
    this.isUtilityBillVerified = false,
    this.isNationalIdVerified = false,
    this.isIncomeInfoVerified = false,
    this.isMobileNumberVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      profileImage: json['profile_image'],
      isHrLetterVerified: json['is_hr_letter_verified'] ?? false,
      isUtilityBillVerified: json['is_utility_bill_verified'] ?? false,
      isNationalIdVerified: json['is_national_id_verified'] ?? false,
      isIncomeInfoVerified: json['is_income_info_verified'] ?? false,
      isMobileNumberVerified: json['is_mobile_number_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'profile_image': profileImage,
      'is_hr_letter_verified': isHrLetterVerified,
      'is_utility_bill_verified': isUtilityBillVerified,
      'is_national_id_verified': isNationalIdVerified,
      'is_income_info_verified': isIncomeInfoVerified,
      'is_mobile_number_verified': isMobileNumberVerified,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImage,
    bool? isHrLetterVerified,
    bool? isUtilityBillVerified,
    bool? isNationalIdVerified,
    bool? isIncomeInfoVerified,
    bool? isMobileNumberVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      isHrLetterVerified: isHrLetterVerified ?? this.isHrLetterVerified,
      isUtilityBillVerified: isUtilityBillVerified ?? this.isUtilityBillVerified,
      isNationalIdVerified: isNationalIdVerified ?? this.isNationalIdVerified,
      isIncomeInfoVerified: isIncomeInfoVerified ?? this.isIncomeInfoVerified,
      isMobileNumberVerified: isMobileNumberVerified ?? this.isMobileNumberVerified,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        profileImage,
        isHrLetterVerified,
        isUtilityBillVerified,
        isNationalIdVerified,
        isIncomeInfoVerified,
        isMobileNumberVerified,
      ];
} 