import 'package:firebase_auth/firebase_auth.dart';

import '../fireauth_provider.dart';

class LoginRepository {
  //initializing the firebase auth provider object
  final _fireAuthProvider = FireAuthProvider();

  Future<AuthResult> signInWithCredentials(String email, String password) =>
      _fireAuthProvider.signInWithCredentials(email, password);

  Future<AuthResult> signUpWithCredentials(String email, String password) =>
      _fireAuthProvider.signUp(email: email, password: password);

  Future<void> signOut() => _fireAuthProvider.signOut();

  Future<bool> isSignedIn() => _fireAuthProvider.isSignedIn();

  Future<FirebaseUser> getCurrentUser() => _fireAuthProvider.getUser();
}
