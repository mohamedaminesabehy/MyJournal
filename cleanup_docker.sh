#!/bin/bash
# ===================================================================
# Script de Nettoyage Docker - MyJournal
# Objectif: Réduire la taille de l'image de 6.5GB à <4GB
# ===================================================================

set -e

echo "🧹 Début du nettoyage de l'image Docker..."

# ===================================================================
# 1. Nettoyage des caches Python (avec gestion d'erreur)
# ===================================================================
echo "📦 Nettoyage des caches Python..."
pip cache purge 2>/dev/null || echo "Cache pip déjà désactivé"
python -m pip cache purge 2>/dev/null || echo "Cache pip déjà désactivé"

# Supprimer les fichiers .pyc et __pycache__
find /usr/local/lib/python*/site-packages/ -name "*.pyc" -delete 2>/dev/null || true
find /usr/local/lib/python*/site-packages/ -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
find /app -name "*.pyc" -delete 2>/dev/null || true
find /app -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

# ===================================================================
# 2. Nettoyage des packages système
# ===================================================================
echo "🗑️ Nettoyage des packages système..."
apt-get autoremove -y 2>/dev/null || true
apt-get autoclean 2>/dev/null || true
apt-get clean 2>/dev/null || true
rm -rf /var/lib/apt/lists/* 2>/dev/null || true
rm -rf /var/cache/apt/* 2>/dev/null || true

# ===================================================================
# 3. Nettoyage des fichiers temporaires
# ===================================================================
echo "🧽 Suppression des fichiers temporaires..."
rm -rf /tmp/* 2>/dev/null || true
rm -rf /var/tmp/* 2>/dev/null || true
rm -rf /root/.cache/* 2>/dev/null || true
rm -rf /home/*/.cache/* 2>/dev/null || true

# ===================================================================
# 4. Nettoyage spécifique PyTorch
# ===================================================================
echo "🔥 Nettoyage spécifique PyTorch..."
# Supprimer les fichiers de test PyTorch
find /usr/local/lib/python*/site-packages/torch -name "test*" -type d -exec rm -rf {} + 2>/dev/null || true
find /usr/local/lib/python*/site-packages/torchvision -name "test*" -type d -exec rm -rf {} + 2>/dev/null || true

# Supprimer les exemples et documentation
find /usr/local/lib/python*/site-packages/torch -name "examples" -type d -exec rm -rf {} + 2>/dev/null || true
find /usr/local/lib/python*/site-packages/torch -name "docs" -type d -exec rm -rf {} + 2>/dev/null || true

# ===================================================================
# 5. Nettoyage des bibliothèques ML
# ===================================================================
echo "🤖 Nettoyage des bibliothèques ML..."
# Supprimer les tests et exemples des bibliothèques ML
find /usr/local/lib/python*/site-packages/sklearn -name "tests" -type d -exec rm -rf {} + 2>/dev/null || true
find /usr/local/lib/python*/site-packages/scipy -name "tests" -type d -exec rm -rf {} + 2>/dev/null || true
find /usr/local/lib/python*/site-packages/numpy -name "tests" -type d -exec rm -rf {} + 2>/dev/null || true
find /usr/local/lib/python*/site-packages/transformers -name "tests" -type d -exec rm -rf {} + 2>/dev/null || true

# ===================================================================
# 6. Suppression des fichiers de développement
# ===================================================================
echo "🛠️ Suppression des fichiers de développement..."
find /usr/local/lib/python*/site-packages/ -name "*.pyx" -delete 2>/dev/null || true
find /usr/local/lib/python*/site-packages/ -name "*.pxd" -delete 2>/dev/null || true
find /usr/local/lib/python*/site-packages/ -name "*.c" -delete 2>/dev/null || true
find /usr/local/lib/python*/site-packages/ -name "*.cpp" -delete 2>/dev/null || true
find /usr/local/lib/python*/site-packages/ -name "*.h" -delete 2>/dev/null || true

# ===================================================================
# 7. Nettoyage des logs et historiques
# ===================================================================
echo "📝 Nettoyage des logs..."
rm -rf /var/log/* 2>/dev/null || true
rm -rf /root/.bash_history 2>/dev/null || true
rm -rf /home/*/.bash_history 2>/dev/null || true

# ===================================================================
# 8. Optimisation des permissions et propriétés
# ===================================================================
echo "🔐 Optimisation des permissions..."
# Supprimer les fichiers de sauvegarde
find /app -name "*.bak" -delete 2>/dev/null || true
find /app -name "*.backup" -delete 2>/dev/null || true
find /app -name "*.old" -delete 2>/dev/null || true
find /app -name "*~" -delete 2>/dev/null || true

# ===================================================================
# 9. Nettoyage final et compression
# ===================================================================
echo "🗜️ Nettoyage final..."
# Vider les fichiers de logs sans les supprimer
find /var/log -type f -exec truncate -s 0 {} \; 2>/dev/null || true

# Supprimer les fichiers vides
find /app -type f -empty -delete 2>/dev/null || true

# ===================================================================
# 10. Rapport de nettoyage
# ===================================================================
echo "📊 Génération du rapport de nettoyage..."
df -h > /tmp/cleanup_report.txt 2>/dev/null || true
du -sh /usr/local/lib/python*/site-packages/* 2>/dev/null | sort -hr | head -20 >> /tmp/cleanup_report.txt 2>/dev/null || true

echo "✅ Nettoyage terminé avec succès!"
echo "📋 Rapport disponible dans /tmp/cleanup_report.txt"

# Afficher l'espace disque final
echo "💾 Espace disque après nettoyage:"
df -h / 2>/dev/null || true

# Ne pas essayer de se supprimer - Docker s'en chargera
echo "🎯 Script de nettoyage terminé - prêt pour suppression par Docker"