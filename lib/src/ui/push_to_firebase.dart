import 'package:captureit/src/blocs/login/login_bloc.dart';
import 'package:captureit/src/blocs/login/login_bloc_provider.dart';
import 'package:captureit/src/blocs/pushDataToFirebase/push_to_firebase_bloc_provider.dart';
import 'package:captureit/src/ui/widgets/push_to_firebase_form.dart';
import 'package:captureit/src/utils/strings_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login.dart';

class PushToFirebase extends StatefulWidget {
  //signed in auth result for current user details
  final AuthResult _firebaseCurrentAuthResult;

  PushToFirebase(this._firebaseCurrentAuthResult);

  @override
  State<StatefulWidget> createState() {
    return PushToFirebaseState();
  }
}

class PushToFirebaseState extends State<PushToFirebase> {
  //creating object for LoginBloc
  LoginBloc _loginBloc;

  final _scaffoldKey = GlobalKey();

  @override
  void didChangeDependencies() {
    //initiating LoginBloc object getting LoginBloc object from LoginBlocProvider
    //LoginBloc object can be accessed from here because we had wrapped our root widget with LoginBlocProvider
    _loginBloc = LoginBlocProvider.of(context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //closing all stream inside LoginBloc on this widget dispose
    _loginBloc.dispose();

    super.dispose();
  }

  //for datetime record of current back pressed by user
  DateTime currentBackPressTime;
  //handle when app is going to close
  Future<bool> onWillPop() {
    //get the now date and time
    DateTime now = DateTime.now();

    /*check the differences between back press time and current (now) date time
    if less then 2 sec than listen another backPress event to close the application*/
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg:
              'You will be logged out! Press back again to logout & close this app.',
          backgroundColor: Colors.deepOrange,
          textColor: Colors.white,
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
      return Future.value(false);
    }
    _loginBloc.signOut();
    Navigator.pop(context);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: PushToFireBaseBlocProvider(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: myAppBar(),
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      top: 10.0,
                    ),
                  ),
                  profileViewCard(),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10.0,
                    ),
                  ),
                  new PushToFireBaseForm(widget._firebaseCurrentAuthResult),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //top profile card view to display name and email of current user
  Widget profileViewCard() {
    return Card(
      elevation: 10.0,
      margin: EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        width: 300.0,
        height: 200.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.perm_identity,
                size: 60.0,
                color: Colors.deepOrange,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                  top: 8.0,
                ),
                child: Text(
                  StringsConstants.welcomeText.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
              Text(
                '${StringsConstants.nameText}: ',
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Text(
                    /*getting display name from current auth result if null then text before the @ from email
                will be displayed here*/
                    '${widget._firebaseCurrentAuthResult.user.displayName ?? widget._firebaseCurrentAuthResult.user.email.split('@')[0]}',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                ),
                child: Text(
                  'Email: ',
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  Text(
                    //email of current user is diplayed here
                    '${widget._firebaseCurrentAuthResult.user.email}',
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //my app bar widget function
  Widget myAppBar() {
    return AppBar(
      title: Text(
        StringsConstants.appTitle,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      actions: <Widget>[
        InkWell(
          onTap: () {
            showMyCustomAlertDialog(
              title: 'Logout',
              message:
                  'You are about to logout. Are you sure, you wanna logout?',
              positiveBtnText: 'Logout',
              negativeBtnText: 'Cancel',
            );
          },
          borderRadius: BorderRadius.circular(10.0),
          child: Row(
            children: <Widget>[
              Icon(Icons.flip_to_back),
              Padding(
                padding: const EdgeInsets.only(
                  left: 4.0,
                  right: 4.0,
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        /* PopupMenuButton(
          icon: Icon(
            Icons.flip_to_back,
            color: Colors.white,
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                //setting value to item as its id for select operation
                value: 1,
                child: Text(
                  StringsConstants.logoutText,
                  style: new TextStyle(color: Colors.deepPurple),
                ),
              ),
            ];
          },
          onSelected: (value) {
            //if selected value is 1, then it is logout button
            if (value == 1) {
              //signing out the current user
              _loginBloc.signOut();
              //replacing the current screen with LoginUi Screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginUi();
                  },
                ),
              );
            }
          },
        ),*/
      ],
    );
  } // myAppBar

  showMyCustomAlertDialog(
      {String title,
      String message,
      String positiveBtnText,
      String negativeBtnText}) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: this.context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return myCustomAlertDialog(
              title, message, positiveBtnText, negativeBtnText);
        },
      );
    });
  }

  Widget myCustomAlertDialog(
    String title,
    String message,
    String positiveBtnText,
    String negativeBtnText,
  ) {
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.deepPurple,
        ),
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
        style: TextStyle(
          color: Colors.blueGrey,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            negativeBtnText,
            style: TextStyle(
              color: Colors.deepPurple,
            ),
          ),
        ),
        FlatButton(
          onPressed: () {
            //signing out the current user
            _loginBloc.signOut();
            //replacing the current screen with LoginUi Screen
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return LoginUi();
                },
              ),
            );
          },
          child: Text(
            positiveBtnText,
            style: TextStyle(
              color: Colors.deepPurple,
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
    );
  }
}
