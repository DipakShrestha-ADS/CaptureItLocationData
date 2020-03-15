import 'package:captureit/src/blocs/pushDataToFirebase/push_to_firebase_bloc.dart';
import 'package:captureit/src/blocs/pushDataToFirebase/push_to_firebase_bloc_provider.dart';
import 'package:captureit/src/utils/strings_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PushToFireBaseForm extends StatefulWidget {
  //signed in auth result for current user details
  final AuthResult _firebaseCurrentAuthResult;

  PushToFireBaseForm(this._firebaseCurrentAuthResult);

  @override
  State<StatefulWidget> createState() {
    return PushToFireBaseFormState();
  }
}

class PushToFireBaseFormState extends State<PushToFireBaseForm> {
  //creating object for PushToFireBaseBloc
  PushToFireBaseBloc _pushToFireBaseBloc;

  @override
  void didChangeDependencies() {
    //initiating PushToFireBaseBloc object
    _pushToFireBaseBloc = PushToFireBaseBlocProvider.of(context);
    //gettting location data
    _pushToFireBaseBloc.getLocationData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //need to close all the steam controller inside the PushToFireBaseBloc when this widget disposed
    _pushToFireBaseBloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    titleFocusNode.unfocus();
    abstractMessageFocusNode.unfocus();
    detailedMessageFocusNode.unfocus();
    hyperlinkFocusNode.unfocus();
    return Container(
      child: Form(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30.0),
              ),
              numberField(),
              Container(
                margin: EdgeInsets.only(top: 20.0),
              ),
              abstractMessageField(),
              Container(
                margin: EdgeInsets.only(top: 20.0),
              ),
              hyperLinkField(),
              Container(
                margin: EdgeInsets.only(top: 20.0),
              ),
              detailedMessageField(),
              Container(
                margin: EdgeInsets.only(top: 30.0),
              ),
              publishButton(),
            ],
          ),
        ),
      ),
    );
  }

  //initiating focus node for title edit field
  final titleFocusNode = new FocusNode();

  //Edit text field for Title
  Widget numberField() {
    return StreamBuilder(
      stream: _pushToFireBaseBloc.getNumber,
      builder: (context, titleSnapshot) {
        return TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: StringsConstants.numberLabel,
            icon: Icon(Icons.confirmation_number),
            border: OutlineInputBorder(),
            errorText: titleSnapshot.error,
          ),
          onChanged: (title) {
            _pushToFireBaseBloc.setNumber(int.parse(title));
          },
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          focusNode: titleFocusNode,
          onFieldSubmitted: (value) {
            //on submitted this title edit field: focusing to the next, abstract message field
            FocusScope.of(context).requestFocus(abstractMessageFocusNode);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  //initiating focus node for abstract message edit field
  final abstractMessageFocusNode = new FocusNode();

  //Edit text field for abstract message
  Widget abstractMessageField() {
    return StreamBuilder(
      stream: _pushToFireBaseBloc.getP1Message,
      builder: (context, absMsgSnapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: StringsConstants.P1Label,
            icon: Icon(Icons.message),
            border: OutlineInputBorder(),
            errorText: absMsgSnapshot.error,
          ),
          focusNode: abstractMessageFocusNode,
          onChanged: (absMsg) {
            _pushToFireBaseBloc.setP1Message(absMsg);
          },
          onFieldSubmitted: (value) {
            //on submitted this abstract message edit field: focusing to the next, detailed message field
            FocusScope.of(context).requestFocus(hyperlinkFocusNode);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  //initiating focus node for detailed message edit field
  final detailedMessageFocusNode = new FocusNode();

  //Edit text Field for Multiline Text
  Widget detailedMessageField() {
    return StreamBuilder(
      stream: _pushToFireBaseBloc.getS1Message,
      builder: (context, detailSnapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: StringsConstants.S1Label,
            icon: Icon(Icons.textsms),
            border: OutlineInputBorder(),
            errorText: detailSnapshot.error,
          ),
          keyboardType: TextInputType.multiline,
          maxLines: null,
          focusNode: detailedMessageFocusNode,
          onChanged: (detailMsg) {
            _pushToFireBaseBloc.setS1Message(detailMsg);
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }

  //initiating focus node for hyperlink edit field
  final hyperlinkFocusNode = new FocusNode();

  //Edit text field for Hyperlink
  Widget hyperLinkField() {
    return StreamBuilder(
      stream: _pushToFireBaseBloc.getS2Message,
      builder: (context, hyperlinkSnapshot) {
        return TextFormField(
          decoration: InputDecoration(
            labelText: StringsConstants.S2Label,
            icon: Icon(Icons.textsms),
            border: OutlineInputBorder(),
            errorText: hyperlinkSnapshot.error,
          ),
          keyboardType: TextInputType.url,
          focusNode: hyperlinkFocusNode,
          onChanged: (hyperlink) {
            _pushToFireBaseBloc.setS2Message(hyperlink);
          },
          onFieldSubmitted: (hyperlink) {
            FocusScope.of(context).requestFocus(detailedMessageFocusNode);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }

  //publish button to send data in firebase
  Widget publishButton() {
    return StreamBuilder(
      initialData: false,
      stream: _pushToFireBaseBloc.getIsShowProgressBar,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.data) {
          return publishButtonWidget();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  //widget for publish button view
  Widget publishButtonWidget() {
    return RaisedButton(
      color: Colors.deepPurple,
      splashColor: Colors.purpleAccent,
      focusColor: Colors.white70,
      onPressed: () {
        if (_pushToFireBaseBloc.validateAllForm()) {
          _pushToFireBaseBloc.setIsShowProgressBar(true);
          _pushToFireBaseBloc
              .sendDataToFireStoreDatabase(
                  widget._firebaseCurrentAuthResult.user.email)
              .then((value) {
            if (value == 1) {
              showSnackMessage(
                  'Successfully send data to Firebase Database. 😍');
              _pushToFireBaseBloc.setIsShowProgressBar(false);
            }
          }).catchError((e) {
            showSnackMessage('Error got ${e.message}');
            _pushToFireBaseBloc.setIsShowProgressBar(false);
          });
        } else {
          showSnackMessage('Some of the field contains error !');
        }
      },
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          StringsConstants.storeButtonText,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  void showSnackMessage(String msg) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.deepOrange,
      duration: new Duration(seconds: 2),
      elevation: 8.0,
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
