import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/supabase_client.dart';

class WalletRemoteDatasource {
  Future<double> getBalance() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return 0.0;
    final data = await supabase
        .from(AppConstants.tableUsers)
        .select('wallet_balance')
        .eq('id', userId)
        .single();
    return (data['wallet_balance'] as num).toDouble();
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return [];
    final data = await supabase
        .from(AppConstants.tableTransactions)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
    return List<Map<String, dynamic>>.from(data as List);
  }
}
