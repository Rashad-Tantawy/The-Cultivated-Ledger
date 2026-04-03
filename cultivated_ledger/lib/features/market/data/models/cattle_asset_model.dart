import '../../domain/entities/cattle_asset.dart';

class CattleAssetModel extends CattleAsset {
  const CattleAssetModel({
    required super.id,
    required super.farmerId,
    required super.farmerName,
    super.farmerAvatarUrl,
    required super.farmerRating,
    required super.farmerIsVerified,
    required super.batchName,
    required super.breed,
    required super.ageMonths,
    required super.weightLbs,
    required super.healthScore,
    required super.location,
    required super.status,
    required super.totalShares,
    required super.sharesRemaining,
    required super.pricePerShare,
    required super.estimatedRoiPercent,
    required super.maturityMonths,
    super.expectedMarketDate,
    required super.exitDividendPerShare,
    super.primaryImageUrl,
    required super.galleryImageUrls,
    super.cviDocumentUrl,
    required super.healthNotes,
    required super.hasInsurance,
    required super.hasIotTracking,
    required super.isVerified,
    required super.createdAt,
  });

  factory CattleAssetModel.fromJson(Map<String, dynamic> json) {
    final farmer = json['farmer_profiles'] as Map<String, dynamic>? ?? {};
    return CattleAssetModel(
      id: json['id'] as String,
      farmerId: json['farmer_id'] as String,
      farmerName: farmer['farm_name'] as String? ?? 'Unknown Farm',
      farmerAvatarUrl: farmer['profile_image_url'] as String?,
      farmerRating: (farmer['rating'] as num?)?.toDouble() ?? 0.0,
      farmerIsVerified: farmer['is_verified'] as bool? ?? false,
      batchName: json['batch_name'] as String,
      breed: _parseBreed(json['breed'] as String),
      ageMonths: json['age_months'] as int,
      weightLbs: (json['weight_lbs'] as num).toDouble(),
      healthScore: json['health_score'] as int? ?? 0,
      location: json['location'] as String,
      status: _parseStatus(json['status'] as String),
      totalShares: json['total_shares'] as int,
      sharesRemaining: json['shares_remaining'] as int,
      pricePerShare: (json['price_per_share'] as num).toDouble(),
      estimatedRoiPercent: (json['estimated_roi_percent'] as num).toDouble(),
      maturityMonths: json['maturity_months'] as int,
      expectedMarketDate: json['expected_market_date'] != null
          ? DateTime.parse(json['expected_market_date'] as String)
          : null,
      exitDividendPerShare:
          (json['exit_dividend_per_share'] as num?)?.toDouble() ?? 0.0,
      primaryImageUrl: json['primary_image_url'] as String?,
      galleryImageUrls: (json['gallery_image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      cviDocumentUrl: json['cvi_document_url'] as String?,
      healthNotes: json['health_notes'] as String? ?? '',
      hasInsurance: json['has_insurance'] as bool? ?? false,
      hasIotTracking: json['has_iot_tracking'] as bool? ?? false,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static CattleBreed _parseBreed(String breed) {
    return CattleBreed.values.firstWhere(
      (b) => b.name == breed,
      orElse: () => CattleBreed.other,
    );
  }

  static ListingStatus _parseStatus(String status) {
    const map = {
      'draft': ListingStatus.draft,
      'under_review': ListingStatus.underReview,
      'active': ListingStatus.active,
      'fully_funded': ListingStatus.fullyFunded,
      'market_ready': ListingStatus.marketReady,
      'completed': ListingStatus.completed,
      'cancelled': ListingStatus.cancelled,
    };
    return map[status] ?? ListingStatus.draft;
  }
}
