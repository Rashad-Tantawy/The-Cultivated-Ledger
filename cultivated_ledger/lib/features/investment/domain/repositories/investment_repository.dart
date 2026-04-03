import '../entities/investment.dart';

abstract class InvestmentRepository {
  Future<List<Investment>> getMyInvestments();
  Future<Investment> getInvestmentById(String id);
  Future<String> createPaymentIntent({
    required String cattleAssetId,
    required int shares,
  });
}
