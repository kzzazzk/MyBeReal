import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_be_real/bloc/auth_state.dart';

import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial());

  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignInEvent) {
      yield AuthLoading();

      try {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        final user = userCredential.user;
        yield AuthAuthenticated(user!);
      } catch (e) {
        yield AuthError(e.toString());
      }
    } else if (event is SignOutEvent) {
      yield AuthLoading();

      try {
        await _firebaseAuth.signOut();
        yield AuthUnauthenticated();
      } catch (e) {
        yield AuthError(e.toString());
      }
    }
  }
}
