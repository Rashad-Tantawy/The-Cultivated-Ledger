import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/farmer_remote_datasource.dart';

final farmerDatasourceProvider = Provider((_) => FarmerRemoteDatasource());

final myFarmerProfileProvider =
    FutureProvider<Map<String, dynamic>?>((ref) =>
        ref.watch(farmerDatasourceProvider).getMyFarmerProfile());

final farmerProfileProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) =>
        ref.watch(farmerDatasourceProvider).getFarmerProfile(id));

final myListingsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) =>
        ref.watch(farmerDatasourceProvider).getMyListings());

// 3-step listing form state
class ListingFormState {
  final String? batchName;
  final String? breed;
  final int? ageMonths;
  final double? weightLbs;
  final String? location;
  final int? healthScore;
  final String? healthNotes;
  final int? totalShares;
  final double? pricePerShare;
  final double? estimatedRoiPercent;
  final int? maturityMonths;
  final bool hasInsurance;
  final String? primaryImageUrl;
  final int currentStep;

  const ListingFormState({
    this.batchName,
    this.breed,
    this.ageMonths,
    this.weightLbs,
    this.location,
    this.healthScore,
    this.healthNotes,
    this.totalShares,
    this.pricePerShare,
    this.estimatedRoiPercent,
    this.maturityMonths,
    this.hasInsurance = false,
    this.primaryImageUrl,
    this.currentStep = 0,
  });

  ListingFormState copyWith({
    String? batchName,
    String? breed,
    int? ageMonths,
    double? weightLbs,
    String? location,
    int? healthScore,
    String? healthNotes,
    int? totalShares,
    double? pricePerShare,
    double? estimatedRoiPercent,
    int? maturityMonths,
    bool? hasInsurance,
    String? primaryImageUrl,
    int? currentStep,
  }) =>
      ListingFormState(
        batchName: batchName ?? this.batchName,
        breed: breed ?? this.breed,
        ageMonths: ageMonths ?? this.ageMonths,
        weightLbs: weightLbs ?? this.weightLbs,
        location: location ?? this.location,
        healthScore: healthScore ?? this.healthScore,
        healthNotes: healthNotes ?? this.healthNotes,
        totalShares: totalShares ?? this.totalShares,
        pricePerShare: pricePerShare ?? this.pricePerShare,
        estimatedRoiPercent: estimatedRoiPercent ?? this.estimatedRoiPercent,
        maturityMonths: maturityMonths ?? this.maturityMonths,
        hasInsurance: hasInsurance ?? this.hasInsurance,
        primaryImageUrl: primaryImageUrl ?? this.primaryImageUrl,
        currentStep: currentStep ?? this.currentStep,
      );

  Map<String, dynamic> toJson() => {
        'batch_name': batchName,
        'breed': breed,
        'age_months': ageMonths,
        'weight_lbs': weightLbs,
        'location': location,
        'health_score': healthScore ?? 0,
        'health_notes': healthNotes ?? '',
        'total_shares': totalShares,
        'price_per_share': pricePerShare,
        'estimated_roi_percent': estimatedRoiPercent,
        'maturity_months': maturityMonths,
        'has_insurance': hasInsurance,
        'primary_image_url': primaryImageUrl,
        'status': 'draft',
      };
}

final listingFormProvider =
    StateNotifierProvider<ListingFormNotifier, ListingFormState>(
        (_) => ListingFormNotifier());

class ListingFormNotifier extends StateNotifier<ListingFormState> {
  ListingFormNotifier() : super(const ListingFormState());

  void update(ListingFormState Function(ListingFormState) updater) {
    state = updater(state);
  }

  void nextStep() => state = state.copyWith(currentStep: state.currentStep + 1);
  void prevStep() => state = state.copyWith(currentStep: state.currentStep - 1);
  void reset() => state = const ListingFormState();
}
