import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crousgo/page_panier.dart';

void main() {
  runApp(MaterialApp(
    home: const PageAccueil(),
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.grey, // Couleur de fond de l'application
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('http://172.27.218.247:8080/crousgo_app_backend/dishes'));

    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CrousGO',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF06C167), // Nouvelle couleur du texte de l'AppBar
          ),
        ),
        backgroundColor: Colors.black, // Couleur de fond de l'AppBar
        centerTitle: true, // Centrer le titre
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
              color: Color(0xFF06C167), // Nouvelle couleur de l'icône du panier
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          jsonData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'La Carte',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Couleur du titre
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Nombre de colonnes par ligne
                crossAxisSpacing: 5.0, // Espacement horizontal entre les éléments
                mainAxisSpacing: 5.0, // Espacement vertical entre les éléments
                childAspectRatio: 0.7, // Ratio largeur/hauteur pour chaque boîte
              ),
              itemCount: jsonData.length,
              itemBuilder: (context, index) {
                final dish = jsonData[index];
                final dishName = dish['name'] as String;
                final dishDescription = dish['description'] as String;
                dynamic dishPrice = dish['price'];
                double? priceDouble;

                try {
                  priceDouble = dishPrice is double
                      ? dishPrice
                      : double.parse(dishPrice.toString());
                } catch (e) {
                  // Gestion de l'erreur si la conversion échoue
                  priceDouble = 0.0; // Vous pouvez définir une valeur par défaut
                }

                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 5.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white, // Couleur de fond de la boîte dish
                    borderRadius: BorderRadius.circular(10.0),
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
                          'assets/burger.png', // Chemin vers votre image burger.png
                          width: double.infinity, // Prend toute la largeur
                          height: 150.0, // Ajustez la hauteur selon vos besoins
                          fit: BoxFit.cover, // Ajustez la façon dont l'image est affichée
                        ),
                      ),
                      const SizedBox(height: 15.0), // Espace plus grand
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, // Padding horizontal
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Centrer le titre
                          children: [
                            Text(
                              dishName,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF06C167), // Nouvelle couleur des titres
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, // Padding horizontal
                        ),
                        child: SizedBox(
                          height: 35.0, // Hauteur fixe de la description
                          child: Text(
                            dishDescription,
                            style: const TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, // Padding horizontal
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${priceDouble.toStringAsFixed(2)}', // Format du prix avec deux décimales
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.green, // Couleur du prix
                              ),
                            ),
                            Checkbox(
                              value: false, // Mettez ici la valeur de votre checkbox
                              onChanged: (bool? value) {
                                // Gérez ici l'état de la checkbox
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
