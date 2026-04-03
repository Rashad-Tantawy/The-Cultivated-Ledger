import '../../domain/entities/user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.email,
    required super.role,
    super.firstName,
    super.lastName,
    super.avatarUrl,
    required super.kycStatus,
    required super.walletBalance,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      role: _parseRole(json['role'] as String),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      kycStatus: _parseKycStatus(json['kyc_status'] as String? ?? 'not_started'),
      walletBalance: (json['wallet_balance'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role': role.name,
        'first_name': firstName,
        'last_name': lastName,
        'avatar_url': avatarUrl,
        'kyc_status': _kycStatusToString(kycStatus),
        'wallet_balance': walletBalance,
        'created_at': createdAt.toIso8601String(),
      };

  static UserRole _parseRole(String role) {
    switch (role) {
      case 'farmer':
        return UserRole.farmer;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.investor;
    }
  }

  static KycStatus _parseKycStatus(String status) {
    switch (status) {
      case 'pending':
        return KycStatus.pending;
      case 'verified':
        return KycStatus.verified;
      case 'rejected':
        return KycStatus.rejected;
      default:
        return KycStatus.notStarted;
    }
  }

  static String _kycStatusToString(KycStatus status) {
    switch (status) {
      case KycStatus.pending:
        return 'pending';
      case KycStatus.verified:
        return 'verified';
      case KycStatus.rejected:
        return 'rejected';
      case KycStatus.notStarted:
        return 'not_started';
    }
  }
}
