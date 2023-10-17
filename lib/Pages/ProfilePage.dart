import 'package:crousgo/Pages/page_accueil.dart';
import 'package:crousgo/Pages/page_panier.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

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
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user?.displayName != null)
              Text(
                'Nom: ${user!.displayName}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            if (user?.email != null)
              Text(
                'Email: ${user!.email}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            const SizedBox(height: 20),
            // Affichage du solde du portefeuille (faux pour le moment, vous devrez intégrer avec votre source de vérité)
            Text(
              'Solde du Wallet: 100€', // Remplacez par le vrai solde du wallet
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showRechargeDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF06C167),
              ),
              child: const Text(
                'Recharger le Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Naviguer vers la page d'édition du profil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF06C167),
              ),
              child: const Text(
                'Modifier le profil',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                } catch (e) {
                  print("Erreur lors de la déconnexion: $e");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF06C167),
              ),
              child: const Text(
                'Déconnexion',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRechargeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Recharger le Wallet'),
          content: TextField(
            decoration: InputDecoration(hintText: "Entrez le montant"),
            keyboardType: TextInputType.number,
            // ... Autres propriétés pour personnaliser ce champ
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Recharger'),
              onPressed: () {
                // Traitez le paiement et mettez à jour le solde du wallet ici
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Ceci est une maquette de la page EditProfile. 
// Vous devrez ajouter des champs et des logiques appropriés pour la modification du profil.
class EditProfilePage extends StatelessWidget {
  final User? user;

  EditProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ajoutez des champs pour modifier le nom, l'e-mail, etc.
            // ...
            ElevatedButton(
              onPressed: () {
                // Sauvegardez les modifications ici
              },
              child: Text('Sauvegarder'),
            )
          ],
        ),
      ),
    );
  }
}
