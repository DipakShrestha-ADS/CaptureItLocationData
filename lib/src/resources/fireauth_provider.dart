import 'package:firebase_auth/firebase_auth.dart';

class FireAuthProvider {
  //getting the instance of the firebase auth
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //this sign in the user user email and password in firebase database for Auth
  Future<AuthResult> signInWithCredentials(
      String email, String password) async {
    return await _firebaseAuth
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then(
      (value) {
        return value;
      },
    );
  }

  //register the user using email and password
  Future<AuthResult> signUp({String email, String password}) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      return value;
    });
  }

  //logout the user form firebase database
  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  //check whether the user is logged in or not
  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  //get current signed in user
  Future<FirebaseUser> getUser() async {
    return (await _firebaseAuth.currentUser().then((value) {
      return value;
    }));
  }
}
