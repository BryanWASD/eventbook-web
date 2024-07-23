part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponseDto response;

  LoginSuccess(this.response);
}

class LoginChecked extends LoginState {}

class Logout extends LoginState {}

class LoginError extends LoginState {
  // final String error;

  // LoginFailure(this.error);
}
