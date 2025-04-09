#!/usr/bin/bash

# === Descrizione ===
set -e  # Interrompe lo script se un comando fallisce

# === Configurazioni ===
AWS_REGION="eu-central-1"
AWS_ACCOUNT_ID="932362285414"
ECR_REPO="agent-ai-base"
LOCAL_IMAGE_NAME="quest-it/agent-ai-base"

# === Parametri ===
PLATFORM="$1"

# === Valori di default ===
PLATFORM="${PLATFORM:-cpu}"

# === Validazione piattaforma ===
if [[ "$PLATFORM" != "cpu" && "$PLATFORM" != "gpu" ]]; then
  echo "Errore: la piattaforma deve essere 'cpu', 'gpu'"
  exit 1
fi

TAG="${PLATFORM}"
DOCKERFILE="Dockerfile"

if [[ "$PLATFORM" == "gpu" ]]; then
  TAG="gpu"
  DOCKERFILE="Dockerfile.gpu"
fi

if [[ "$PLATFORM" == "cpu" ]]; then
  TAG="cpu"
  DOCKERFILE="Dockerfile.cpu"
fi

# === Avvio deploy ===
echo "Deploying Docker image: ${ECR_REPO}:${TAG}"

# === Login ad AWS ECR ===
echo "Logging in to AWS ECR..."
aws ecr get-login-password --region ${AWS_REGION} | \
docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# === Build ===
echo "Building Docker image..."
docker buildx build --build-arg PLATFORM="${PLATFORM}" --platform linux/amd64 -f Dockerfile -t ${LOCAL_IMAGE_NAME}:"${TAG}" .

# === Tag per ECR ===
echo "Tagging image..."
docker tag ${LOCAL_IMAGE_NAME}:"${TAG}" ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:"${TAG}"

# === Push ===
echo "Pushing image to AWS ECR..."
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:"${TAG}"

echo "Image pushed successfully: ${ECR_REPO}:${TAG}"
