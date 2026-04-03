import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/supabase_client.dart';
import '../models/investment_model.dart';

class InvestmentRemoteDatasource {
  Future<List<InvestmentModel>> getMyInvestments() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await supabase
        .from(AppConstants.tableInvestments)
        .select('*, cattle_assets(batch_name, primary_image_url)')
        .eq('investor_id', userId)
        .order('purchased_at', ascending: false);
    return (data as List).map((e) => InvestmentModel.fromJson(e)).toList();
  }

  Future<InvestmentModel> getInvestmentById(String id) async {
    final data = await supabase
        .from(AppConstants.tableInvestments)
        .select('*, cattle_assets(batch_name, primary_image_url)')
        .eq('id', id)
        .single();
    return InvestmentModel.fromJson(data);
  }

  Future<String> createPaymentIntent({
    required String cattleAssetId,
    required int shares,
  }) async {
    final response = await supabase.functions.invoke(
      AppConstants.fnCreatePaymentIntent,
      body: {'cattle_asset_id': cattleAssetId, 'shares': shares},
    );
    return response.data['client_secret'] as String;
  }
}
