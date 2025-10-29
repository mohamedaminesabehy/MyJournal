# Analyse des Dépendances Volumineuses - MyJournal

## 📊 Dépendances les Plus Volumineuses

### 🔥 Très Volumineuses (>500MB)
1. **torch==2.1.1** (~2.5GB)
   - PyTorch pour l'apprentissage automatique
   - **Impact**: Très élevé sur la taille de l'image
   - **Optimisation**: Utiliser torch-cpu ou version allégée

2. **torchvision==0.16.1** (~300MB)
   - Vision par ordinateur pour PyTorch
   - **Impact**: Élevé
   - **Optimisation**: Installer seulement si nécessaire

3. **opencv-python==4.8.1.78** (~200MB)
   - Traitement d'images et vision par ordinateur
   - **Impact**: Élevé
   - **Optimisation**: Utiliser opencv-python-headless

### 🟡 Volumineuses (100-500MB)
4. **transformers==4.35.2** (~150MB)
   - Modèles de transformers Hugging Face
   - **Impact**: Modéré à élevé

5. **scikit-learn==1.3.2** (~100MB)
   - Bibliothèque d'apprentissage automatique
   - **Impact**: Modéré

6. **scipy==1.11.4** (~80MB)
   - Calculs scientifiques
   - **Impact**: Modéré

7. **numpy==1.24.3** (~50MB)
   - Calculs numériques (dépendance de base)
   - **Impact**: Modéré mais nécessaire

### 🟢 Moyennes (<100MB)
8. **pandas==2.1.4** (~40MB)
9. **Pillow==10.1.0** (~10MB)
10. **Django==3.2.25** (~15MB)

## 🎯 Stratégies d'Optimisation

### 1. Optimisations PyTorch
```dockerfile
# Au lieu de torch complet, utiliser CPU-only
RUN pip install torch==2.1.1+cpu torchvision==0.16.1+cpu -f https://download.pytorch.org/whl/torch_stable.html
```

### 2. OpenCV Optimisé
```dockerfile
# Remplacer opencv-python par opencv-python-headless (plus léger)
RUN pip install opencv-python-headless==4.8.1.78
```

### 3. Installation Sélective
```dockerfile
# Installer seulement les composants nécessaires
RUN pip install --no-cache-dir --no-deps package_name
```

### 4. Nettoyage Post-Installation
```dockerfile
# Supprimer les caches et fichiers temporaires
RUN pip cache purge && \
    find /usr/local/lib/python*/site-packages/ -name "*.pyc" -delete && \
    find /usr/local/lib/python*/site-packages/ -name "__pycache__" -type d -exec rm -rf {} + || true
```

## 📈 Estimation de Réduction de Taille

| Optimisation | Réduction Estimée |
|--------------|-------------------|
| PyTorch CPU-only | -1.5GB |
| OpenCV headless | -50MB |
| Nettoyage caches | -200MB |
| Suppression dev files | -100MB |
| **Total Estimé** | **~1.85GB** |

## ⚠️ Considérations Importantes

1. **Fonctionnalité**: Vérifier que les versions allégées supportent toutes les fonctionnalités nécessaires
2. **Compatibilité**: Tester l'application avec les versions optimisées
3. **Performance**: Les versions CPU-only peuvent être plus lentes pour les calculs ML

## 🔧 Recommandations Finales

1. **Priorité 1**: Utiliser PyTorch CPU-only (-1.5GB)
2. **Priorité 2**: Remplacer opencv-python par opencv-python-headless (-50MB)
3. **Priorité 3**: Optimiser le nettoyage des caches (-200MB)
4. **Priorité 4**: Supprimer les fichiers de développement (-100MB)

**Réduction totale estimée**: 6.5GB → 4.65GB (sous la limite de 4GB avec optimisations supplémentaires)