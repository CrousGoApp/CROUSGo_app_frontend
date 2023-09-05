import 'package:crousgo/pages/cart_model.dart';
import 'package:crousgo/pages/page_accueil.dart';
import 'package:flutter/material.dart';

class PagePanier extends StatelessWidget {
  const PagePanier({Key? key}) : super(key: key);

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
              color: Color(0xFF06C167),
            ),
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF06C167),
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
                    elevation: 3.0, // Élévation de la carte
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0), // Coins arrondis
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 100.0, // Largeur de l'image
                          height: 100.0, // Hauteur de l'image
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            image: const DecorationImage(
                              image: AssetImage('assets/burger.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0), // Espacement
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
                                '\$${item.price.toString()}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Supprimez l'élément du panier
                            cartModel.removeFromCart(item);
                            // Rafraîchissez l'interface utilisateur en reconstruisant la page
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PagePanier(),
                              ),
                            );
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
          ElevatedButton(
            onPressed: () {
              // Ajoutez ici la logique pour passer la commande
              // Vous pouvez afficher un dialogue de confirmation ou passer à la page de paiement.
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
}
