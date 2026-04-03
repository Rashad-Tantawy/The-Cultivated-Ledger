import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/cattle_asset_remote_datasource.dart';
import '../../data/repositories/cattle_asset_repository_impl.dart';
import '../../domain/entities/cattle_asset.dart';
import '../../domain/repositories/cattle_asset_repository.dart';

final cattleAssetRemoteDatasourceProvider =
    Provider((_) => CattleAssetRemoteDatasource());

final cattleAssetRepositoryProvider = Provider<CattleAssetRepository>((ref) =>
    CattleAssetRepositoryImpl(ref.watch(cattleAssetRemoteDatasourceProvider)));

// Active listings feed
final activeListingsProvider = FutureProvider<List<CattleAsset>>((ref) =>
    ref.watch(cattleAssetRepositoryProvider).getActiveListings());

// Top listings for dashboard carousel
final topListingsProvider = FutureProvider<List<CattleAsset>>((ref) =>
    ref.watch(cattleAssetRepositoryProvider).getTopRatedFarmerListings());

// Individual listing (with realtime updates)
final listingDetailProvider =
    StreamProvider.family<CattleAsset, String>((ref, id) =>
        ref.watch(cattleAssetRepositoryProvider).watchListing(id));

// Search state
class SearchState {
  final String query;
  final CattleBreed? breed;
  final double? minRoi;
  final double? maxRoi;
  final int? maxMaturityMonths;

  const SearchState({
    this.query = '',
    this.breed,
    this.minRoi,
    this.maxRoi,
    this.maxMaturityMonths,
  });

  SearchState copyWith({
    String? query,
    CattleBreed? breed,
    double? minRoi,
    double? maxRoi,
    int? maxMaturityMonths,
    bool clearBreed = false,
  }) =>
      SearchState(
        query: query ?? this.query,
        breed: clearBreed ? null : (breed ?? this.breed),
        minRoi: minRoi ?? this.minRoi,
        maxRoi: maxRoi ?? this.maxRoi,
        maxMaturityMonths: maxMaturityMonths ?? this.maxMaturityMonths,
      );
}

final searchStateProvider = StateProvider((_) => const SearchState());

final searchResultsProvider = FutureProvider<List<CattleAsset>>((ref) {
  final search = ref.watch(searchStateProvider);
  return ref.watch(cattleAssetRepositoryProvider).searchListings(
        query: search.query.isEmpty ? null : search.query,
        breed: search.breed,
        minRoi: search.minRoi,
        maxRoi: search.maxRoi,
        maxMaturityMonths: search.maxMaturityMonths,
      );
});
