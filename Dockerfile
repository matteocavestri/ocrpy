# Base image
FROM python:3.12-slim-bookworm

# Install dependencies for PyMuPDF
RUN apt-get update && apt-get install -y \
  libmupdf-dev \
  mupdf-tools \
  libxml2-dev \
  && rm -rf /var/lib/apt/lists/*

# Install Tesseract
RUN apt-get update && apt-get install -y \
  tesseract-ocr \
  tesseract-ocr-eng \
  libtesseract-dev \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Add user and switch to it
RUN groupadd -r appuser && useradd -r -g appuser -d /app -s /bin/bash appuser
RUN chown appuser:appuser /app

# Create output directories with correct permissions
RUN mkdir -p /app/ocr_output/png /app/ocr_output/markdown \
  && chown -R appuser:appuser /app/ocr_output

USER appuser

# Copy the requirements file and install Python dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . /app

# Command to run the script
CMD ["python", "ocrpy.py"]

