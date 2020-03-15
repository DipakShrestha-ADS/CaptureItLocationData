import 'dart:async';

import 'package:captureit/src/models/push_to_firebase_model.dart';
import 'package:captureit/src/resources/repository/location_repository.dart';
import 'package:captureit/src/resources/repository/push_to_firebase_repository.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class PushToFireBaseBloc {
  final _pushToFirebaseRepository = PushToFireBaseRepository();

  final _locationRepository = LocationRepository();

  String _latitude = '';
  String _longitude = '';

  /*Initialize the Stream Controller for all the text form field or
  edit text field using RxDart library*/
  /*Listening to the stream before any input*/
  final _numberFieldController = BehaviorSubject<int>();
  final _p1MessageController = BehaviorSubject<String>();
  final _s1MessageController = BehaviorSubject<String>();
  final _s2MessageController = BehaviorSubject<String>();

  final _showProgressBarController = BehaviorSubject<bool>();

  //getters for the stream from the respective stream controller
  //Observable is similar to Stream
  Observable<int> get getNumber =>
      _numberFieldController.stream.transform(_validateNumber);
  Observable<String> get getP1Message =>
      _p1MessageController.stream.transform(_validateP1Message);
  Observable<String> get getS1Message =>
      _s1MessageController.stream.transform(_validateS1Message);
  Observable<String> get getS2Message =>
      _s2MessageController.stream.transform(_validateS2Message);

  //stream for progress bar
  Observable<bool> get getIsShowProgressBar =>
      _showProgressBarController.stream;

  //setters function for the stream controller using sink from respective field
  Function(int) get setNumber => _numberFieldController.sink.add;
  Function(String) get setP1Message => _p1MessageController.sink.add;
  Function(String) get setS1Message => _s1MessageController.sink.add;
  Function(String) get setS2Message => _s2MessageController.sink.add;

  //add value to the stream controll whether to show progress bar or not
  Function(bool) get setIsShowProgressBar =>
      _showProgressBarController.sink.add;

  //send data to firebase
  Future<int> sendDataToFireStoreDatabase(String userEmail) {
    String dateString = new DateTime.now().toString();
    PushToFireBaseModel pushToFireBaseModel = PushToFireBaseModel(
        _numberFieldController.value,
        _p1MessageController.value,
        _s1MessageController.value,
        _s2MessageController.value,
        dateString,
        userEmail,
        _latitude,
        _longitude);

    return _pushToFirebaseRepository
        .sendDataToFireStoreDatabase(pushToFireBaseModel);
  }

  //validation for number field
  //this stream transformer transforms string to new string after handling data
  final _validateNumber =
      StreamTransformer<int, int>.fromHandlers(handleData: (number, sink) {
    //check if the number is null or not
    if (number == null) {
      sink.addError('Please add the required field number !');
      return;
    }
    //check if number is empty or not
    if (number.toString().isEmpty) {
      sink.addError('Number field cannot be empty !');
      return;
    }

    //if number is not null and non empty than add number back to the same stream controller
    sink.add(number);
  });

  //validation for p1 message field
  final _validateP1Message =
      StreamTransformer<String, String>.fromHandlers(handleData: (p1, sink) {
    //check if the p1 Message is null or not
    if (p1 == null) {
      sink.addError('Please add the required field p1 message !');
      return;
    }
    //check if p1 message is empty or not
    if (p1.isEmpty) {
      sink.addError('P1 message field cannot be empty !');
      return;
    }

    //if p1 message is not null and non empty than add it back to the same stream controller
    sink.add(p1);
  });

  //validation for s1 message field
  final _validateS1Message = StreamTransformer<String, String>.fromHandlers(
      handleData: (s1Message, sink) {
    //check if the s1 message is null or not
    if (s1Message == null) {
      sink.addError('Please add the required field s1 message !');
      return;
    }
    //check if s1 message is empty or not
    if (s1Message.isEmpty) {
      sink.addError('S1 message field cannot be empty !');
      return;
    }

    //if s1 message is not null and non empty than add it back to the same stream controller
    sink.add(s1Message);
  });

  //validation for s2 message link field
  final _validateS2Message = StreamTransformer<String, String>.fromHandlers(
      handleData: (s2Message, sink) {
    //check if the s2 message is null or not
    if (s2Message == null) {
      sink.addError('Please add the required field s2 message !');
      return;
    }
    //check if s2 message is empty or not
    if (s2Message.isEmpty) {
      sink.addError('S2 Message field cannot be empty !');
      return;
    }

    //if s2 message is not null and non empty than add s2 message back to the same stream controller
    sink.add(s2Message);
  });

  //function to close all the stream controller when the widget get disposed
  void dispose() async {
    await _numberFieldController.drain();
    _numberFieldController.close();
    await _p1MessageController.drain();
    _p1MessageController.close();
    await _s1MessageController.drain();
    _s1MessageController.close();
    await _s2MessageController.drain();
    _s2MessageController.close();
    await _showProgressBarController.drain();
    _showProgressBarController.close();
  }

  bool validateAllForm() {
    int number = _numberFieldController.value;
    String p1Message = _p1MessageController.value;
    String s1Message = _s1MessageController.value;
    String s2Message = _s2MessageController.value;

    if (number == null || number.toString().isEmpty) {
      setNumber(number);
      return false;
    }
    if (p1Message == null || p1Message.isEmpty) {
      setP1Message(p1Message);
      return false;
    }
    if (s2Message == null || s2Message.isEmpty) {
      setS2Message(s2Message);
      return false;
    }
    if (s1Message == null || s1Message.isEmpty) {
      setS1Message(s1Message);
      return false;
    }

    return true;
  }

  //get location latitude and longitude also checks the availability of location service
  //and it location permission is garanted or not; if no treques service and location permission
  void getLocationData() async {
    _locationRepository.checkIfLocationServiceEnabled().then((serviceEnabled) {
      if (serviceEnabled) {
        _locationRepository
            .checkIfLocationPermissionGranted()
            .then((permissionGranted) {
          if (permissionGranted) {
            _locationRepository.getLocationDAta().then((locationData) {
              _latitude = locationData.latitude.toString();
              _longitude = locationData.longitude.toString();
              print('latitude: $_latitude logitude: $_longitude');
            });
          } else {
            Fluttertoast.showToast(
              msg:
                  'Permission cannot be granted from here, please manually give the location permissoin for this app',
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_SHORT,
            );
          }
        });
      }
    });
  }
}
