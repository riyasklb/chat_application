import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  User? _user;
  User? get user => _user;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthService() {
    _firebaseAuth.authStateChanges().listen(_authStateChangesListener);
  }

  Future<bool> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> register(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        _user = credential.user;
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      _user = null;
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  void _authStateChangesListener(User? user) {
    _user = user;
  }
}
