import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/wallet_remote_datasource.dart';

final walletDatasourceProvider = Provider((_) => WalletRemoteDatasource());

final walletBalanceProvider = FutureProvider<double>((ref) =>
    ref.watch(walletDatasourceProvider).getBalance());

final transactionsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) =>
        ref.watch(walletDatasourceProvider).getTransactions());
