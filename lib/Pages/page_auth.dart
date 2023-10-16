import 'package:crousgo/Pages/page_accueil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageAuth extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PageAuth({super.key});

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("Utilisateur connecté : ${userCredential.user?.email}");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const PageAccueil()));
    } catch (e) {
      print("Erreur : $e");
      String errorMessage;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "Nom d'utilisateur ou Mot de passe incorrect.";
            break;
          case 'wrong-password':
            errorMessage = "Nom d'utilisateur ou Mot de passe incorrect.";
            break;
          default:
            errorMessage = 'Une erreur est survenue lors de la connexion.';
            break;
        }
      } else {
        errorMessage = 'Une erreur est survenue lors de la connexion.';
      }
      final snackBar = SnackBar(content: Text(errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return const PageAccueil();
        }
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'CrousGO',
                    style: TextStyle(
                      fontSize: 35,
                      color: Color(0xFF00FF00),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _signIn(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    child: const Text('Se connecter'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
