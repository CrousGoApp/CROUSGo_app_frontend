import 'package:crousgo/page_panier.dart';
import 'package:flutter/material.dart';

class PageProduit extends StatelessWidget {
  final Map<String, dynamic> dish;

  const PageProduit({Key? key, required this.dish}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dishName = dish['name'] as String;
    final dishDescription = dish['description'] as String;
    final dishPrice = dish['price'] as int;

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
        title: const Text(
          'CrousGO',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF06C167),
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context); // Pour retourner à la page précédente
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF06C167), // Couleur verte personnalisée
          ),
        ),
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
              color: Color(0xFF06C167),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/burger.png',
              width: double.infinity,
              height: 350.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dishName,
                    style: const TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF06C167),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: SizedBox(
                height: 35.0,
                child: Text(
                  dishDescription,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories:',
                    style: TextStyle(
                      fontSize: 16.0,
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
                    'Allergens:',
                    style: TextStyle(
                      fontSize: 16.0,
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$$dishPrice',
                    style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Checkbox(
                    value: false, // Vous pouvez gérer l'état de la checkbox ici
                    onChanged: (bool? value) {
                      // Gérez ici l'état de la checkbox
                    },
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
