#!/usr/bin/env bash
# Script de build pour Render

set -o errexit  # Arrêter le script en cas d'erreur

echo "🚀 Début du build pour Render..."

# Mise à jour de pip
echo "📦 Mise à jour de pip..."
python -m pip install --upgrade pip

# Installation des dépendances
echo "📦 Installation des dépendances..."
pip install -r requirements.txt

# Création du répertoire staticfiles
echo "📁 Création du répertoire staticfiles..."
mkdir -p /tmp/staticfiles

# Collecte des fichiers statiques
echo "🎨 Collecte des fichiers statiques..."
python manage.py collectstatic --noinput --clear

# Vérification de la configuration Django
echo "🔍 Vérification de la configuration Django..."
python manage.py check --deploy

echo "✅ Build terminé avec succès!"