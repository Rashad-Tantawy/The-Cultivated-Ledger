import 'package:equatable/equatable.dart';

enum UserRole { investor, farmer, admin }

enum KycStatus { notStarted, pending, verified, rejected }

class AppUser extends Equatable {
  final String id;
  final String email;
  final UserRole role;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final KycStatus kycStatus;
  final double walletBalance;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    required this.kycStatus,
    required this.walletBalance,
    required this.createdAt,
  });

  String get fullName {
    if (firstName != null && lastName != null) return '$firstName $lastName';
    if (firstName != null) return firstName!;
    return email.split('@').first;
  }

  bool get isKycVerified => kycStatus == KycStatus.verified;
  bool get isInvestor => role == UserRole.investor;
  bool get isFarmer => role == UserRole.farmer;

  @override
  List<Object?> get props => [id, email, role, kycStatus];
}
