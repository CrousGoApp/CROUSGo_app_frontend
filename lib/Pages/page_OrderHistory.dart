import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  // TODO: Remplacez ceci par la logique d'appel API pour obtenir les données de l'historique des commandes
  List<dynamic> orders = [];  // Exemple de réponse de l'API
  
  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/crousgo_app_backend/orders'));
      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Gérez l'erreur ici, par exemple en imprimant le message d'erreur
      print('Une erreur s\'est produite : $e');
    }
  }

  double calculateOrderTotal(List<dynamic> orderDishes) {
    double total = 0.0;
    for (var orderDish in orderDishes) {
      total += orderDish["dish"]["price"] * orderDish["quantity"];
    }
    return total;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des commandes'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Commande ID: ${order["id"]}'),
                  //Text('Email: ${order["user_mail"]}'),
                  Text('Salle de classe: ${order["classroom"]["name"]}'),
                  Text('Total: \$${calculateOrderTotal(order["orderDishes"]).toStringAsFixed(2)}'),
                  SizedBox(height: 10),
                  ...order["orderDishes"].map<Widget>((orderDish) {
                    return ListTile(
                       // Assurez-vous d'avoir une URL complète pour l'image
                      title: Text(orderDish["dish"]["name"]),
                      subtitle: Text(orderDish["dish"]["description"]),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Quantité: ${orderDish["quantity"]}'),
                          Text('Prix: \$${orderDish["dish"]["price"]}'),
                        ],
                      ),
                    );
                  }).toList(),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
