import '../entities/user.dart';

abstract class AuthRepository {
  Future<AppUser> signIn({required String email, required String password});

  Future<AppUser> signUp({
    required String email,
    required String password,
    required UserRole role,
    String? firstName,
    String? lastName,
  });

  Future<void> signOut();

  Future<AppUser?> getCurrentUser();

  Future<void> sendPasswordResetEmail(String email);

  Future<AppUser> updateProfile({String? firstName, String? lastName, String? avatarUrl});

  Stream<AppUser?> get authStateChanges;
}
