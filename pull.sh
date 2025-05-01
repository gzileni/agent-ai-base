#!/bin/bash

# === Descrizione ===
set -e  # Interrompe lo script se un comando fallisce

# === Configurazioni ===
AWS_REGION="eu-central-1"
AWS_ACCOUNT_ID="932362285414"
ECR_REPO="agent-ai-base"

# === Parametri ===
PLATFORM="$1"

# === Valori di default ===
PLATFORM="${PLATFORM:-cpu}"

# === Validazione piattaforma ===
if [[ "$PLATFORM" != "cpu" && "$PLATFORM" != "gpu" ]]; then
  echo "Errore: la piattaforma deve essere 'cpu', 'gpu'"
  exit 1
fi

AGENT_BASE_IMAGE=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com:${PLATFORM}

# === Avvio deploy ===
echo "Pulling Docker image: ${AGENT_BASE_IMAGE}"

# === Login ad AWS ECR ===
echo "Logging in to AWS ECR..."
aws ecr get-login-password --region ${AWS_REGION} | \
docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# === Build ===
echo "Building Docker image..."
docker pull ${AGENT_BASE_IMAGE}

echo "Image pulled successfully: ${AGENT_BASE_IMAGE}"
