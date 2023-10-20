import 'package:crousgo/pages/ProfilePage.dart';
import 'package:crousgo/pages/page_accueil.dart';
import 'package:crousgo/pages/page_panier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';



class PageFinal extends StatefulWidget {
  const PageFinal({Key? key}) : super(key: key);

  @override
  PageFinalState createState() => PageFinalState();
}

class PageFinalState extends State<PageFinal>

    with SingleTickerProviderStateMixin {
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
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Naviguer vers la page de profil
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350.0,
              height: 350.0,
              child: Image.asset('assets/commande_fin.png'),
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
            

            Text(
              "Solde CrousGO restant : \$$walletBalance",
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PageFinal()));
}
