import 'package:captureit/src/blocs/pushDataToFirebase/push_to_firebase_bloc.dart';
import 'package:flutter/material.dart';

class PushToFireBaseBlocProvider extends InheritedWidget {
  final pushToFireBaseBloc = PushToFireBaseBloc();

  PushToFireBaseBlocProvider({Key key, Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  static PushToFireBaseBloc of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<PushToFireBaseBlocProvider>()
        .pushToFireBaseBloc);
  }
}
