# Utiliser l'image officielle de Docker pour Flutter
FROM cirrusci/flutter:latest

# Définir le répertoire de travail dans le conteneur
WORKDIR /app

# Copier les fichiers de l'application Flutter dans le conteneur
COPY . .

# Récupérer les dépendances du projet Flutter
RUN flutter pub get

# Construire l'application Flutter (pour la web par exemple)
RUN flutter build web

# Utiliser Nginx pour servir l'application
FROM nginx:alpine

# Copier le build Flutter dans le répertoire de serveur web
COPY --from=0 /app/build/web /usr/share/nginx/html

# Exposer le port 80
EXPOSE 80

# Démarrer Nginx
CMD ["nginx", "-g", "daemon off;"]
