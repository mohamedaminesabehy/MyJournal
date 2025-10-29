# Guide de Configuration de l'Environnement Virtuel

## 📋 Prérequis
- Python 3.8+ installé sur votre système
- Git installé et configuré
- Accès au dépôt GitHub du projet

## 🚀 Configuration Initiale après Clonage

### 1. Cloner le Dépôt
```bash
git clone https://github.com/mohamedaminesabehy/MyJournal.git
cd MyJournal
```

### 2. Créer l'Environnement Virtuel
```bash
# Sur Windows
python -m venv venv

# Sur macOS/Linux
python3 -m venv venv
```

### 3. Activer l'Environnement Virtuel
```bash
# Sur Windows (PowerShell)
venv\Scripts\Activate.ps1

# Sur Windows (Command Prompt)
venv\Scripts\activate.bat

# Sur macOS/Linux
source venv/bin/activate
```

### 4. Installer les Dépendances
```bash
pip install -r requirements.txt
```

### 5. Configuration des Variables d'Environnement
```bash
# Copier le fichier d'exemple
cp .env.example .env

# Éditer le fichier .env avec vos propres valeurs
# Notamment PERPLEXITY_API_KEY et autres clés API
```

### 6. Migrations Django
```bash
python manage.py migrate
```

### 7. Créer un Superutilisateur (optionnel)
```bash
python manage.py createsuperuser
```

### 8. Lancer le Serveur de Développement
```bash
python manage.py runserver
```

## 🔄 Utilisation Quotidienne

### Activer l'Environnement
Avant de travailler sur le projet :
```bash
# Windows PowerShell
venv\Scripts\Activate.ps1

# macOS/Linux
source venv/bin/activate
```

### Désactiver l'Environnement
```bash
deactivate
```

### Mettre à Jour les Dépendances
Si de nouvelles dépendances sont ajoutées :
```bash
pip install -r requirements.txt
```

## 📝 Bonnes Pratiques

### ✅ À Faire
- Toujours activer l'environnement virtuel avant de travailler
- Installer les nouvelles dépendances dans l'environnement virtuel
- Mettre à jour `requirements.txt` après l'ajout de nouvelles dépendances :
  ```bash
  pip freeze > requirements.txt
  ```

### ❌ À Éviter
- Ne jamais commiter le dossier `venv/` dans Git
- Ne pas installer les dépendances globalement
- Ne pas oublier d'activer l'environnement virtuel

## 🛠️ Dépannage

### Problème : "Module not found"
```bash
# Vérifier que l'environnement est activé
which python  # macOS/Linux
where python   # Windows

# Réinstaller les dépendances
pip install -r requirements.txt
```

### Problème : Erreur de permissions
```bash
# Sur Windows, exécuter PowerShell en tant qu'administrateur
# Ou modifier la politique d'exécution :
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Recréer l'Environnement Virtuel
Si l'environnement est corrompu :
```bash
# Supprimer l'ancien environnement
rm -rf venv  # macOS/Linux
rmdir /s venv  # Windows

# Recréer l'environnement
python -m venv venv
venv\Scripts\Activate.ps1  # Windows
pip install -r requirements.txt
```

## 📁 Structure des Fichiers

```
MyJournal/
├── venv/                 # ❌ Exclu de Git (.gitignore)
├── .env                  # ❌ Exclu de Git (contient les secrets)
├── .env.example          # ✅ Inclus dans Git (template)
├── requirements.txt      # ✅ Inclus dans Git
├── .gitignore           # ✅ Inclus dans Git
└── manage.py            # ✅ Fichiers du projet
```

## 🔐 Sécurité

- Le fichier `.env` contient des informations sensibles et ne doit jamais être commité
- Utilisez `.env.example` comme template pour les nouvelles installations
- Configurez toujours vos propres clés API dans `.env`

---

**Note :** Ce guide assume l'utilisation de Python et Django. Adaptez les commandes selon votre environnement de développement.