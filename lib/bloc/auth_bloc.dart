import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_be_real/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(Unauthenticated()) {
    on<SignInRequested>((event, emit) async {
      emit(Loading());

      try {
        UserCredential? user = await authRepository.signIn(
            email: event.email, password: event.password);
        if (user != null) {
          emit(Authenticated());
        } else {
          emit(AuthError("Invalid credentials.",
              errorMessage:
                  "Contact an administrator if you believe this is an error."));
        }
      } catch (e) {
        emit(AuthError(
          e.toString(),
        ));
      }
    });

    on<SignOutRequested>((event, emit) async {
      if (state is Authenticated) {
        emit(Loading()); // Emit a loading state
        try {
          await authRepository.signOut();
          emit(Unauthenticated());
        } catch (e) {
          emit(AuthError(
            e.toString(),
          ));
        }
      }
    });
  }
}
