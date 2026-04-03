import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository _repository;
  SignUpUseCase(this._repository);

  Future<AppUser> call({
    required String email,
    required String password,
    required UserRole role,
    String? firstName,
    String? lastName,
  }) {
    return _repository.signUp(
      email: email,
      password: password,
      role: role,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
