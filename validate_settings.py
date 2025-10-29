#!/usr/bin/env python3
"""
Script de validation pour settings.py
Teste la syntaxe et la structure sans nécessiter toutes les dépendances
"""

import sys
import os
from pathlib import Path

def validate_settings():
    """Valide le fichier settings.py"""
    print("🔍 Validation du fichier settings.py...")
    
    # Test 1: Compilation Python
    try:
        import py_compile
        settings_path = Path(__file__).parent / 'my_journal_intime' / 'settings.py'
        py_compile.compile(settings_path, doraise=True)
        print("✅ Test 1: Syntaxe Python - RÉUSSI")
    except py_compile.PyCompileError as e:
        print(f"❌ Test 1: Erreur de syntaxe - {e}")
        return False
    
    # Test 2: Import basique (sans dépendances)
    try:
        # Simuler les variables d'environnement pour éviter les erreurs
        os.environ.setdefault('SECRET_KEY', 'test-key')
        os.environ.setdefault('DEBUG', 'False')
        
        # Ajouter le répertoire du projet au path
        project_dir = Path(__file__).parent
        sys.path.insert(0, str(project_dir))
        
        # Mock dotenv pour éviter l'erreur d'import
        import types
        dotenv_mock = types.ModuleType('dotenv')
        dotenv_mock.load_dotenv = lambda: None
        sys.modules['dotenv'] = dotenv_mock
        
        # Tenter l'import
        from my_journal_intime import settings
        print("✅ Test 2: Structure du fichier - RÉUSSI")
        
        # Test 3: Vérifier les configurations clés
        required_settings = [
            'SECRET_KEY', 'DEBUG', 'ALLOWED_HOSTS', 'INSTALLED_APPS',
            'MIDDLEWARE', 'DATABASES', 'STATIC_URL', 'STATIC_ROOT'
        ]
        
        missing_settings = []
        for setting in required_settings:
            if not hasattr(settings, setting):
                missing_settings.append(setting)
        
        if missing_settings:
            print(f"❌ Test 3: Paramètres manquants - {missing_settings}")
            return False
        else:
            print("✅ Test 3: Paramètres requis - RÉUSSI")
            
        # Test 4: Vérifier la configuration Render
        if hasattr(settings, 'LOGGING') and isinstance(settings.LOGGING, dict):
            print("✅ Test 4: Configuration LOGGING - RÉUSSI")
        else:
            print("❌ Test 4: Configuration LOGGING - ÉCHOUÉ")
            return False
            
        return True
        
    except Exception as e:
        print(f"❌ Test 2: Erreur d'import - {e}")
        return False

def main():
    """Fonction principale"""
    print("🚀 Validation des corrections de settings.py\n")
    
    if validate_settings():
        print("\n🎉 TOUTES LES VALIDATIONS SONT RÉUSSIES !")
        print("✅ Le fichier settings.py est maintenant correct")
        print("✅ Prêt pour le déploiement sur Render")
        return 0
    else:
        print("\n❌ ÉCHEC DE LA VALIDATION")
        print("⚠️  Veuillez corriger les erreurs avant de continuer")
        return 1

if __name__ == "__main__":
    sys.exit(main())