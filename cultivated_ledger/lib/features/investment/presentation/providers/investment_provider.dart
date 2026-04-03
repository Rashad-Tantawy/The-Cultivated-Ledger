import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/investment_remote_datasource.dart';
import '../../data/repositories/investment_repository_impl.dart';
import '../../domain/entities/investment.dart';
import '../../domain/repositories/investment_repository.dart';

final investmentRemoteDatasourceProvider =
    Provider((_) => InvestmentRemoteDatasource());

final investmentRepositoryProvider = Provider<InvestmentRepository>((ref) =>
    InvestmentRepositoryImpl(ref.watch(investmentRemoteDatasourceProvider)));

final myInvestmentsProvider = FutureProvider<List<Investment>>((ref) =>
    ref.watch(investmentRepositoryProvider).getMyInvestments());

final portfolioSummaryProvider = Provider((ref) {
  final investments = ref.watch(myInvestmentsProvider).valueOrNull ?? [];
  final active = investments.where((i) => !i.isExited).toList();
  final totalInvested = active.fold(0.0, (sum, i) => sum + i.totalInvested);
  final totalValue = active.fold(0.0, (sum, i) => sum + i.currentValue);
  final roi = totalInvested > 0
      ? ((totalValue - totalInvested) / totalInvested) * 100
      : 0.0;
  return (
    totalValue: totalValue,
    totalInvested: totalInvested,
    roiPercent: roi,
    activeCount: active.length,
  );
});
