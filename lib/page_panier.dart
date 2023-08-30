import 'package:crousgo/page_accueil.dart';
import 'package:crousgo/page_final.dart';
import 'package:flutter/material.dart';

class PagePanier extends StatefulWidget {
  const PagePanier({Key? key}) : super(key: key);

  @override
  PagePanierState createState() => PagePanierState();
}

class PagePanierState extends State<PagePanier>
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PageAccueil()), // Remplacez PagePanier() par le nom de votre classe de la page panier
                    );
                  },
                  child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Image.asset(
                      'assets/fleche_gauche.png',
                    ),
                  ),
                ),
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
          const Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text("Panier", textAlign: TextAlign.left, style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                ),),
              ),
            ],
          ),
          const Spacer(), // Ajoute un espace flexible pour pousser le bouton vers le bas
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PageFinal()), // Remplacez PageFinal() par le nom de votre classe de la page finale
              );
            },
            child: const Text("Passer commande"),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PagePanier()));
}
