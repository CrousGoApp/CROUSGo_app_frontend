import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderTrackingPage extends StatefulWidget {
  final int orderId;

  OrderTrackingPage({required this.orderId});

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  Map<String, dynamic>? orderData;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8080/crousgo_app_backend/orders/${widget.orderId}'));
      if (response.statusCode == 200) {
        setState(() {
          orderData = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Une erreur s\'est produite : $e');
    }
  }

  Future<void> _cancelOrder() async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8080/crousgo_app_backend/orders/${widget.orderId}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"state": 5}),
      );
      if (response.statusCode == 200) {
        fetchData(); // Rafraîchir les données après l'annulation
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Commande annulée. Le montant a été crédité sur votre solde.")),
        );
      } else {
        throw Exception('Failed to cancel order');
      }
    } catch (e) {
      print('Une erreur s\'est produite lors de l\'annulation de la commande : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'annulation de la commande.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Suivi de la commande'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStateBox("Commande confirmée", 1),
                _buildStateBox("Préparation", 2),
                _buildStateBox("Livraison", 3),
                _buildStateBox("Terminé", 4),
              ],
            ),
            SizedBox(height: 20),
            if (orderData != null)
              Expanded(
                child: ListView(
                  children: [
                    Text('Commande ID: ${orderData!["id"]}'),
                    Text('Salle de classe: ${orderData!["classroom"]["name"]}'),
                    ...orderData!["orderDishes"].map<Widget>((orderDish) {
                      return ListTile(
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
            if (orderData != null && (orderData!["state"] == 1 || orderData!["state"] == 2))
              ElevatedButton(
                onPressed: _cancelOrder,
                child: Text("Annuler la commande"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateBox(String title, int state) {
    bool isCurrentState = orderData != null && orderData!["state"] == state;
    bool isPastState = orderData != null && orderData!["state"] > state;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: isCurrentState ? Colors.blue : (isPastState ? Colors.blue[100]! : Colors.grey),
        border: Border.all(color: isCurrentState ? Colors.blue : Colors.grey),
      ),
      child: Center(child: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 10))),
    );
  }
}
