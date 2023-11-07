enum AuthStatus {
  authenticated,
  unauthenticated,
}

class AuthState {
  final AuthStatus authStatus;

  const AuthState({
    required this.authStatus,
  });

  factory AuthState.init() {
    return AuthState(
      authStatus: AuthStatus.unauthenticated,
    );
  }

  AuthState copyWith({
    AuthStatus? authStatus,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
    );
  }
}
