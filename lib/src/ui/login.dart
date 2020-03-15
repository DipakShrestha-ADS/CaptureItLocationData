import 'package:captureit/src/ui/widgets/sign_in_form.dart';
import 'package:flutter/material.dart';

class LoginUi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.perm_identity),
            Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                '/',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10.0,
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.person_add),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: Colors.white70,
        ),
        alignment: Alignment(0.0, 0.0),
        child: SignInForm(),
      ),
    );
  }
}
