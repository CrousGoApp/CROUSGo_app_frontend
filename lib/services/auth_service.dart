import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // S'inscrire
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Se connecter
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Se déconnecter
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
