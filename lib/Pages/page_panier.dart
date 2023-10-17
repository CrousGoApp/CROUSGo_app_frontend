import 'dart:convert';
import 'package:crousgo/Pages/page_final.dart';
import 'package:crousgo/Pages/cart_model.dart';
import 'package:crousgo/Pages/page_accueil.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:crousgo/Pages/ProfilePage.dart';

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
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: DecorationImage(
                              image: AssetImage(item.picturename),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
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
                                '\$${item.price.toString()} x ${item.quantity}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              item.quantity += 1;
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            setState(() {
                              if (item.quantity > 1) {
                                item.quantity -= 1;
                              } else {
                                cartModel.removeFromCart(item);
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cartModel.removeFromCart(item);
                            setState(() {});
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
          Text(
            'Total: \$${calculateTotal().toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              //je récupère l'email du user
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final User? user = _auth.currentUser;

              if (user != null && user.email != null && cartModel.cart.isNotEmpty) {
                String userEmail = user.email!;
                List<String> dishIds = cartModel.cart.map((item) => item.id).toList();
                int? selectedClassroom = await _selectClassroom(context);
                if (selectedClassroom != null) {
                  print("La classe sélectionnée est : $selectedClassroom");
                } else {
                  print("Aucune classe n'a été sélectionnée.");
                }
                  String formattedData = formatOrderData(userEmail, dishIds, selectedClassroom);
                  print(formattedData);
                  // Effectuer une requête POST
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2:8080/crousgo_app_backend/orders'),
                    headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                    },
                    body: formattedData,
                  );

                  if (response.statusCode == 201) {
                    print('Commande passée avec succès');
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => PageFinal()));
                    cartModel.cart.clear();
                  } else {
                    print('Erreur lors de la passation de la commande');
                  }
              } else {
                print("Aucun utilisateur n'est connecté ou panier vide.");
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
          title: const Text('Choisissez une classe'),
          children: jsonData.map<Widget>((classroom) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, classroom['id']);
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
  double calculateTotal() {
    return cartModel.cart.fold(0.0, (total, item) => total + (item.price * item.quantity));
  }


}



