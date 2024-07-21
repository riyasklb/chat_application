import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  User? _user;
  User? get user {
    return _user;
  }

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthService() {}
  Future<bool> login(String email, String password) async {
    try {
      final cridental = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (cridental.user != null) {
        _user = cridental.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
