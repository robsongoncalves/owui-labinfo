# Enviar Imagem para o Docker Hub

Este guia documenta os comandos usados para gerar, testar e enviar a imagem customizada do Open WebUI para o Docker Hub.

## 1. Login no Docker Hub

```bash
docker login
```

Confira o usuario logado:

```bash
docker info | grep Username
```

## 2. Conferir Estado do Projeto

```bash
git status
```

## 3. Definir Nome da Imagem

```bash
export DOCKER_ID="robsongoncalves"
export IMAGE_NAME="owui-custom"
export IMAGE_TAG="0.9.2"
```

A imagem sera publicada como:

```text
robsongoncalves/owui-custom:0.9.2
robsongoncalves/owui-custom:latest
```

## 4. Gerar a Imagem

```bash
docker build \
  --build-arg BUILD_HASH="$(git rev-parse --short HEAD)" \
  -t "$DOCKER_ID/$IMAGE_NAME:$IMAGE_TAG" \
  -t "$DOCKER_ID/$IMAGE_NAME:latest" \
  .
```

## 5. Testar Localmente

Suba um container de teste:

```bash
docker run --rm -d \
  --name open-webui-test \
  -p 3000:8080 \
  -v open-webui-test:/app/backend/data \
  -e WEBUI_SECRET_KEY="troque-esta-chave" \
  "$DOCKER_ID/$IMAGE_NAME:$IMAGE_TAG"
```

Acesse no navegador:

```text
http://localhost:3000
```

Pare o container de teste:

```bash
docker stop open-webui-test
```

## 6. Enviar para o Docker Hub

```bash
docker push "$DOCKER_ID/$IMAGE_NAME:$IMAGE_TAG"
docker push "$DOCKER_ID/$IMAGE_NAME:latest"
```

## 7. Usar a Imagem Publicada

Depois do push, a imagem pode ser usada com:

```bash
docker run -d \
  --name open-webui \
  -p 3000:8080 \
  -v open-webui:/app/backend/data \
  -e WEBUI_SECRET_KEY="troque-esta-chave" \
  robsongoncalves/owui-custom:0.9.2
```

Ou usando a tag `latest`:

```bash
docker run -d \
  --name open-webui \
  -p 3000:8080 \
  -v open-webui:/app/backend/data \
  -e WEBUI_SECRET_KEY="troque-esta-chave" \
  robsongoncalves/owui-custom:latest
```

## 8. Usar com Docker Compose Customizado

Como a imagem esta em um repositorio privado, faca login no servidor antes de subir:

```bash
docker login
```

Subir os containers:

```bash
docker compose -f docker-compose-custom.yaml up -d
```

Derrubar os containers:

```bash
docker compose -f docker-compose-custom.yaml down
```

Derrubar os containers removendo tambem os volumes persistentes:

```bash
docker compose -f docker-compose-custom.yaml down -v
```

Use `down -v` com cuidado, pois ele remove os volumes `open-webui` e `ollama`.
