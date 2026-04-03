import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/supabase_client.dart';
import '../../domain/entities/cattle_asset.dart';
import '../models/cattle_asset_model.dart';

class CattleAssetRemoteDatasource {
  static const _select = '''
    *,
    farmer_profiles (
      farm_name,
      profile_image_url,
      rating,
      is_verified
    )
  ''';

  Future<List<CattleAssetModel>> getActiveListings({
    int page = 0,
    int limit = 20,
  }) async {
    final data = await supabase
        .from(AppConstants.tableCattleAssets)
        .select(_select)
        .inFilter('status', ['active', 'fully_funded'])
        .order('created_at', ascending: false)
        .range(page * limit, (page + 1) * limit - 1);
    return (data as List).map((e) => CattleAssetModel.fromJson(e)).toList();
  }

  Future<CattleAssetModel> getListingById(String id) async {
    final data = await supabase
        .from(AppConstants.tableCattleAssets)
        .select(_select)
        .eq('id', id)
        .single();
    return CattleAssetModel.fromJson(data);
  }

  Future<List<CattleAssetModel>> searchListings({
    String? query,
    CattleBreed? breed,
    double? minRoi,
    double? maxRoi,
    int? maxMaturityMonths,
  }) async {
    var q = supabase
        .from(AppConstants.tableCattleAssets)
        .select(_select)
        .eq('status', 'active');

    if (breed != null) q = q.eq('breed', breed.name);
    if (minRoi != null) q = q.gte('estimated_roi_percent', minRoi);
    if (maxRoi != null) q = q.lte('estimated_roi_percent', maxRoi);
    if (maxMaturityMonths != null) {
      q = q.lte('maturity_months', maxMaturityMonths);
    }
    if (query != null && query.isNotEmpty) {
      q = q.ilike('batch_name', '%$query%');
    }

    final data = await q.order('created_at', ascending: false);
    return (data as List).map((e) => CattleAssetModel.fromJson(e)).toList();
  }

  Future<List<CattleAssetModel>> getTopRatedFarmerListings({int limit = 5}) async {
    final data = await supabase
        .from(AppConstants.tableCattleAssets)
        .select(_select)
        .eq('status', 'active')
        .order('created_at', ascending: false)
        .limit(limit);
    return (data as List).map((e) => CattleAssetModel.fromJson(e)).toList();
  }

  Stream<CattleAssetModel> watchListing(String id) {
    return supabase
        .from(AppConstants.tableCattleAssets)
        .stream(primaryKey: ['id'])
        .eq('id', id)
        .map((rows) => CattleAssetModel.fromJson(rows.first));
  }
}
