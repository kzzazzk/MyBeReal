import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_be_real/repositories/auth_repository.dart';
import 'package:my_be_real/utils/constants.dart';

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
          Constants.authUserEmail = user.user!.email!;
          Constants.otherUserEmail =
              Constants.authUserEmail == dotenv.env['ZAKA_ID']
                  ? dotenv.env['ADRI_ID']!
                  : dotenv.env['ZAKA_ID']!;
        } else {
          emit(AuthError("Credenciales incorrectos.",
              errorMessage:
                  "Contacta con un administrador si crees que es un error."));
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
