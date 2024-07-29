import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<bool> loginWithGoogle() async {
    try {
      // Initialize Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Start the sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Check if the user is successfully signed in
      if (googleUser == null) {
        // The user canceled the sign-in process
        return false;
      }

      // Obtain the authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a credential for Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Sign in to Firebase with the obtained credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the user is successfully signed in
      if (userCredential.user != null) {
        // Optionally, you can store the user info
        // Example: _user = userCredential.user;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      return false;
    }
  }
}
