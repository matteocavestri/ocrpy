# Usa un'immagine base Debian
FROM python:3.12-slim-bookworm

# Aggiorna l'indice dei pacchetti e installa le dipendenze necessarie
RUN apt-get update && apt-get install -y \
  gcc \
  libmupdf-dev \
  mupdf-tools \
  poppler-utils \
  tesseract-ocr \
  tesseract-ocr-eng \
  libfreetype6-dev \
  make \
  g++ \
  git \
  cmake \
  python3-dev \
  pkg-config \
  libjpeg-dev \
  zlib1g-dev

# Pulisci la cache APT per ridurre la dimensione dell'immagine
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Installa le dipendenze Python
COPY requirements.txt /tmp/
RUN pip install --upgrade pip && \
  pip install --no-cache-dir -r /tmp/requirements.txt

# Crea le directory necessarie
RUN mkdir /app && mkdir /app/input && mkdir /app/ocr_output && mkdir /app/ocr_output/png && mkdir /app/ocr_output/markdown

# Copia il codice sorgente nel container
COPY ocrpy.py /app/ocrpy.py

# Aggiungi un nuovo utente 'appuser'
RUN useradd -ms /bin/bash appuser

# Cambia la proprietà delle directory
RUN chown -R appuser:appuser /app

# Imposta la directory di lavoro
WORKDIR /app

# Cambia l'utente da root a appuser
USER appuser

# Configura i volumi per i file di input e output
VOLUME ["/app/input", "/app/ocr_output"]

# Imposta il punto di ingresso per l'esecuzione dello script
ENTRYPOINT ["python", "/app/ocrpy.py"]

