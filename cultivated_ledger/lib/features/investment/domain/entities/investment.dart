import 'package:equatable/equatable.dart';

enum InvestmentStatus { active, marketReady, exited }

class Investment extends Equatable {
  final String id;
  final String investorId;
  final String cattleAssetId;
  final String batchName;
  final String? primaryImageUrl;
  final int sharesOwned;
  final double pricePerShareAtPurchase;
  final double totalInvested;
  final InvestmentStatus status;
  final double? exitDividendPaid;
  final double? realizedRoiPercent;
  final DateTime purchasedAt;
  final DateTime? exitedAt;

  const Investment({
    required this.id,
    required this.investorId,
    required this.cattleAssetId,
    required this.batchName,
    this.primaryImageUrl,
    required this.sharesOwned,
    required this.pricePerShareAtPurchase,
    required this.totalInvested,
    required this.status,
    this.exitDividendPaid,
    this.realizedRoiPercent,
    required this.purchasedAt,
    this.exitedAt,
  });

  double get currentValue => exitDividendPaid ?? totalInvested;
  bool get isExited => status == InvestmentStatus.exited;

  @override
  List<Object?> get props => [id, status, sharesOwned];
}
