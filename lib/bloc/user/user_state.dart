import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  final User user2;

  UserLoaded(this.user, this.user2);

  @override
  List<Object> get props => [user];
}

class UserError extends UserState {
  final String errorType;
  final String? errorMessage;

  UserError(this.errorType, {this.errorMessage});

  @override
  List<Object> get props =>
      [errorType, if (errorMessage != null) errorMessage!];
}
