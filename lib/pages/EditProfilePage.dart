
import 'package:crousgo/pages/ProfilePage.dart';
import 'package:crousgo/pages/page_accueil.dart';
import 'package:crousgo/pages/page_panier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EditProfilePage extends StatelessWidget {
  final User? user;

  EditProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PageAccueil()),
            );
          },
          child: const Text(
            'CrousGO',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF06C167),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PagePanier()),
              );
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Naviguer vers la page de profil
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Modifier le Profil',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nom Prenom',
                      hintText: 'Entrez votre Nom Prénom',
                      border: OutlineInputBorder(),
                    ),
                    // Vous pouvez initialiser le champ avec la valeur actuelle du nom de l'utilisateur si disponible
                    controller: TextEditingController(text: user?.displayName ?? ''),
                  ),
                  const SizedBox(height: 16.0),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06C167), // Couleur d'UberEats
                      textStyle: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      // Sauvegardez les modifications ici
                    },
                    child: const Text('Sauvegarder'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}