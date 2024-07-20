import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user {
    return user;
  }

  AuthServices() {}

  Future<bool> login(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true ;
      } else {
        _user = null;
      }
      
    } catch (e) {
      print(e);
    }
    return false;
  }


  Future<void> logout()async {

  }
}
