import '../../domain/entities/investment.dart';
import '../../domain/repositories/investment_repository.dart';
import '../datasources/investment_remote_datasource.dart';

class InvestmentRepositoryImpl implements InvestmentRepository {
  final InvestmentRemoteDatasource _datasource;
  InvestmentRepositoryImpl(this._datasource);

  @override
  Future<List<Investment>> getMyInvestments() => _datasource.getMyInvestments();

  @override
  Future<Investment> getInvestmentById(String id) =>
      _datasource.getInvestmentById(id);

  @override
  Future<String> createPaymentIntent({
    required String cattleAssetId,
    required int shares,
  }) =>
      _datasource.createPaymentIntent(
          cattleAssetId: cattleAssetId, shares: shares);
}
