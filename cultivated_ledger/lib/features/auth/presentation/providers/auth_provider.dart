import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

// ── Dependency providers ──────────────────────────────────────────────────────

final authRemoteDatasourceProvider = Provider((_) => AuthRemoteDatasource());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider));
});

final signInUseCaseProvider = Provider((ref) =>
    SignInUseCase(ref.watch(authRepositoryProvider)));

final signUpUseCaseProvider = Provider((ref) =>
    SignUpUseCase(ref.watch(authRepositoryProvider)));

final getCurrentUserUseCaseProvider = Provider((ref) =>
    GetCurrentUserUseCase(ref.watch(authRepositoryProvider)));

// ── Auth state stream ─────────────────────────────────────────────────────────

/// Emits the current AppUser, or null when signed out.
/// GoRouter listens to this to enforce guards.
final authStateProvider = StreamProvider<AppUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

// ── Auth notifier ─────────────────────────────────────────────────────────────

class AuthState {
  final AppUser? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({this.user, this.isLoading = false, this.errorMessage});

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) =>
      AuthState(
        user: clearUser ? null : (user ?? this.user),
        isLoading: isLoading ?? this.isLoading,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      );
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final user = await ref.watch(getCurrentUserUseCaseProvider).call();
    return AuthState(user: user);
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(signInUseCaseProvider).call(
            email: email,
            password: password,
          );
      return AuthState(user: user);
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required UserRole role,
    String? firstName,
    String? lastName,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = await ref.read(signUpUseCaseProvider).call(
            email: email,
            password: password,
            role: role,
            firstName: firstName,
            lastName: lastName,
          );
      return AuthState(user: user);
    });
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(AuthState());
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
