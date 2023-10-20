import 'dart:convert';

import 'package:crousgo/pages/EditProfilePage.dart';
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
  final walletController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }
  
  _fetchUserDetails() async {
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
              Text(
              'Solde du Wallet: \$$walletBalance', 
              style: const TextStyle(
                fontSize: 18, 
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
                backgroundColor: const Color(0xFF06C167), 
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
                backgroundColor: const Color(0xFF06C167), 
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
          content:  TextField(
            controller: walletController,
            decoration: InputDecoration(hintText: "Entrez le montant"),
            keyboardType: TextInputType.number,
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
              onPressed: () async {
              int? rechargeAmount = int.tryParse(walletController.text); // Convertit la valeur en entier
              if (rechargeAmount != null) {
                // Création du JSON avec cette valeur
                String formattedData = json.encode({
                  'wallet': rechargeAmount
                });

                // Envoyez cet objet JSON dans la requête PUT.
                final response = await http.put(
                  Uri.parse('http://10.0.2.2:8080/crousgo_app_backend/users/email/${user!.email}'),
                  headers: {
                    'Content-Type': 'application/json',
                    'Accept': 'application/json',
                  },
                  body: formattedData,
                );

                if (response.statusCode == 200) { 
                  print('Solde mis à jour avec succès');
                  final snackBar = SnackBar(content: Text("Solde mis à jour avec succes"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  _fetchUserDetails(); 
                } else {
                  print('Erreur lors de la mise à jour du solde');
                  final snackBar = SnackBar(content: Text("Problème avec la mise à jour du solde"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

                
                Navigator.of(context).pop();
              } else {
                print("Montant invalide");
                final snackBar = SnackBar(content: Text("Veuillez entrer un montant valide"));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              
            },
            ),
          ],
        );
      },
    );
  }
}

