import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Future<AppUser> signIn({required String email, required String password}) =>
      _datasource.signIn(email: email, password: password);

  @override
  Future<AppUser> signUp({
    required String email,
    required String password,
    required UserRole role,
    String? firstName,
    String? lastName,
  }) =>
      _datasource.signUp(
        email: email,
        password: password,
        role: role,
        firstName: firstName,
        lastName: lastName,
      );

  @override
  Future<void> signOut() => _datasource.signOut();

  @override
  Future<AppUser?> getCurrentUser() => _datasource.getCurrentUser();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _datasource.sendPasswordResetEmail(email);

  @override
  Future<AppUser> updateProfile({
    String? firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    final current = await getCurrentUser();
    if (current == null) throw Exception('Not authenticated');
    return _datasource.updateProfile(
      userId: current.id,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Stream<AppUser?> get authStateChanges => _datasource.authStateChanges;
}
