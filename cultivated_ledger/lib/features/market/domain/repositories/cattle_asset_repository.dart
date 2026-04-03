import '../entities/cattle_asset.dart';

abstract class CattleAssetRepository {
  Future<List<CattleAsset>> getActiveListings({int page = 0, int limit = 20});

  Future<CattleAsset> getListingById(String id);

  Future<List<CattleAsset>> searchListings({
    String? query,
    CattleBreed? breed,
    double? minRoi,
    double? maxRoi,
    int? maxMaturityMonths,
  });

  Future<List<CattleAsset>> getTopRatedFarmerListings({int limit = 5});

  Stream<CattleAsset> watchListing(String id);
}
