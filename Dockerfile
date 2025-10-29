# ===================================================================
# Dockerfile optimisé pour MyJournal - Taille réduite < 4GB
# ===================================================================

# ===================================================================
# ÉTAPE 1: Builder - Installation des dépendances OPTIMISÉES
# ===================================================================
FROM python:3.11-slim as builder

# Variables d'environnement pour optimiser Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Installer les dépendances système nécessaires pour la compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc \
    g++ \
    libffi-dev \
    libssl-dev \
    python3-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Créer un environnement virtuel
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copier et installer les dépendances Python OPTIMISÉES
COPY requirements.txt .

# Installation optimisée avec PyTorch CPU-only et OpenCV headless
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    # Installer d'abord les dépendances standard
    pip install --no-cache-dir Django==3.2.25 asgiref==3.7.2 django-cors-headers==4.3.0 django-debug-toolbar==4.2.0 && \
    pip install --no-cache-dir djongo==1.3.6 pymongo==3.12.3 sqlparse==0.2.4 dnspython==2.6.1 && \
    pip install --no-cache-dir Pillow==10.1.0 && \
    # OpenCV headless (plus léger)
    pip install --no-cache-dir opencv-python-headless==4.8.1.78 && \
    # PyTorch CPU-only (économie majeure de ~1.5GB)
    pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu torch==2.1.1+cpu torchvision==0.16.1+cpu && \
    # Autres dépendances ML
    pip install --no-cache-dir numpy==1.24.3 scipy==1.11.4 scikit-learn==1.3.2 && \
    pip install --no-cache-dir transformers==4.35.2 huggingface-hub==0.19.4 tokenizers==0.15.0 safetensors==0.4.1 && \
    pip install --no-cache-dir joblib==1.3.2 pandas==2.1.4 && \
    # Utilitaires et serveur de production
    pip install --no-cache-dir python-decouple==3.8 python-dotenv==1.0.0 requests==2.31.0 pytz==2023.3.post1 certifi==2024.8.30 && \
    pip install --no-cache-dir gunicorn==21.2.0 whitenoise==6.6.0 && \
    # Nettoyer les fichiers temporaires de pip
    pip cache purge && \
    # Supprimer les fichiers .pyc et __pycache__
    find /opt/venv -name "*.pyc" -delete && \
    find /opt/venv -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

# Copier le script de nettoyage et l'exécuter
COPY cleanup_docker.sh /tmp/cleanup_docker.sh
RUN chmod +x /tmp/cleanup_docker.sh && \
    /tmp/cleanup_docker.sh && \
    rm /tmp/cleanup_docker.sh

# ===================================================================
# ÉTAPE 2: Image de production ULTRA-OPTIMISÉE
# ===================================================================
FROM python:3.11-slim as production

# Variables d'environnement optimisées
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    DJANGO_SETTINGS_MODULE=myjournal.settings \
    PORT=8000

# Installer uniquement les dépendances runtime essentielles
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libssl3 \
    ca-certificates \
    && apt-get autoremove -y \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

# Créer un utilisateur non-root pour la sécurité
RUN groupadd -r django && useradd -r -g django django

# Copier l'environnement virtuel depuis le builder
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Créer les répertoires nécessaires
RUN mkdir -p /app/static /app/media && \
    chown -R django:django /app

# Définir le répertoire de travail
WORKDIR /app

# Copier le code de l'application
COPY --chown=django:django . .

# Nettoyage final de l'application
RUN find . -name "*.pyc" -delete && \
    find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true && \
    rm -rf .git .gitignore .env.example *.md || true && \
    rm -rf cleanup_docker.sh requirements.optimized.txt DEPENDENCY_ANALYSIS.md || true && \
    rm -rf temp_* scripts/ || true

# Collecter les fichiers statiques
RUN python manage.py collectstatic --noinput --clear

# Changer vers l'utilisateur non-root
USER django

# Exposer le port
EXPOSE $PORT

# Commande optimisée pour démarrer l'application
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:$PORT --workers 2 --threads 4 --worker-class gthread --worker-tmp-dir /dev/shm --log-level info --access-logfile - --error-logfile - myjournal.wsgi:application"]