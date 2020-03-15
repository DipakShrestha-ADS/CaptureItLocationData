import 'package:flutter/cupertino.dart';

import 'login_bloc.dart';

/*This class holds the object of BLoC i.e. LoginBloc and provide it to all its children widget*/
class LoginBlocProvider extends InheritedWidget {
  /*Holding the object of LoginBloc*/
  final loginBloc = LoginBloc();

  LoginBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) {
    return true;
  }

  /*Making available the object of LoginBloc for all it's children*/
  static LoginBloc of(BuildContext context) {
    return (context
        .dependOnInheritedWidgetOfExactType<LoginBlocProvider>()
        .loginBloc);
  }
}
