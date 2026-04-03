import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/supabase_client.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class AuthRemoteDatasource {
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user == null) {
        throw const AuthException('Sign in failed. Please try again.');
      }
      return await _fetchUserProfile(response.user!.id);
    } on AuthException {
      rethrow;
    } on AuthApiException catch (e) {
      throw AuthException(e.message, code: e.statusCode?.toString());
    } catch (e) {
      throw AuthException('An unexpected error occurred: $e');
    }
  }

  Future<UserModel> signUp({
    required String email,
    required String password,
    required UserRole role,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'role': role.name,
          'first_name': firstName,
          'last_name': lastName,
        },
      );
      if (response.user == null) {
        throw const AuthException('Sign up failed. Please try again.');
      }
      // Update the users table with name
      if (firstName != null || lastName != null) {
        await supabase.from(AppConstants.tableUsers).update({
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
        }).eq('id', response.user!.id);
      }
      return await _fetchUserProfile(response.user!.id);
    } on AuthException {
      rethrow;
    } on AuthApiException catch (e) {
      throw AuthException(e.message, code: e.statusCode?.toString());
    } catch (e) {
      throw AuthException('An unexpected error occurred: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw AuthException('Sign out failed: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final session = supabase.auth.currentSession;
    if (session == null) return null;
    try {
      return await _fetchUserProfile(session.user.id);
    } catch (_) {
      return null;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } on AuthApiException catch (e) {
      throw AuthException(e.message);
    }
  }

  Future<UserModel> updateProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? avatarUrl,
  }) async {
    final updates = <String, dynamic>{
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    };
    await supabase
        .from(AppConstants.tableUsers)
        .update(updates)
        .eq('id', userId);
    return await _fetchUserProfile(userId);
  }

  Stream<UserModel?> get authStateChanges {
    return supabase.auth.onAuthStateChange.asyncMap((event) async {
      final user = event.session?.user;
      if (user == null) return null;
      try {
        return await _fetchUserProfile(user.id);
      } catch (_) {
        return null;
      }
    });
  }

  Future<UserModel> _fetchUserProfile(String userId) async {
    final data = await supabase
        .from(AppConstants.tableUsers)
        .select()
        .eq('id', userId)
        .single();
    return UserModel.fromJson(data);
  }
}
