part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {}

class Authenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class Loading extends AuthState {
  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String errorType;
  final String? errorMessage;

  AuthError(this.errorType, {this.errorMessage});

  @override
  List<Object> get props =>
      [errorType, if (errorMessage != null) errorMessage!];
}
