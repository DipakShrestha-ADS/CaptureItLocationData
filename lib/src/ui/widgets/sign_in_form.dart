import 'package:captureit/src/blocs/login/login_bloc.dart';
import 'package:captureit/src/blocs/login/login_bloc_provider.dart';
import 'package:captureit/src/utils/strings_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../push_to_firebase.dart';

class SignInForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInFormState();
  }
}

class SignInFormState extends State<SignInForm> {
  LoginBloc _loginBloc;

  @override
  void didChangeDependencies() {
    _loginBloc = LoginBlocProvider.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          emailField(),
          Container(
            margin: EdgeInsets.only(
              top: 5.0,
              bottom: 5.0,
            ),
          ),
          passwordField(),
          Container(
            margin: EdgeInsets.only(
              top: 5.0,
              bottom: 15.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              loginButton(),
              signUpButton(),
            ],
          ),
        ],
      ),
    );
  }

  //initiating focus node for password text field
  final passwordFocusNode = FocusNode();

  Widget emailField() {
    return StreamBuilder(
      stream: _loginBloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _loginBloc.changeEmail,
          decoration: InputDecoration(
            labelText: StringsConstants.emailHint,
            icon: Icon(Icons.email),
            errorText: snapshot.error,
          ),
          textInputAction: TextInputAction.next,
          onSubmitted: (val) {
            FocusScope.of(context).requestFocus(passwordFocusNode);
          },
        );
      },
    );
  }

  Widget passwordField() {
    return StreamBuilder<String>(
      stream: _loginBloc.password,
      builder: (context, AsyncSnapshot<String> snapshot) {
        return StreamBuilder(
          initialData: true,
          stream: _loginBloc.getShowPassword,
          builder: (context, AsyncSnapshot<bool> snapshot1) {
            return TextField(
              onChanged: _loginBloc.changePassword,
              focusNode: passwordFocusNode,
              obscureText: snapshot1.hasData ? snapshot1.data : true,
              decoration: InputDecoration(
                icon: Icon(Icons.vpn_key),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: snapshot1.data ? Colors.grey : Colors.deepPurple,
                  ),
                  onPressed: () {
                    _loginBloc.setShowPassword(
                        snapshot1.hasData ? !snapshot1.data : true);
                  },
                ),
                labelText: StringsConstants.passwordHint,
                errorText: snapshot.error,
              ),
            );
          },
        );
      },
    );
  }

  Widget loginButton() {
    return StreamBuilder(
      initialData: false,
      stream: _loginBloc.signInStatus,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.data) {
          return loginButtonWidget();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget loginButtonWidget() {
    return RaisedButton(
      color: Colors.deepPurple,
      splashColor: Colors.purpleAccent,
      focusColor: Colors.white70,
      onPressed: () {
        if (_loginBloc.validateFields()) {
          _loginBloc.showProgressBar(true);
          _loginBloc.signInWithCredentials().then((value) {
            showSnackMessage('logged in by ${value.user.email}');
            _loginBloc.showProgressBar(false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return PushToFirebase(value);
                },
              ),
            );
          }).catchError((e) {
            showSnackMessage(e.message.toString());
            _loginBloc.showProgressBar(false);
          });
        } else {
          showSnackMessage('Email or Password is invalid !');
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      child: Text(
        StringsConstants.login,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget signUpButton() {
    return StreamBuilder(
      initialData: false,
      stream: _loginBloc.signUpStatus,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.data) {
          return signUpButtonWidget();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget signUpButtonWidget() {
    return RaisedButton(
      color: Colors.deepPurple,
      splashColor: Colors.purpleAccent,
      focusColor: Colors.white70,
      onPressed: () {
        if (_loginBloc.validateFields()) {
          _loginBloc.showSignUpProgressBar(true);
          _loginBloc.signUpWithCredentials().then((value) {
            showSnackMessage('Signed up and logged in by ${value.user.email}');
            _loginBloc.showSignUpProgressBar(false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) {
                return PushToFirebase(value);
              }),
            );
          }).catchError((e) {
            showSnackMessage(e.message.toString());
            _loginBloc.showSignUpProgressBar(false);
            //print('error: ${e.message} + full error: ' + e.toString());
          });
        } else {
          showSnackMessage('Email or Password is invalid !');
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      child: Text(
        StringsConstants.signUp,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  void showSnackMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.deepOrange,
      duration: new Duration(seconds: 2),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
