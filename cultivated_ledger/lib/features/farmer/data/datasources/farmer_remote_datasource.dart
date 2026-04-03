import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/supabase_client.dart';

class FarmerRemoteDatasource {
  Future<Map<String, dynamic>?> getFarmerProfile(String farmerId) async {
    final data = await supabase
        .from(AppConstants.tableFarmerProfiles)
        .select()
        .eq('id', farmerId)
        .maybeSingle();
    return data;
  }

  Future<Map<String, dynamic>?> getMyFarmerProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return null;
    return getFarmerProfile(userId);
  }

  Future<List<Map<String, dynamic>>> getMyListings() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await supabase
        .from(AppConstants.tableCattleAssets)
        .select()
        .eq('farmer_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(data as List);
  }

  Future<Map<String, dynamic>> createListing(
      Map<String, dynamic> listing) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');
    final data = await supabase
        .from(AppConstants.tableCattleAssets)
        .insert({...listing, 'farmer_id': userId, 'shares_remaining': listing['total_shares']})
        .select()
        .single();
    return data;
  }

  Future<void> updateListing(
      String id, Map<String, dynamic> updates) async {
    await supabase
        .from(AppConstants.tableCattleAssets)
        .update({...updates, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', id);
  }
}
