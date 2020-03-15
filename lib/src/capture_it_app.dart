import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'blocs/login/login_bloc_provider.dart';
import 'ui/login.dart';

class CaptureItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*Here we use BLoC: Business Logic Components Architecture to build our App.*/
    /*Wrapping MaterialApp by InheritedWidget: LoginBlocProvider help to
      access the LoginBloc object throughout the widget tree.*/
    return LoginBlocProvider(
      //also wrapping with PushToFireBaseBlocProvider to give access of PushToFireBaseBloc instance for business logic
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
          accentColor: Colors.purpleAccent,
        ),
        home: LoginUi(),
      ),
    );
  }
}
