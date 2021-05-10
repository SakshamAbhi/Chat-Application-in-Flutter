import 'package:firebase_auth/firebase_auth.dart';
import 'package:sayit/authenticate/user.dart';

class AuthMethods {
  FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser _userFromFirebase(User user) {
    return user != null ? MyUser(userId: user.uid) : null;
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User firebaseuser = result.user;
      return _userFromFirebase(firebaseuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseuser = result.user;
      return _userFromFirebase(firebaseuser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future forgotPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
