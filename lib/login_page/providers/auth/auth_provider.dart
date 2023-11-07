import 'package:capstone/login_page/exceptions/custom_exception.dart';
import 'package:capstone/login_page/providers/auth/auth_state.dart';
import 'package:capstone/login_page/repositories/auth_repository.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

class AuthProvider extends StateNotifier<AuthState> with LocatorMixin {
  AuthProvider() : super(AuthState.init());

  Future<void> signUp({
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      await read<AuthRepository>().signUp(
        email: email,
        name: name,
        password: password,
      );
    } on CustomException catch (_) {
      rethrow;
    }

  }
}
