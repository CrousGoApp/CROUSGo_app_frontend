import 'dart:convert';

import 'package:crousgo/pages/page_OrderHistory.dart';
import 'package:crousgo/pages/page_accueil.dart';
import 'package:crousgo/pages/page_panier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatefulWidget {
    _ProfilePageState createState() => _ProfilePageState();

}
class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  int? walletBalance;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }
  
  _fetchUserDetails() async {
    // Remplacez par l'URL de votre API
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/crousgo_app_backend/users/email/${user!.email}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        walletBalance = data['wallet'];
      });
    } else {
      print("Erreur lors de la récupération des détails de l'utilisateur");
    }
  }
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
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (user?.email != null)
              Text(
                'Email: ${user!.email}',
                style: const TextStyle(
                  fontSize: 18, // Augmenter la taille de la police
                ),
              ),
            const SizedBox(height: 10), // Réduire l'espacement entre les éléments
            // Affichage du solde du portefeuille (faux pour le moment, vous devrez intégrer avec votre source de vérité)
            Text(
              'Solde du Wallet: \$$walletBalance', // Remplacez par le vrai solde du wallet
              style: const TextStyle(
                fontSize: 18, // Augmenter la taille de la police
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showRechargeDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06C167), // Couleur d'UberEats
              ),
              child: const Text(
                'Recharger le Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10), // Réduire l'espacement entre les éléments
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page d'édition du profil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06C167), // Couleur d'UberEats
              ),
              child: const Text(
                'Modifier le profil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10), // Réduire l'espacement entre les éléments
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                } catch (e) {
                  print("Erreur lors de la déconnexion: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06C167), // Couleur d'UberEats
              ),
              child: const Text(
                'Déconnexion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF06C167), // Couleur d'UberEats
              ),
              child: const Text(
                'Historique des commandes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRechargeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Recharger le Wallet'),
          content: const TextField(
            decoration: InputDecoration(hintText: "Entrez le montant"),
            keyboardType: TextInputType.number,
            // ... Autres propriétés pour personnaliser ce champ
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Recharger'),
              onPressed: () {
                // Traitez le paiement et mettez à jour le solde du wallet ici
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
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
                  // Ajoutez des champs pour modifier le nom, l'e-mail, etc.
                  // ...
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
