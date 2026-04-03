import '../../domain/entities/investment.dart';

class InvestmentModel extends Investment {
  const InvestmentModel({
    required super.id,
    required super.investorId,
    required super.cattleAssetId,
    required super.batchName,
    super.primaryImageUrl,
    required super.sharesOwned,
    required super.pricePerShareAtPurchase,
    required super.totalInvested,
    required super.status,
    super.exitDividendPaid,
    super.realizedRoiPercent,
    required super.purchasedAt,
    super.exitedAt,
  });

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    final asset = json['cattle_assets'] as Map<String, dynamic>? ?? {};
    return InvestmentModel(
      id: json['id'] as String,
      investorId: json['investor_id'] as String,
      cattleAssetId: json['cattle_asset_id'] as String,
      batchName: asset['batch_name'] as String? ?? 'Unknown Asset',
      primaryImageUrl: asset['primary_image_url'] as String?,
      sharesOwned: json['shares_owned'] as int,
      pricePerShareAtPurchase:
          (json['price_per_share_at_purchase'] as num).toDouble(),
      totalInvested: (json['total_invested'] as num).toDouble(),
      status: _parseStatus(json['status'] as String),
      exitDividendPaid: (json['exit_dividend_paid'] as num?)?.toDouble(),
      realizedRoiPercent: (json['realized_roi_percent'] as num?)?.toDouble(),
      purchasedAt: DateTime.parse(json['purchased_at'] as String),
      exitedAt: json['exited_at'] != null
          ? DateTime.parse(json['exited_at'] as String)
          : null,
    );
  }

  static InvestmentStatus _parseStatus(String status) {
    switch (status) {
      case 'market_ready': return InvestmentStatus.marketReady;
      case 'exited': return InvestmentStatus.exited;
      default: return InvestmentStatus.active;
    }
  }
}
