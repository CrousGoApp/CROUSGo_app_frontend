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

  List<dynamic> jsonData = []; // Initialisation avec une liste vide

  @override
  void initState() {
    super.initState();
    fetchData(); // Appel à la fonction fetchData() au moment de l'initialisation de la page
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://172.27.218.247:8080/crousgo_app_backend/allergens'));

    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body); // Stocker les données dans la variable jsonData
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: const Color(0xFFFDF7EF),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 30.0),
                const SizedBox(
                  width: 100.0,
                  child: Text(
                    'CrousGO',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PagePanier()),
                    );
                  },
                  child: SizedBox(
                    width: 30.0,
                    height: 30.0,
                    child: Image.asset(
                      'assets/panier.png',
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            children: [
              Column(
                children: jsonData.map((item) => Text(item['name'] ?? '')).toList(), // Afficher la propriété 'name' de chaque élément JSON
              ),
              const SizedBox(height: 20.0), // Espacement entre les données JSON et le texte "La Carte"
              const Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text("La Carte", textAlign: TextAlign.left, style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),),
                  ),
                ],
              ),
            ],
          )

        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: PageAccueil()));
}
