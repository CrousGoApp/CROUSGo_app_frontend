import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:crousgo/pages/page_panier.dart';
import 'package:crousgo/pages/page_produit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ProfilePage.dart';
import 'dart:convert';

import 'package:crousgo/pages/cart_model.dart';
import 'package:crousgo/pages/item.dart';

void main() {
  runApp(MaterialApp(
    home: const PageAccueil(),
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.grey,
    ),
  ));
}

class PageAccueil extends StatefulWidget {
  const PageAccueil({Key? key}) : super(key: key);

  @override
  PageAccueilState createState() => PageAccueilState();
}

class PageAccueilState extends State<PageAccueil>
    with SingleTickerProviderStateMixin {
  List<dynamic> jsonData = [];
  String? selectedCategory;
  String? searchQuery;
  bool _hasTimeout = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    Timer.periodic(Duration(seconds: 10), (timer) {
      fetchData();
    });
  }

   Future<void> fetchData() async {
    Uri uri;
   if (kIsWeb) {
    // Si l'application s'exécute dans un navigateur Web
    uri = Uri.http('localhost:8080', '/crousgo_app_backend/dishes');
  } else {
    // Si l'application s'exécute dans un autre environnement (par exemple, un émulateur Android)
    uri = Uri.http('10.0.2.2:8080', '/crousgo_app_backend/dishes');
  }
    try {
      final response = await http.get(uri).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        setState(() {
          jsonData = json.decode(response.body);
          _hasTimeout = false; // Reset the timeout flag
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      if (e is TimeoutException) {
        setState(() {
          _hasTimeout = true;
        });
      }
      print('Une erreur s\'est produite : $e');
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
      body: Column(
        children: <Widget>[
          if (_hasTimeout)
            Column(
              children: [
                Text("Impossible d'afficher les plats"),
                ElevatedButton(
                  onPressed: fetchData,
                  child: Text("Refresh"),
                ),
              ],
            )
          else if (jsonData.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
          jsonData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'La Carte',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              labelText: "Rechercher un plat",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),

          DropdownButton<String>(
            hint: Text("Sélectionnez une catégorie"),
            value: selectedCategory,
            items: [
              'Toutes les catégories','Vegan', 'Vegetarian', 'Meat', 'Fish', 'Pasta', 'Rice', 'Salad', 'Sandwich', 'Soup', 'Burger'
            ].map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedCategory = newValue;
              });
            },
          ),

          Expanded(
            
            child: GridView.builder(
              
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.65,
              ),
              itemCount: jsonData.length,
              itemBuilder: (context, index) {
                final dish = jsonData[index];
                  if (searchQuery != null && searchQuery!.isNotEmpty && !dish['name'].toLowerCase().contains(searchQuery!.toLowerCase())) {
                    return Container();  // Retournez un conteneur vide si le nom du plat ne contient pas la requête de recherche
                  }
                  if (selectedCategory != null && selectedCategory != "Toutes les catégories") {
                  bool matchesCategory = false;
                  for (var cat in dish['categorie']) {
                    if (cat['name'] == selectedCategory) {
                      matchesCategory = true;
                      break;
                    }
                  }
                  if (!matchesCategory) {
                    return Container();  // Retourne un conteneur vide si le plat ne correspond pas à la catégorie sélectionnée
                  }
                }
                
                final dishName = dish['name'] as String;
                final dishDescription = dish['description'] as String;
                dynamic dishPrice = dish['price'];
                final dishPicture = 'assets/${dish['picture']}';
                double? priceDouble;
                try {
                  priceDouble = dishPrice is double
                      ? dishPrice
                      : double.parse(dishPrice.toString());
                } catch (e) {
                  priceDouble = 0.0;
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageProduit(dish: dish),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0),
                            ),
                          ),
                          child: Image.asset(
                            dishPicture,
                            width: double.infinity,
                            height: 150.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Text(
                            dishName,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF06C167),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Text(
                            dishDescription,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${priceDouble.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              
                              ElevatedButton(
                                onPressed: () {
                                  final item = Item(id: dish['id'].toString(), name: dishName, price: dishPrice, picturename: dishPicture);
                                  cartModel.addItem(item);
                                  },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF06C167),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
