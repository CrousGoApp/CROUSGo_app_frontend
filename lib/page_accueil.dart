import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crousgo/page_panier.dart';

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
    final response =
    await http.get(Uri.parse('http://localhost:8080/crousgo_app_backend/dishes'));

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
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFFFDF7EF), // Couleur de fond de l'AppBar
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
              color: Colors.black, // Couleur de l'icône du panier
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          jsonData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
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
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 5.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/burger.png', // Ajoutez le chemin vers votre image burger.png
                          width: double.infinity, // Prend toute la largeur
                          height: 150.0, // Ajustez la hauteur selon vos besoins
                          fit: BoxFit.cover, // Ajustez la façon dont l'image est affichée
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          dishName,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          dishDescription,
                          style: const TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 5.0), // Espacement entre la description et le prix
                        Text(
                          '\$${dish['price']}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // Couleur du prix
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

void main() {
  runApp(const MaterialApp(home: PageAccueil()));
}
