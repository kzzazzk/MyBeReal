import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuthauth = FirebaseAuth.instance;

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuthauth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<UserCredential?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential user = await _firebaseAuthauth.signInWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuthauth.signOut();
  }
}
