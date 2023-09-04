import 'package:flutter/material.dart';

void main() {
  runApp(const CrousGoApp());
}

class CrousGoApp extends StatelessWidget {
  const CrousGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Créez une couleur noire personnalisée en tant que MaterialColor
    MaterialColor blackCustom = const MaterialColor(
      0xFF000000, // La valeur hexadécimale correspondant à la couleur noire
      <int, Color>{
        50: Color(0xFF000000), // Vous pouvez personnaliser différentes nuances de noir ici
        100: Color(0xFF000000),
        200: Color(0xFF000000),
        300: Color(0xFF000000),
        400: Color(0xFF000000),
        500: Color(0xFF000000),
        600: Color(0xFF000000),
        700: Color(0xFF000000),
        800: Color(0xFF000000),
        900: Color(0xFF000000),
      },
    );

    return MaterialApp(
      home: const PageAuth(),
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black, // Couleur de fond en noir
        colorScheme: ColorScheme.fromSwatch(primarySwatch: blackCustom).copyWith(
          background: const Color(0xFFFDF7EF), // Couleur d'arrière-plan
        ),
      ),
    );
  }
}

class PageAuth extends StatefulWidget {
  const PageAuth({super.key});

  @override
  PageAuthState createState() => PageAuthState();
}

class PageAuthState extends State<PageAuth> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Titre de l'application en gras
              const Text(
                'CrousGO',
                style: TextStyle(
                  fontSize: 35, // Taille de la police
                  color: Color(0xFF00FF00), // Couleur verte
                  fontWeight: FontWeight.bold, // Met le texte en gras
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
                onPressed: () {
                  // Ajoutez ici la logique d'authentification
                },
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
  }
}
