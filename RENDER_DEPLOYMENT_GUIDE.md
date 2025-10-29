# 🚀 Guide de Déploiement Render - MyJournal

Ce guide vous explique comment déployer votre application Django MyJournal sur Render.

## 📋 Prérequis

- ✅ Compte Render (gratuit sur [render.com](https://render.com))
- ✅ Compte GitHub avec votre code
- ✅ Base de données MongoDB Atlas configurée
- ✅ Clé secrète Django générée

## 🔧 Étape 1 : Préparation du Code

### 1.1 Vérifiez les fichiers de configuration

Assurez-vous que ces fichiers sont présents dans votre projet :

```
MyJournal/
├── render.yaml          ✅ Configuration Render
├── build.sh            ✅ Script de build
├── .env.render         ✅ Variables d'environnement
├── requirements.txt    ✅ Dépendances Python
└── my_journal_intime/
    └── settings.py     ✅ Settings Django optimisés
```

### 1.2 Rendez le script de build exécutable

```bash
chmod +x build.sh
```

### 1.3 Commitez et poussez sur GitHub

```bash
git add .
git commit -m "Configuration Render ajoutée"
git push origin main
```

## 🌐 Étape 2 : Configuration sur Render

### 2.1 Créer un nouveau service Web

1. Connectez-vous à [Render Dashboard](https://dashboard.render.com)
2. Cliquez sur **"New +"** → **"Web Service"**
3. Connectez votre repository GitHub
4. Sélectionnez votre projet MyJournal

### 2.2 Configuration du service

**Paramètres de base :**
- **Name:** `myjournal-app` (ou votre choix)
- **Environment:** `Python 3`
- **Region:** `Frankfurt (EU Central)` (recommandé pour l'Europe)
- **Branch:** `main`

**Paramètres de build :**
- **Build Command:** `./build.sh`
- **Start Command:** `gunicorn --bind 0.0.0.0:$PORT --workers 2 --threads 4 --worker-class gthread --worker-tmp-dir /dev/shm --log-level info --access-logfile - --error-logfile - my_journal_intime.wsgi:application`

### 2.3 Configuration des variables d'environnement

Dans la section **Environment Variables**, ajoutez :

#### Variables obligatoires :
```
RENDER=true
DEBUG=false
DJANGO_SETTINGS_MODULE=my_journal_intime.settings
DJANGO_LOG_LEVEL=INFO
STATIC_ROOT=/tmp/staticfiles
PYTHONUNBUFFERED=1
```

#### Variables à personnaliser :
```
SECRET_KEY=votre-clé-secrète-django-ici
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/myjournal?retryWrites=true&w=majority
ALLOWED_HOSTS=votre-app.onrender.com
```

### 2.4 Configuration avancée

**Plan :** Starter (gratuit)
**Auto-Deploy :** Activé
**Health Check Path :** `/health/`

## 🔐 Étape 3 : Génération de la Clé Secrète

Générez une nouvelle clé secrète Django sécurisée :

```python
# Dans un terminal Python
import secrets
print(secrets.token_urlsafe(50))
```

Copiez cette clé dans la variable `SECRET_KEY` sur Render.

## 🗄️ Étape 4 : Configuration MongoDB Atlas

### 4.1 Créer un cluster MongoDB Atlas

1. Allez sur [MongoDB Atlas](https://cloud.mongodb.com)
2. Créez un cluster gratuit (M0)
3. Configurez l'accès réseau : **0.0.0.0/0** (accès depuis partout)

### 4.2 Créer un utilisateur de base de données

1. Database Access → Add New Database User
2. Username : `journal_user`
3. Password : Générez un mot de passe fort
4. Rôles : `readWrite` sur `journalDB`

### 4.3 Obtenir l'URI de connexion

1. Clusters → Connect → Connect your application
2. Copiez l'URI : `mongodb+srv://journal_user:PASSWORD@cluster.mongodb.net/journalDB?retryWrites=true&w=majority`
3. Remplacez `PASSWORD` par votre mot de passe
4. Ajoutez cette URI dans `MONGODB_URI` sur Render

## 🚀 Étape 5 : Déploiement

### 5.1 Lancer le déploiement

1. Cliquez sur **"Create Web Service"**
2. Render va automatiquement :
   - Cloner votre repository
   - Exécuter `build.sh`
   - Installer les dépendances
   - Collecter les fichiers statiques
   - Démarrer l'application

### 5.2 Surveiller le déploiement

- **Logs :** Consultez les logs en temps réel
- **Durée :** Premier déploiement ~5-10 minutes
- **Status :** Attendez le status "Live"

### 5.3 Obtenir l'URL de votre application

Une fois déployé, votre application sera disponible à :
```
https://votre-app.onrender.com
```

## ✅ Étape 6 : Vérification Post-Déploiement

### 6.1 Test de santé

Visitez : `https://votre-app.onrender.com/health/`

Vous devriez voir :
```json
{
    "status": "healthy",
    "debug": false,
    "allowed_hosts": ["votre-app.onrender.com"],
    "static_root": "/tmp/staticfiles"
}
```

### 6.2 Test de l'application

1. **Page d'accueil :** `https://votre-app.onrender.com/`
2. **Admin :** `https://votre-app.onrender.com/admin/`
3. **Connexion :** `https://votre-app.onrender.com/login/`

## 🔧 Dépannage Courant

### Erreur 502 Bad Gateway
- Vérifiez les logs Render
- Assurez-vous que `MONGODB_URI` est correct
- Vérifiez que `SECRET_KEY` est défini

### Erreur de fichiers statiques
- Les fichiers statiques sont dans `/tmp/staticfiles`
- WhiteNoise gère automatiquement le service
- Vérifiez `STATIC_ROOT` dans les variables d'environnement

### Erreur de base de données
- Testez la connexion MongoDB Atlas
- Vérifiez l'URI de connexion
- Assurez-vous que l'IP 0.0.0.0/0 est autorisée

### Application lente au démarrage
- Normal sur le plan gratuit (cold start)
- L'application se "réveille" après inactivité
- Considérez un plan payant pour éviter cela

## 🔄 Mises à Jour

Pour mettre à jour votre application :

1. Modifiez votre code localement
2. Commitez et poussez sur GitHub
3. Render redéploie automatiquement
4. Surveillez les logs de déploiement

## 📊 Monitoring

### Métriques disponibles
- **CPU Usage**
- **Memory Usage** 
- **Response Time**
- **Request Count**

### Logs
- **Build Logs :** Processus de construction
- **Deploy Logs :** Déploiement
- **Service Logs :** Application en cours d'exécution

## 💡 Conseils d'Optimisation

1. **Performance :**
   - Utilisez le cache Django configuré
   - Optimisez les requêtes MongoDB
   - Compressez les images

2. **Sécurité :**
   - Gardez `DEBUG=false` en production
   - Utilisez HTTPS (automatique sur Render)
   - Configurez les headers de sécurité

3. **Monitoring :**
   - Surveillez les logs régulièrement
   - Configurez des alertes si nécessaire
   - Testez périodiquement l'endpoint `/health/`

## 🆘 Support

- **Documentation Render :** [docs.render.com](https://docs.render.com)
- **Support Render :** Via le dashboard
- **Logs de l'application :** Consultez `/health/` pour le diagnostic

---

✅ **Votre application MyJournal est maintenant déployée sur Render !**