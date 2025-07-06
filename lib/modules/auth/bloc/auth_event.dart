abstract class AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email, password;
  AuthLoginRequested(this.email, this.password);
}

class AuthRegisterRequested extends AuthEvent {
  final String username, email;
  AuthRegisterRequested(this.username, this.email);
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;
  AuthForgotPasswordRequested(this.email);
}

class AuthAppleLoginRequested extends AuthEvent {}

class AuthTelegramLoginRequested extends AuthEvent {
  final Map<String, dynamic>? telegramPayload;
  AuthTelegramLoginRequested({this.telegramPayload});
}

class AuthLogoutRequested extends AuthEvent {}

class AuthLoggedIn extends AuthEvent {
  final String token, userId;
  AuthLoggedIn(this.token, this.userId);
} 