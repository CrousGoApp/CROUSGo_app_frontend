import 'dart:convert';

import 'package:crousgo/pages/cart_model.dart';
import 'package:crousgo/pages/page_accueil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;


import 'ProfilePage.dart';

class PagePanier extends StatefulWidget {
  
  const PagePanier({Key? key}) : super(key: key);
  @override
  _PagePanierState createState() => _PagePanierState();

  
}

class _PagePanierState extends State<PagePanier> {
  List<dynamic> jsonData = [];
  String userEmail= "";
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
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Panier',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cartModel.cart.length,
              itemBuilder: (context, index) {
                final item = cartModel.cart[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3.0, // Élévation de la carte
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Coins arrondis
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0, // Largeur de l'image
                          height: 100.0, // Hauteur de l'image
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/burger.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0), // Espacement
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${item.price.toString()}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Supprimez l'élément du panier
                            cartModel.removeFromCart(item);
                            // Rafraîchissez l'interface utilisateur en reconstruisant la page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PagePanier(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20.0), // Espacement en bas
          ElevatedButton(
            onPressed: () async {
              // Ajoutez ici la logique pour passer la commande
              // Vous pouvez afficher un dialogue de confirmation ou passer à la page de paiement.

              //je récupère l'email du user
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final User? user = _auth.currentUser;

              if (user != null && user.email != null) {
                String userEmail = user.email!;
                List<String> dishIds = cartModel.cart.map((item) => item.id).toList();
                int? selectedClassroom = await _selectClassroom(context);
              if (selectedClassroom != null) {
                print("La classe sélectionnée est : $selectedClassroom");
                // Ici, vous pouvez ajouter la logique pour passer la commande avec la classe sélectionnée
              } else {
                print("Aucune classe n'a été sélectionnée.");
              }
                String formattedData = formatOrderData(userEmail, dishIds, selectedClassroom);
                print(formattedData);
              } else {
                print("Aucun utilisateur n'est connecté.");
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF06C167), // Couleur du bouton
              padding: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Coins arrondis
              ),
            ),
            child: const Text(
              'Passer la commande',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20.0), // Espacement en bas
        ],
      ),
    );
  }
  Future<int?> _selectClassroom(BuildContext context) async {
  await fetchData(); // Récupérez les données

  return await showDialog<int?>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Choisissez une classe'),
          children: jsonData.map<Widget>((classroom) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, classroom['id']); // Supposons que chaque objet "classroom" ait un attribut "name"
              },
              child: Text(classroom['name']),
            );
          }).toList(),
        );
      },
    );
  }

  
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/crousgo_app_backend/classrooms'));
      if (response.statusCode == 200) {
        setState(() {
          jsonData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Une erreur s\'est produite : $e');
    }
  }

  String formatOrderData(String userEmail, List<String> dishIds, int? classroomId) {
  Map<String, dynamic> orderData = {
    "user_mail": userEmail,
    "dishIds": dishIds,
    "classroomId": classroomId
  };

  return jsonEncode(orderData);
}

}



