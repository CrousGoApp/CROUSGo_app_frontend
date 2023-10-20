# CROUSGo_app_frontend

## Description du Projet
**CROUSGo_app_frontend** est une application mobile conçue pour faciliter la livraison de repas CROUS directement dans les établissements universitaires. Elle vise à améliorer l'expérience des étudiants en leur offrant un accès simplifié aux services du CROUS.

## Fonctionnalités Principales

### Fonctionnalités Attendues

L'application est développée selon les spécifications suivantes :

- **Écran de Liste des Plats** : 
  - Affiche une liste des plats disponibles avec une image (pouvant être non contractuelle), un titre, une description, un prix, une catégorie et d'autres informations pertinentes.
  - Propose des filtres basés sur la catégorie (végétarien, viande, healthy, gras, etc.).
  - Intègre un système de recherche de plats.
  - Permet d'ajouter un plat au panier directement depuis cet écran.

- **Écran de Détail du Plat** :
  - Affiche des informations détaillées sur le plat sélectionné, y compris la liste des allergènes.
  - Permet également d'ajouter le plat au panier.

- **Écran du Panier** :
  - Présente un récapitulatif des plats sélectionnés.
  - Permet de modifier la quantité des plats ou de les supprimer du panier.
  - Offre la possibilité de renseigner l'adresse de livraison et de valider la commande.

- **Écran de Confirmation** :
  - Affiche un message de succès confirmant que la commande a été correctement enregistrée.

- **Gestion des Informations Utilisateur** :
  - Récupère et affiche le nom et le prénom de l'utilisateur.
  - Affiche le solde de la carte CROUS de l'utilisateur pour vérifier s'il dispose de fonds suffisants pour passer la commande.

### Fonctionnalités Bonus

- **Authentification** : Connexion sécurisée des utilisateurs.
- **Rechargement de la carte CROUS** : Permet aux étudiants de recharger leur carte directement depuis l'application.
- **Historique des commandes** : Les utilisateurs peuvent consulter toutes leurs commandes passées.
- **Suivi de commande en temps réel** : Les étudiants peuvent suivre l'état de leur commande en temps réel.
- **Annulation de commande** : Possibilité d'annuler une commande si elle est dans un état spécifique.

## Procédures de Test
1. **Connexion utilisateur** :
   - Email : `test2@test.com`
   - Mot de passe : `test123456`

2. **Test de la fonctionnalité de suivi de commande** :
   - Passez une commande via l'application.
   - Accédez à `Profile > Historique` et sélectionnez la commande.
   - Utilisez Postman pour envoyer une requête PUT à `http://localhost:8080/crousgo_app_backend/orders/[OrderID]` avec le body :
     ```json
     {
       "state": "[desired state between 1 & 5]"
     }
     ```
   - Modifiez l'état avec un entier entre 1 et 4 et observez l'évolution de l'état de la commande dans l'application.
   - L'état 5 correspond à une commande annuléé.

3. **Test de la fonction d'annulation de commande** :
   - Créez une nouvelle commande.
   - Accédez à l'historique et sélectionnez la commande.
   - Si l'état de la commande est 1 ou 2, le bouton "Annuler la commande" sera disponible.
   - Vérifiez que le montant de la commande a été correctement crédité sur le compte de l'utilisateur après annulation.


## Technologies Utilisées
- **Flutter** : Framework de développement d'applications mobiles.
- **Firebase** : Solution d'authentification de google

## Installation et Configuration

### Prérequis
- Avoir Flutter SDK installé.

### Étapes d'installation
1. Clonez le dépôt : 
   ```bash
   git clone https://github.com/wardrockay/CROUSGo_app_frontend.git
   ```
2. Accédez au dossier du projet : 
   ```bash
   cd CROUSGo_app_frontend
   ```
3. Installez les dépendances : 
   ```bash
   flutter pub get
   ```
4. Lancez l'application : 
   ```bash
   flutter run
   ```


## Auteurs
- [Etienne Maillot](https://github.com/wardrockay)
- [Teo Vandroemme](https://github.com/TeoVandroemme)
- [Louis Mercier](https://github.com/SaadyX)
