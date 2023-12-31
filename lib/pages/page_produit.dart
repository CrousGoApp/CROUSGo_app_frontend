import 'package:crousgo/pages/cart_model.dart';
import 'package:crousgo/pages/item.dart';
import 'package:crousgo/pages/page_accueil.dart';
import 'package:crousgo/pages/page_panier.dart';
import 'package:flutter/material.dart';

import 'ProfilePage.dart';

class PageProduit extends StatelessWidget {
  final Map<String, dynamic> dish;

  const PageProduit({Key? key, required this.dish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dishName = dish['name'] as String;
    final dishDescription = dish['description'] as String;
    final dishPrice = dish['price'] as int;
    final dishPicture = 'assets/${dish['picture']}';

    List<dynamic> categories = dish['categorie'] != null &&
        dish['categorie'] is List<dynamic>
        ? (dish['categorie'] as List<dynamic>)
        : [];

    List<dynamic> allergens = dish['allergens'] != null &&
        dish['allergens'] is List<dynamic>
        ? (dish['allergens'] as List<dynamic>)
        : [];

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
      body: SingleChildScrollView( // Pour permettre le défilement
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Utilisez tout l'espace en largeur
          children: [
            Container(
              height: 300.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(dishPicture),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dishName,
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF06C167),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    dishDescription,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Catégories:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categories
                        .map((category) => Text('- ${category['name']}'))
                        .toList(),
                  ),
                  const SizedBox(height: 15.0),
                  const Text(
                    'Allergènes:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: allergens
                        .map((allergen) => Text('- ${allergen['name']}'))
                        .toList(),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    '\$$dishPrice', // Affichez le prix ici
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton( // Bouton flottant d'ajout au panier
        onPressed: () {
          final item = Item(id: dish['id'].toString(), name: dishName, price: dishPrice, picturename: dishPicture);
          cartModel.addItem(item);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PagePanier()),
          );
        },
        backgroundColor: const Color(0xFF06C167),
        child: const Icon(
          Icons.add_shopping_cart,
          color: Colors.white,
        ),
      ),
    );
  }
}
