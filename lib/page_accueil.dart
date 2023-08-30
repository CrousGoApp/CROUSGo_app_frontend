import 'package:crousgo/page_panier.dart';
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PagePanier()), // Remplacez PagePanier() par le nom de votre classe de la page panier
                    );
                  },
                  child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Image.asset(
                      'assets/panier.png',
                    ),
                  ),
                )
              ],
            ),
          ),
          const Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text("La Carte", textAlign: TextAlign.left, style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PageAccueil()));
}
