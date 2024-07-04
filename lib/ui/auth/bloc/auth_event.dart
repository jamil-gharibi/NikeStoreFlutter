part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthButtonIsClicked extends AuthEvent {
  final String userName;
  final String password;

  const AuthButtonIsClicked({required this.userName, required this.password});
}

class AuthModeChangeIsClicked extends AuthEvent {}
