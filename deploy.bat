@echo off
setlocal enabledelayedexpansion

REM === Configurazioni ===
set "AWS_REGION=eu-central-1"
set "AWS_ACCOUNT_ID=932362285414"
set "ECR_REPO=agent-ai-base"
set "LOCAL_IMAGE_NAME=quest-it/agent-ai-base"

REM === Parametri ===
set "PLATFORM=%1"

REM === Valore di default ===
if "%PLATFORM%"=="" (
    set "PLATFORM=cpu"
)

REM === Validazione piattaforma ===
if /i not "%PLATFORM%"=="cpu" if /i not "%PLATFORM%"=="gpu" (
    echo Errore: la piattaforma deve essere "cpu" oppure "gpu"
    exit /b 1
)

set "TAG=%PLATFORM%"

if /i "%PLATFORM%"=="gpu" (
    set "DOCKERFILE=Dockerfile.gpu"
) else (
    set "DOCKERFILE=Dockerfile.cpu"
)

REM === Avvio deploy ===
echo Deploying Docker image: %ECR_REPO%:%TAG%

REM === Login ad AWS ECR ===
echo Logging in to AWS ECR...
FOR /F "usebackq delims=" %%i IN (`aws ecr get-login-password --region %AWS_REGION%`) DO (
    echo %%i | docker login --username AWS --password-stdin %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com
)

REM === Build ===
echo Building Docker image...
docker buildx build --build-arg PLATFORM=%PLATFORM% --platform linux/amd64 -f %DOCKERFILE% -t %LOCAL_IMAGE_NAME%:%TAG% .

REM === Tag per ECR ===
echo Tagging image...
docker tag %LOCAL_IMAGE_NAME%:%TAG% %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPO%:%TAG%

REM === Push ===
echo Pushing image to AWS ECR...
docker push %AWS_ACCOUNT_ID%.dkr.ecr.%AWS_REGION%.amazonaws.com/%ECR_REPO%:%TAG%

echo Image pushed successfully: %ECR_REPO%:%TAG%
