import 'package:crousgo/page_panier.dart';
import 'package:crousgo/page_produit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Importez votre classe PageProduit ici s'il n'a pas déjà été importé
// import 'package:votre_projet/page_produit.dart';

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
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 0.7,
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
                    margin: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 5.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            'assets/burger.png',
                            width: double.infinity,
                            height: 150.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dishName,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF06C167),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: SizedBox(
                            height: 35.0,
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
                            horizontal: 15.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${priceDouble.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Checkbox(
                                value: false,
                                onChanged: (bool? value) {},
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
