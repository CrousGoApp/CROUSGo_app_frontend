# CROUSGo_app_frontend

## Description du Projet
CROUSGo_app_frontend est une application destinée à livrer des repas crous directement dans les etablissements. Elle vise à faciliter l'accès aux services CROUS pour les étudiants.

## Fonctionnalités
- Connexion utilisateur avec les identifiants suivants :
  - Email : test2@test.com
  - Mot de passe : test123456

  
- Teste la fonctionnalité suivis de commande:
  - Passez une commande via l'application
  - Rendez vous dans profile > Historique > cliquer sur la commande
  - Avec postman, envoyer une requette PUT à http://localhost:8080/crousgo_app_backend/orders/[OrderID] avec le body suivant:
  {
    "state": "1"
  }
  Modifier l'etat avec un entier allant de 1 à 4 et observer l'etat de la commande evoluer sur l'application


## Captures d'écran
[À ajouter : images ou liens vers des captures d'écran de l'application]

## Technologies Utilisées
- Flutter (comme suggéré par la structure du dépôt)
- [Autres technologies à ajouter]

## Installation et Configuration

### Prérequis
- Flutter SDK
- [Autres prérequis à ajouter]

### Étapes d'installation
1. Clonez le dépôt : `git clone https://github.com/wardrockay/CROUSGo_app_frontend.git`
2. Accédez au dossier du projet : `cd CROUSGo_app_frontend`
3. Installez les dépendances : `flutter pub get`
4. Exécutez l'application : `flutter run`
5. [Autres étapes à ajouter]

## Utilisation
Une fois l'application en cours d'exécution, [instructions sur la façon d'utiliser l'application, par exemple, "utilisez les identifiants fournis pour vous connecter"].

## Contribution
Si vous souhaitez contribuer à ce projet, veuillez [ouvrir une issue](https://github.com/wardrockay/CROUSGo_app_frontend/issues) ou soumettre une pull request.

## Licence
[À ajouter : informations sur la licence, si disponible]

## Auteurs
- [Etienne Maillot](https://github.com/wardrockay)
- [Teo Vandroemme](https://github.com/TeoVandroemme)
- [Louis Mercier](https://github.com/SaadyX)


