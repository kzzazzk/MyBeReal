import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUserRequested extends UserEvent {
  final String email;

  GetUserRequested(this.email);
}
