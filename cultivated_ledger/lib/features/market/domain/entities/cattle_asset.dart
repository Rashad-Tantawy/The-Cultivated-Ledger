import 'package:equatable/equatable.dart';

enum ListingStatus {
  draft,
  underReview,
  active,
  fullyFunded,
  marketReady,
  completed,
  cancelled,
}

enum CattleBreed {
  angus,
  hereford,
  brahman,
  charolais,
  simmental,
  limousin,
  wagyu,
  longhorn,
  highland,
  other,
}

class CattleAsset extends Equatable {
  final String id;
  final String farmerId;
  final String farmerName;
  final String? farmerAvatarUrl;
  final double farmerRating;
  final bool farmerIsVerified;
  final String batchName;
  final CattleBreed breed;
  final int ageMonths;
  final double weightLbs;
  final int healthScore;
  final String location;
  final ListingStatus status;
  final int totalShares;
  final int sharesRemaining;
  final double pricePerShare;
  final double estimatedRoiPercent;
  final int maturityMonths;
  final DateTime? expectedMarketDate;
  final double exitDividendPerShare;
  final String? primaryImageUrl;
  final List<String> galleryImageUrls;
  final String? cviDocumentUrl;
  final String healthNotes;
  final bool hasInsurance;
  final bool hasIotTracking;
  final bool isVerified;
  final DateTime createdAt;

  const CattleAsset({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    this.farmerAvatarUrl,
    required this.farmerRating,
    required this.farmerIsVerified,
    required this.batchName,
    required this.breed,
    required this.ageMonths,
    required this.weightLbs,
    required this.healthScore,
    required this.location,
    required this.status,
    required this.totalShares,
    required this.sharesRemaining,
    required this.pricePerShare,
    required this.estimatedRoiPercent,
    required this.maturityMonths,
    this.expectedMarketDate,
    required this.exitDividendPerShare,
    this.primaryImageUrl,
    required this.galleryImageUrls,
    this.cviDocumentUrl,
    required this.healthNotes,
    required this.hasInsurance,
    required this.hasIotTracking,
    required this.isVerified,
    required this.createdAt,
  });

  double get fundedPercent =>
      totalShares > 0 ? (totalShares - sharesRemaining) / totalShares : 0;

  double get totalValuation => totalShares * pricePerShare;

  bool get isFullyFunded => sharesRemaining == 0;

  String get breedDisplayName {
    switch (breed) {
      case CattleBreed.angus: return 'Black Angus';
      case CattleBreed.hereford: return 'Hereford';
      case CattleBreed.brahman: return 'Brahman';
      case CattleBreed.charolais: return 'Charolais';
      case CattleBreed.simmental: return 'Simmental';
      case CattleBreed.limousin: return 'Limousin';
      case CattleBreed.wagyu: return 'Wagyu';
      case CattleBreed.longhorn: return 'Texas Longhorn';
      case CattleBreed.highland: return 'Highland';
      case CattleBreed.other: return 'Mixed Breed';
    }
  }

  @override
  List<Object?> get props => [id, sharesRemaining, status];
}
