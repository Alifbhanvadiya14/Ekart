import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  String userUid;

  User userData;

  String errorMessage = "";

  String get getErrorMessage => errorMessage;
  String get getUserUid => userUid;
  User get getUser => userData;

  Future createAccount(String email, String password, String username) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;
      userUid = user.uid;
      //username = username;

      sharedPreferences.setString("uid", userUid);
      //sharedPreferences.setString("username", username);
      sharedPreferences.setString("userEmail", userData.email);
      print("User id is $userUid");
      print("User data is $user");
      notifyListeners();
    } catch (e) {
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = "Email Already exits";
          print(errorMessage);
          break;
        case 'invalid-email':
          errorMessage = "Invalid Email";
          print(errorMessage);
          break;
      }
    }
  }

  Future loginAccount(String email, String password) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user;
      userUid = user.uid;
      userData = user;
      sharedPreferences.setString("uid", userUid);
      //sharedPreferences.setString("username", userData.displayName);
      sharedPreferences.setString("userEmail", userData.email);
      print("User id is $userUid");
      //print("User data is $user");
      notifyListeners();
    } catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "User Not Found";
          print(errorMessage);
          break;
        case 'wrong-password':
          errorMessage = "Oops, Wrong Password";
          print(errorMessage);
          break;
        case 'invalid-email':
          errorMessage = "Invalid Email";
          print(errorMessage);
          break;
      }
    }
  }

  Future signOut() async {
    return firebaseAuth.signOut();
  }

  Future signInWithGoogle() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);

    final UserCredential userCredential =
        await firebaseAuth.signInWithCredential(authCredential);

    final User user = userCredential.user;
    userData = user;
    userUid = user.uid;
    sharedPreferences.setString("uid", userUid);
    //sharedPreferences.setString("username", userData.displayName);
    sharedPreferences.setString("userEmail", userData.email);
    //print(user);
    notifyListeners();
  }

  Future googleSignOut() async {
    return googleSignIn.signOut();
  }
}
