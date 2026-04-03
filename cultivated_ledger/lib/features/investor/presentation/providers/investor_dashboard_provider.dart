import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../investment/presentation/providers/investment_provider.dart';
import '../../../market/presentation/providers/market_provider.dart';
import '../../../wallet/presentation/providers/wallet_provider.dart';

/// Aggregates all data needed for the investor dashboard in one place.
/// Screens watch this provider instead of calling multiple providers separately.
final investorDashboardProvider = FutureProvider((ref) async {
  final investments = await ref.watch(myInvestmentsProvider.future);
  final opportunities = await ref.watch(activeListingsProvider.future);
  final topFarmers = await ref.watch(topListingsProvider.future);
  final balance = await ref.watch(walletBalanceProvider.future);

  final active = investments.where((i) => !i.isExited).toList();
  final totalValue = active.fold(0.0, (sum, i) => sum + i.currentValue);
  final totalInvested = active.fold(0.0, (sum, i) => sum + i.totalInvested);
  final roi = totalInvested > 0
      ? ((totalValue - totalInvested) / totalInvested) * 100
      : 0.0;

  return (
    totalPortfolioValue: totalValue,
    roiPercent: roi,
    activeAssetCount: active.length,
    walletBalance: balance,
    opportunities: opportunities.take(6).toList(),
    topFarmerListings: topFarmers,
    recentInvestments: investments.take(5).toList(),
  );
});
