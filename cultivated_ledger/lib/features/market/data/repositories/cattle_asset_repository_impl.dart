import '../../domain/entities/cattle_asset.dart';
import '../../domain/repositories/cattle_asset_repository.dart';
import '../datasources/cattle_asset_remote_datasource.dart';

class CattleAssetRepositoryImpl implements CattleAssetRepository {
  final CattleAssetRemoteDatasource _datasource;
  CattleAssetRepositoryImpl(this._datasource);

  @override
  Future<List<CattleAsset>> getActiveListings({int page = 0, int limit = 20}) =>
      _datasource.getActiveListings(page: page, limit: limit);

  @override
  Future<CattleAsset> getListingById(String id) =>
      _datasource.getListingById(id);

  @override
  Future<List<CattleAsset>> searchListings({
    String? query,
    CattleBreed? breed,
    double? minRoi,
    double? maxRoi,
    int? maxMaturityMonths,
  }) =>
      _datasource.searchListings(
        query: query,
        breed: breed,
        minRoi: minRoi,
        maxRoi: maxRoi,
        maxMaturityMonths: maxMaturityMonths,
      );

  @override
  Future<List<CattleAsset>> getTopRatedFarmerListings({int limit = 5}) =>
      _datasource.getTopRatedFarmerListings(limit: limit);

  @override
  Stream<CattleAsset> watchListing(String id) =>
      _datasource.watchListing(id);
}
