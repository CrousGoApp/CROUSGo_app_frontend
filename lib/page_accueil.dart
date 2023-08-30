import 'package:flutter/material.dart';

class PageAccueil extends StatefulWidget {
  const PageAccueil({Key? key}) : super(key: key);

  @override
  PageAccueilState createState() => PageAccueilState();
}

class PageAccueilState extends State<PageAccueil>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: const Color(0xFFFDF7EF), // Couleur de la bannière
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 30.0),
                const SizedBox(
                  width: 100.0, // Ajustez cette largeur selon vos besoins
                  child: Text(
                    'CrousGO',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30.0,
                  height: 30.0,
                  child: Image.asset(
                    'assets/panier.png',
                  ),
                ),
              ],
            ),
          ),
          // Ajoutez ici le reste du contenu de votre page d'accueil
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PageAccueil()));
}
