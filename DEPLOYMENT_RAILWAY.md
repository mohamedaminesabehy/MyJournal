# Guide de Déploiement sur Railway - MyJournal

## 📋 Résumé des Modifications Effectuées

### Fichiers Créés/Modifiés :
- ✅ `Procfile` - Configuration du serveur web
- ✅ `runtime.txt` - Version Python spécifiée
- ✅ `railway.json` - Configuration Railway
- ✅ `requirements.txt` - Ajout de gunicorn et whitenoise
- ✅ `settings.py` - Configuration production avec variables d'environnement
- ✅ `.env.production` - Template des variables d'environnement

## 🚀 Étapes de Déploiement sur Railway

### 1. Préparation du Code
Votre code est maintenant prêt pour Railway avec :
- Configuration MongoDB Atlas via variables d'environnement
- Serveur de production Gunicorn
- Gestion des fichiers statiques avec WhiteNoise
- Configuration de sécurité pour la production

### 2. Créer un Compte Railway
1. Allez sur [railway.app](https://railway.app)
2. Connectez-vous avec GitHub
3. Autorisez Railway à accéder à vos repositories

### 3. Déployer l'Application

#### Option A : Depuis GitHub (Recommandé)
1. **Pusher le code sur GitHub :**
   ```bash
   git add .
   git commit -m "Préparation pour déploiement Railway"
   git push origin main
   ```

2. **Créer un nouveau projet sur Railway :**
   - Cliquez sur "New Project"
   - Sélectionnez "Deploy from GitHub repo"
   - Choisissez votre repository MyJournal
   - Railway détectera automatiquement Django

#### Option B : Depuis CLI Railway
1. **Installer Railway CLI :**
   ```bash
   npm install -g @railway/cli
   ```

2. **Se connecter et déployer :**
   ```bash
   railway login
   railway init
   railway up
   ```

### 4. Configuration des Variables d'Environnement

Dans le Dashboard Railway, allez dans l'onglet "Variables" et ajoutez :

```env
SECRET_KEY=votre-nouvelle-clé-secrète-très-longue-et-sécurisée
DEBUG=False
ALLOWED_HOSTS=votre-app-name.railway.app,*.railway.app
MONGODB_URI=mongodb+srv://journal_db_user:4PIF3Mk876wkTopF@cluster0.kgaymb3.mongodb.net/journalDB?retryWrites=true&w=majority
DJANGO_LOG_LEVEL=INFO
```

**Variables AI Optionnelles (si vous les utilisez) :**
```env
GOOGLE_VISION_API_KEY=votre_clé_google_vision
OPENAI_API_KEY=votre_clé_openai
GOOGLE_GEMINI_API_KEY=votre_clé_gemini
HUGGING_FACE_API_KEY=votre_clé_hugging_face
PERPLEXITY_API_KEY=votre_clé_perplexity
AI_VISION_SERVICE=clip
AI_TEXT_SERVICE=local
```

### 5. Générer une Nouvelle SECRET_KEY

**Important :** Générez une nouvelle clé secrète pour la production :

```python
# Exécutez ce code Python pour générer une nouvelle clé
import secrets
print(secrets.token_urlsafe(50))
```

### 6. Mise à Jour des ALLOWED_HOSTS

Après le déploiement, Railway vous donnera une URL comme :
`https://votre-app-name.railway.app`

Mettez à jour la variable `ALLOWED_HOSTS` avec cette URL :
```env
ALLOWED_HOSTS=votre-app-name.railway.app,*.railway.app
```

### 7. Vérification du Déploiement

1. **Vérifiez les logs :**
   - Dans Railway Dashboard → onglet "Deployments"
   - Cliquez sur le déploiement actuel pour voir les logs

2. **Testez l'application :**
   - Ouvrez l'URL fournie par Railway
   - Vérifiez que l'application se charge correctement
   - Testez la connexion à MongoDB Atlas

### 8. Configuration du Domaine Personnalisé (Optionnel)

1. Dans Railway Dashboard → onglet "Settings"
2. Section "Domains"
3. Ajoutez votre domaine personnalisé
4. Mettez à jour `ALLOWED_HOSTS` avec votre nouveau domaine

## 🔧 Dépannage

### Problèmes Courants :

1. **Erreur 500 - Internal Server Error :**
   - Vérifiez les logs dans Railway Dashboard
   - Assurez-vous que `DEBUG=False` en production
   - Vérifiez que toutes les variables d'environnement sont définies

2. **Problème de fichiers statiques :**
   - WhiteNoise est configuré pour gérer les fichiers statiques
   - Les fichiers sont collectés automatiquement via le Procfile

3. **Erreur de connexion MongoDB :**
   - Vérifiez que `MONGODB_URI` est correctement définie
   - Assurez-vous que l'IP de Railway est autorisée dans MongoDB Atlas (0.0.0.0/0 pour autoriser toutes les IPs)

4. **Timeout de déploiement :**
   - Les dépendances ML (torch, transformers) peuvent prendre du temps
   - Railway a un timeout de 10 minutes pour le build

### Commandes Utiles :

```bash
# Voir les logs en temps réel
railway logs

# Redéployer
railway up

# Ouvrir l'application
railway open
```

## 📊 Monitoring

Railway fournit automatiquement :
- Métriques de performance
- Logs d'application
- Monitoring de la santé de l'app
- Alertes en cas de problème

## 💰 Coûts

Railway offre :
- Plan gratuit : 500 heures d'exécution/mois
- Plan Pro : $5/mois pour usage illimité
- Facturation à l'usage pour les ressources supplémentaires

## 🔄 Mises à Jour

Pour mettre à jour l'application :
1. Modifiez votre code localement
2. Committez et pushez sur GitHub
3. Railway redéploiera automatiquement

## ✅ Checklist Final

- [ ] Code pushé sur GitHub
- [ ] Projet créé sur Railway
- [ ] Variables d'environnement configurées
- [ ] SECRET_KEY générée et définie
- [ ] ALLOWED_HOSTS mis à jour avec l'URL Railway
- [ ] Application accessible via l'URL Railway
- [ ] MongoDB Atlas connecté et fonctionnel
- [ ] Tests de base effectués

Votre application MyJournal est maintenant déployée sur Railway avec MongoDB Atlas ! 🎉