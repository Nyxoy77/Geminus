import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  User? get user {
    return _user;
  }

  AuthServices() {
    _firebaseAuth.authStateChanges().listen(authStateChangesStreamListener);
  }

  Future<bool> login(String email, String password) async {
    try {
      final UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> signUp({required String email, required String password}) async {
    try {
      final UserCredential _userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (_userCredential.user != null) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> logOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void authStateChangesStreamListener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
  }
}
