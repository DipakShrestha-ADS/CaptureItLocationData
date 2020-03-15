import 'package:captureit/src/models/push_to_firebase_model.dart';
import 'package:captureit/src/utils/strings_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreProvider {
  //get instance of firestore
  Firestore _firestore = Firestore.instance;

  //get if there is user stored in database
  Future<int> getUser(String email, String password) async {
    final QuerySnapshot result = await _firestore
        .collection("users")
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  //store user in firestore database
  Future<void> storeUser(String email, String password) async {
    return _firestore
        .collection("users")
        .document(email)
        .setData({'email': email, 'password': password});
  }

  //send data to firestore database
  Future<int> sendDataToFireStoreDatabase(
      PushToFireBaseModel pushToFireBaseModel) async {
    return await _firestore
        .collection(StringsConstants.pushNotificationDataBaseName)
        .document()
        .setData({
      StringsConstants.numberKey: pushToFireBaseModel.number,
      StringsConstants.p1MessageKey: pushToFireBaseModel.p1Message,
      StringsConstants.s1MessageKey: pushToFireBaseModel.s1Message,
      StringsConstants.s2MessageKey: pushToFireBaseModel.s2Message,
      StringsConstants.storeDateKey: pushToFireBaseModel.dateStored,
      StringsConstants.userEmailKey: pushToFireBaseModel.userEmail,
      StringsConstants.latitudeKey: pushToFireBaseModel.latitude,
      StringsConstants.longituteKey: pushToFireBaseModel.longitude,
    }).then(
      (value) {
        //return 1 to verify if data is sent to database or not
        return 1;
      },
    );
  }
}
