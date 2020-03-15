import 'dart:async';

import 'package:captureit/src/resources/repository/login_repository.dart';
import 'package:captureit/src/utils/strings_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

/*This class contains all the business logic that is indeed for the login*/
class LoginBloc {
  //initialize of login repository
  final _loginRepository = LoginRepository();

  //initialize the Stream controller for all login forms' text field
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  //initialize stream controller for the status is signedIn or not to show progress bar
  final _isSignedIn = PublishSubject<bool>();
  //initialize stream controller for the status is signedUp or not to show progress bar
  final _isSignedUp = PublishSubject<bool>();
  //stream controller initialize to toggle the password visible
  final _showPassword = BehaviorSubject<bool>();

  //getting observable String  or stream from the _email stream controller with validation #transform
  Observable<String> get email => _email.stream.transform(_validateEmail);

  //getting password as stream from ther _passowrd stream controller performing the validation using transform
  Observable<String> get password =>
      _password.stream.transform(_validatePassword);

  //getting signInStatus and sign up stream form stream controller
  Observable<bool> get signInStatus => _isSignedIn.stream;

  Observable<bool> get signUpStatus => _isSignedUp.stream;

  //getting boolean value for password toggle as stream from stream controller
  Observable<bool> get getShowPassword => _showPassword.stream;

  //if change in text field then add to respective stream controller for processing
  Function(String) get changeEmail => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  Function(bool) get showSignUpProgressBar => _isSignedUp.sink.add;

  Function(bool) get setShowPassword => _showPassword.sink.add;

  //validation for email using stream transformer inside stream controller
  //return error if not validate else add to the email stream controller
  final _validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      //regex pattern for email validation
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      //initialization for regex expression using above pattern
      RegExp regex = new RegExp(pattern);

      if (email == null) {
        sink.addError('Please add your email address !');
        return;
      }
      if (email.isEmpty) {
        sink.addError('Please add your email address !');
        return;
      }

      //if the given input to email controller doesnot match with the regex pattern return error
      if (!regex.hasMatch(email)) {
        sink.addError(StringsConstants.emailValidateErrorMsg);
        return;
      }

      //adding email back to the controller after validation
      sink.add(email);
    },
  );

  //validation for password inside stream controller
  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password == null) {
        sink.addError('Please add your account password !');
        return;
      }

      //validate if passowrd length is greater than six or not
      if (password.isEmpty || password.length < 6) {
        sink.addError(StringsConstants.passwordValidateErrorMsg);
        return;
      }

      //adding password back to the stream controller after processing
      sink.add(password);
    },
  );

  //function used for sign in with credentials: Email & Password to sign in user inside firebase
  Future<AuthResult> signInWithCredentials() {
    return _loginRepository.signInWithCredentials(
        _email.value, _password.value);
  }

  //signup fuction to register account in firebase
  Future<AuthResult> signUpWithCredentials() {
    return _loginRepository.signUpWithCredentials(
        _email.value, _password.value);
  }

  //signout function to logout the current user
  Future<void> signOut() {
    return _loginRepository.signOut();
  }

  //check whether the user is signed in or not
  Future<bool> isSignedIn() {
    return _loginRepository.isSignedIn();
  }

  //get the current signed in user
  Future<FirebaseUser> getCurrentUser() {
    return _loginRepository.getCurrentUser();
  }

  //method to close all the stream controller
  void dispose() async {
    //destroying all the stream controller
    await _email.drain();
    _email.close();
    await _password.drain();
    _password.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
    await _showPassword.drain();
    _showPassword.close();
    await _isSignedUp.drain();
    _isSignedUp.close();
  }

  //validation function when login or signup button is pressed
  //return false if validation fails else return true
  bool validateFields() {
    String email = _email.value;
    String password = _password.value;
    if (email == null) {
      changeEmail(email);
      return false;
    }
    if (email.isEmpty) {
      changeEmail(email);
      return false;
    }
    if (!email.contains('@')) {
      changeEmail(email);
      return false;
    }

    if (password == null) {
      changePassword(password);
      return false;
    }
    if (password.isEmpty || password.length < 6) {
      changePassword(password);
      return false;
    }
    return true;
  }
}
