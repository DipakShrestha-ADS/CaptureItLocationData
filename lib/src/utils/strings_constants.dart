class StringsConstants {
  // app main title constant
  static const String appTitle = "Capture IT";

  //constant related to login and signup
  static const String emailHint = "Enter Email ID";
  static const String passwordHint = "Enter Password";
  static const String login = "Login";
  static const String signUp = "Signup";
  static const String emailValidateErrorMsg = "Please enter a valid email id !";
  static const String passwordValidateErrorMsg =
      "Password length must be greater than or equal to 6 !";

  //constant related to push to firebase screen
  static const String numberLabel = "Number";
  static const String P1Label = "P1 Message";
  static const String S1Label = "S1 Message";
  static const String S2Label = "S2 Message";
  static const String storeButtonText = "Store";

  //constant relatedd to profile card inside push to firebase screeen
  static const String welcomeText = "Welcome";
  static const String nameText = "Name";

  //appbar action's logout constant
  static const String logoutText = "Logout";

  //firebase database: firestore related constant
  //these constant is the key for the firestore database in firebase
  static const String pushNotificationDataBaseName = "captureData";
  static const String numberKey = "number";
  static const String p1MessageKey = "p1Message";
  static const String s1MessageKey = "s1Message";
  static const String s2MessageKey = "s2Message";
  static const String storeDateKey = "storedDate";
  static const String userEmailKey = "userEmail";
  static const String latitudeKey = "latitude";
  static const String longituteKey = "longitude";
}
