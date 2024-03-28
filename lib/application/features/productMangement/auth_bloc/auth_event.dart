part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class CheckLoginStatusEvent extends AuthEvent {
  // final String mPin;
  // CheckLoginStatusEvent({required this.mPin});
}

class checkMpinEvent extends AuthEvent {
  final String mPin;
  checkMpinEvent({required this.mPin});
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  LoginEvent({required this.email, required this.password});
}

class SignupEvent extends AuthEvent {
  final UserModel user;
  SignupEvent({required this.user});
}

class LogoutEvent extends AuthEvent {}
