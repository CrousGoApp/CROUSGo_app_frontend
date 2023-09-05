import 'package:crousgo/pages/page_accueil.dart';
import 'package:crousgo/pages/page_panier.dart';
import 'package:flutter/material.dart';

class PageFinal extends StatefulWidget {
  const PageFinal({Key? key}) : super(key: key);

  @override
  PageFinalState createState() => PageFinalState();
}

class PageFinalState extends State<PageFinal>
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
          Column(
            children: [
              SizedBox(
                width: 350.0,
                height: 350.0,
                child: Image.asset(
                  'assets/commande_fin.png',
                ),
              ),
              const Text(
                "Commande envoyée !",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Elle vous attendra à la fin de votre cours !",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              const Text(
                "Solde CrousGO restant : --- €",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
            ],
          )

        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PageFinal()));
}
