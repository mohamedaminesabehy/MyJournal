# 🧪 Guide de Test Post-Déploiement - MyJournal sur Render

Ce guide vous aide à tester et vérifier que votre application MyJournal fonctionne correctement après déploiement sur Render.

## 📋 Checklist de Tests

### ✅ Tests Automatiques

- [ ] Endpoint de santé
- [ ] Chargement de la page d'accueil
- [ ] Fichiers statiques (CSS/JS)
- [ ] Connexion à la base de données
- [ ] Authentification utilisateur
- [ ] Fonctionnalités CRUD du journal

### ✅ Tests de Performance

- [ ] Temps de réponse
- [ ] Gestion de la charge
- [ ] Optimisation des ressources

### ✅ Tests de Sécurité

- [ ] HTTPS activé
- [ ] Headers de sécurité
- [ ] Protection CSRF

## 🔍 Étape 1 : Tests de Base

### 1.1 Test de Santé de l'Application

**URL :** `https://votre-app.onrender.com/health/`

**Réponse attendue :**
```json
{
    "status": "healthy",
    "debug": false,
    "allowed_hosts": ["votre-app.onrender.com"],
    "static_root": "/tmp/staticfiles"
}
```

**Vérifications :**
- ✅ Status Code : 200
- ✅ `debug` : false (sécurité)
- ✅ `allowed_hosts` contient votre domaine
- ✅ `static_root` : `/tmp/staticfiles`

### 1.2 Test de la Page d'Accueil

**URL :** `https://votre-app.onrender.com/`

**Vérifications :**
- ✅ Page se charge sans erreur (200)
- ✅ CSS appliqué correctement
- ✅ Images affichées
- ✅ Navigation fonctionnelle
- ✅ Pas d'erreurs JavaScript dans la console

### 1.3 Test des Fichiers Statiques

**Vérifiez que ces ressources se chargent :**
- ✅ `https://votre-app.onrender.com/static/css/style.css`
- ✅ `https://votre-app.onrender.com/static/js/script.js`
- ✅ Images et icônes

**Commande de test :**
```bash
curl -I https://votre-app.onrender.com/static/css/style.css
```

**Réponse attendue :**
```
HTTP/2 200
content-type: text/css
cache-control: max-age=31536000
```

## 🔐 Étape 2 : Tests d'Authentification

### 2.1 Test de la Page de Connexion

**URL :** `https://votre-app.onrender.com/login/`

**Vérifications :**
- ✅ Formulaire de connexion affiché
- ✅ Champs username/password présents
- ✅ Token CSRF généré
- ✅ Redirection après connexion

### 2.2 Test de Création de Compte

**URL :** `https://votre-app.onrender.com/register/` (si disponible)

**Vérifications :**
- ✅ Formulaire d'inscription fonctionnel
- ✅ Validation des champs
- ✅ Création d'utilisateur en base
- ✅ Email de confirmation (si configuré)

### 2.3 Test de Session

**Procédure :**
1. Connectez-vous avec un compte test
2. Naviguez dans l'application
3. Vérifiez la persistance de session
4. Testez la déconnexion

## 📝 Étape 3 : Tests Fonctionnels du Journal

### 3.1 Test CRUD des Entrées

**Création d'entrée :**
- ✅ Accès à `/category_management/`
- ✅ Création d'une nouvelle entrée
- ✅ Sauvegarde en base MongoDB
- ✅ Affichage de l'entrée créée

**Lecture d'entrée :**
- ✅ Liste des entrées affichée
- ✅ Détail d'une entrée accessible
- ✅ Pagination fonctionnelle (si applicable)

**Modification d'entrée :**
- ✅ Édition d'une entrée existante
- ✅ Sauvegarde des modifications
- ✅ Mise à jour en base

**Suppression d'entrée :**
- ✅ Suppression d'une entrée
- ✅ Confirmation de suppression
- ✅ Suppression effective en base

### 3.2 Test des Catégories

