import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user {
    return user;
  }

  AuthServices() {}

  Future<void> login(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
      } else {
        _user = null;
      }
    } catch (e) {
      print(e);
    }
  }


  Future<void> logout()async {

  }
}
