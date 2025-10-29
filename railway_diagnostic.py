#!/usr/bin/env python3
"""
Script de diagnostic pour Railway
Aide à identifier les problèmes de déploiement
"""

import os
import sys
import json
from pathlib import Path

def check_environment():
    """Vérifie les variables d'environnement Railway"""
    print("🔍 Vérification des variables d'environnement Railway...")
    
    required_vars = {
        'PORT': 'Port d\'écoute de l\'application',
        'RAILWAY_ENVIRONMENT': 'Environnement Railway',
        'SECRET_KEY': 'Clé secrète Django',
        'MONGODB_URI': 'URI de connexion MongoDB',
        'DEBUG': 'Mode debug Django'
    }
    
    missing_vars = []
    for var, description in required_vars.items():
        value = os.getenv(var)
        if value:
            # Masquer les valeurs sensibles
            if var in ['SECRET_KEY', 'MONGODB_URI']:
                display_value = f"{value[:10]}..." if len(value) > 10 else "***"
            else:
                display_value = value
            print(f"✅ {var}: {display_value}")
        else:
            print(f"❌ {var}: NON DÉFINIE ({description})")
            missing_vars.append(var)
    
    return missing_vars

def check_django_config():
    """Vérifie la configuration Django"""
    print("\n🔍 Vérification de la configuration Django...")
    
    try:
        # Simuler l'environnement Railway
        os.environ.setdefault('RAILWAY_ENVIRONMENT', 'production')
        os.environ.setdefault('PORT', '8000')
        os.environ.setdefault('DEBUG', 'False')
        
        # Ajouter le répertoire du projet au path
        project_dir = Path(__file__).parent
        sys.path.insert(0, str(project_dir))
        
        # Mock dotenv pour éviter l'erreur d'import
        import types
        dotenv_mock = types.ModuleType('dotenv')
        dotenv_mock.load_dotenv = lambda: None
        sys.modules['dotenv'] = dotenv_mock
        
        from my_journal_intime import settings
        
        print(f"✅ ALLOWED_HOSTS: {settings.ALLOWED_HOSTS}")
        print(f"✅ DEBUG: {settings.DEBUG}")
        print(f"✅ STATIC_ROOT: {settings.STATIC_ROOT}")
        print(f"✅ DATABASE ENGINE: {settings.DATABASES['default']['ENGINE']}")
        
        return True
        
    except Exception as e:
        print(f"❌ Erreur de configuration Django: {e}")
        return False

def check_port_config():
    """Vérifie la configuration du port"""
    print("\n🔍 Vérification de la configuration du port...")
    
    port = os.getenv('PORT', '8000')
    print(f"✅ PORT configuré: {port}")
    
    # Vérifier que le port est numérique
    try:
        port_num = int(port)
        if 1024 <= port_num <= 65535:
            print(f"✅ Port valide: {port_num}")
            return True
        else:
            print(f"❌ Port invalide: {port_num} (doit être entre 1024 et 65535)")
            return False
    except ValueError:
        print(f"❌ Port non numérique: {port}")
        return False

def generate_railway_config():
    """Génère une configuration Railway recommandée"""
    print("\n📝 Configuration Railway recommandée:")
    
    config = {
        "variables": {
            "PORT": "8000",
            "RAILWAY_ENVIRONMENT": "production",
            "DEBUG": "False",
            "DJANGO_SETTINGS_MODULE": "my_journal_intime.settings",
            "DJANGO_LOG_LEVEL": "INFO",
            "STATIC_ROOT": "/tmp/staticfiles",
            "SECRET_KEY": "[À CONFIGURER - Clé secrète Django]",
            "MONGODB_URI": "[À CONFIGURER - URI MongoDB Atlas]",
            "ALLOWED_HOSTS": "[OPTIONNEL - Domaines autorisés]"
        },
        "build": {
            "dockerfile": "Dockerfile"
        },
        "deploy": {
            "healthcheck": "/health/",
            "restart_policy": "always"
        }
    }
    
    print(json.dumps(config, indent=2, ensure_ascii=False))

def main():
    """Fonction principale"""
    print("🚀 Diagnostic Railway pour MyJournal\n")
    
    # Vérifications
    missing_vars = check_environment()
    django_ok = check_django_config()
    port_ok = check_port_config()
    
    print("\n" + "="*50)
    print("📊 RÉSUMÉ DU DIAGNOSTIC")
    print("="*50)
    
    if not missing_vars and django_ok and port_ok:
        print("🎉 TOUTES LES VÉRIFICATIONS SONT RÉUSSIES !")
        print("✅ L'application devrait fonctionner sur Railway")
    else:
        print("❌ PROBLÈMES DÉTECTÉS :")
        if missing_vars:
            print(f"   • Variables manquantes: {', '.join(missing_vars)}")
        if not django_ok:
            print("   • Configuration Django incorrecte")
        if not port_ok:
            print("   • Configuration du port incorrecte")
    
    generate_railway_config()
    
    print("\n🔧 ÉTAPES DE CORRECTION :")
    print("1. Configurez les variables d'environnement manquantes dans Railway Dashboard")
    print("2. Redéployez l'application après les corrections")
    print("3. Vérifiez les logs de déploiement Railway")
    print("4. Testez l'endpoint /health/ une fois déployé")

if __name__ == "__main__":
    main()