**Vérifications :**
- ✅ Gestion des catégories
- ✅ Association entrée-catégorie
- ✅ Filtrage par catégorie

## 🗄️ Étape 4 : Tests de Base de Données

### 4.1 Test de Connexion MongoDB

**Vérification via logs Render :**
```
[INFO] Connected to MongoDB successfully
[INFO] Database: journalDB
```

### 4.2 Test de Performance DB

**Commandes de test (via shell Django) :**
```python
# Test de connexion
from django.db import connection
cursor = connection.cursor()
cursor.execute("db.runCommand('ping')")

# Test de requête
from journal.models import Entry
entries = Entry.objects.all()[:10]
print(f"Nombre d'entrées: {entries.count()}")
```

### 4.3 Test de Persistance

**Procédure :**
1. Créez une entrée de test
2. Redémarrez l'application (via Render)
3. Vérifiez que l'entrée existe toujours

## ⚡ Étape 5 : Tests de Performance

### 5.1 Test de Temps de Réponse

**Outils recommandés :**
- [GTmetrix](https://gtmetrix.com/)
- [PageSpeed Insights](https://pagespeed.web.dev/)
- [WebPageTest](https://www.webpagetest.org/)

**Métriques cibles :**
- ✅ First Contentful Paint < 2s
- ✅ Largest Contentful Paint < 4s
- ✅ Time to Interactive < 5s

### 5.2 Test de Charge

**Outil simple avec curl :**
```bash
# Test de 10 requêtes simultanées
for i in {1..10}; do
  curl -w "%{time_total}\n" -o /dev/null -s https://votre-app.onrender.com/ &
done
wait
```

**Métriques à surveiller :**
- ✅ Temps de réponse stable
- ✅ Pas d'erreurs 5xx
- ✅ Memory usage acceptable

### 5.3 Test de Cold Start

**Procédure :**
1. Attendez 15 minutes d'inactivité
2. Visitez l'application
3. Mesurez le temps de "réveil"

**Résultat attendu :**
- ⏱️ Cold start : 10-30 secondes (normal sur plan gratuit)
- ⚡ Requêtes suivantes : < 2 secondes

## 🔒 Étape 6 : Tests de Sécurité

### 6.1 Test HTTPS

**Vérification :**
```bash
curl -I https://votre-app.onrender.com/
```

**Headers attendus :**
```
HTTP/2 200
strict-transport-security: max-age=31536000; includeSubDomains; preload
x-content-type-options: nosniff
x-frame-options: DENY
```

### 6.2 Test des Headers de Sécurité

**Outil en ligne :** [Security Headers](https://securityheaders.com/)

**Vérifications :**
- ✅ HSTS activé
- ✅ X-Content-Type-Options: nosniff
- ✅ X-Frame-Options: DENY
- ✅ Content-Security-Policy (si configuré)

### 6.3 Test CSRF

**Procédure :**
1. Inspectez un formulaire
2. Vérifiez la présence du token CSRF
3. Testez une soumission sans token (doit échouer)

## 📊 Étape 7 : Monitoring et Logs

### 7.1 Surveillance des Logs

**Accès aux logs Render :**
1. Dashboard Render → Votre service
2. Onglet "Logs"
3. Filtrez par type : Build, Deploy, Service

**Logs à surveiller :**
```
[INFO] Starting gunicorn
[INFO] Listening at: http://0.0.0.0:10000
[INFO] Connected to MongoDB
```

### 7.2 Métriques de Performance

**Dashboard Render - Métriques :**
- 📈 CPU Usage (< 80%)
- 💾 Memory Usage (< 512MB)
- 🌐 Request Count
- ⏱️ Response Time

### 7.3 Alertes et Notifications

**Configuration recommandée :**
- ✅ Alertes sur erreurs 5xx
- ✅ Notifications de déploiement
- ✅ Surveillance de l'uptime

## 🧪 Étape 8 : Tests Automatisés

### 8.1 Script de Test Complet

Créez un script `test_production.py` :

```python
#!/usr/bin/env python3
import requests
import json
import sys

BASE_URL = "https://votre-app.onrender.com"

def test_health():
    """Test de l'endpoint de santé"""
    response = requests.get(f"{BASE_URL}/health/")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert data["debug"] == False
    print("✅ Health check passed")

def test_homepage():
    """Test de la page d'accueil"""
    response = requests.get(BASE_URL)
    assert response.status_code == 200
    assert "MyJournal" in response.text
    print("✅ Homepage test passed")

def test_static_files():
    """Test des fichiers statiques"""
    response = requests.get(f"{BASE_URL}/static/css/style.css")
    assert response.status_code == 200
    print("✅ Static files test passed")

def run_all_tests():
    """Exécute tous les tests"""
    try:
        test_health()
        test_homepage()
        test_static_files()
        print("\n🎉 Tous les tests sont passés avec succès!")
        return True
    except Exception as e:
        print(f"\n❌ Test échoué: {e}")
        return False

if __name__ == "__main__":
    success = run_all_tests()
    sys.exit(0 if success else 1)
```

### 8.2 Exécution des Tests

```bash
python test_production.py
```

### 8.3 Intégration CI/CD (Optionnel)

Ajoutez à votre `.github/workflows/test.yml` :

```yaml
- name: Test Production
  run: |
    sleep 60  # Attendre le déploiement
    python test_production.py
```

## 🚨 Dépannage des Tests

### Erreurs Courantes

**502 Bad Gateway :**
- Vérifiez les logs de déploiement
- Testez la connexion MongoDB
- Vérifiez les variables d'environnement

**Fichiers statiques manquants :**
- Vérifiez `STATIC_ROOT=/tmp/staticfiles`
- Relancez `collectstatic` via redéploiement
- Vérifiez WhiteNoise dans `MIDDLEWARE`

**Erreurs de base de données :**
- Testez `MONGODB_URI` localement
- Vérifiez les permissions MongoDB Atlas
- Contrôlez les timeouts de connexion

### Commandes de Debug

```bash
# Test de connectivité
curl -v https://votre-app.onrender.com/health/

# Test des headers
curl -I https://votre-app.onrender.com/

# Test avec timeout
curl --max-time 30 https://votre-app.onrender.com/
```

## 📈 Rapport de Test

### Template de Rapport

```markdown
# Rapport de Test - MyJournal sur Render

**Date :** [DATE]
**URL :** https://votre-app.onrender.com
**Version :** [VERSION]

## Résultats des Tests

### Tests de Base
- [ ] Health check : ✅/❌
- [ ] Page d'accueil : ✅/❌
- [ ] Fichiers statiques : ✅/❌

### Tests Fonctionnels
- [ ] Authentification : ✅/❌
- [ ] CRUD Journal : ✅/❌
- [ ] Base de données : ✅/❌

### Tests de Performance
- [ ] Temps de réponse : ✅/❌
- [ ] Cold start : ✅/❌
- [ ] Charge : ✅/❌

### Tests de Sécurité
- [ ] HTTPS : ✅/❌
- [ ] Headers sécurité : ✅/❌
- [ ] CSRF : ✅/❌

## Problèmes Identifiés
[Liste des problèmes et solutions]

## Recommandations
[Améliorations suggérées]
```

---

## 🎯 Checklist Finale

Avant de considérer le déploiement comme réussi :

- [ ] ✅ Tous les tests de base passent
- [ ] ✅ Application accessible via HTTPS
- [ ] ✅ Authentification fonctionnelle
- [ ] ✅ Base de données connectée
- [ ] ✅ Fichiers statiques servis
- [ ] ✅ Performance acceptable
- [ ] ✅ Sécurité configurée
- [ ] ✅ Monitoring en place
- [ ] ✅ Documentation à jour

**🎉 Félicitations ! Votre application MyJournal est maintenant testée et prête en production sur Render !**