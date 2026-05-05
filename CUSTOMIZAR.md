# Manual de Customizacao do Open WebUI

Este guia resume a preparacao do ambiente, execucao do frontend/backend e os pontos principais de customizacao usados neste fork.

## 1. Preparar Ambiente

Crie e ative o ambiente Python:

```bash
conda create -n openwebui-v0.9.2 python=3.11
conda activate openwebui-v0.9.2
```

Instale a versao do Node recomendada pelo projeto:

```bash
nvm install 22
nvm use 22
```

## 2. Frontend

Copie o arquivo de exemplo de variaveis de ambiente:

```bash
cp -RPp .env.example .env
```

Instale as dependencias:

```bash
npm install --force
```

Se precisar instalar ou atualizar apenas o `dompurify`:

```bash
npm install dompurify
```

Para rodar em modo desenvolvimento:

```bash
npm run dev
```

Para gerar o build final:

```bash
npm run build
```

O `npm run dev` nao gera a pasta `build/`; ele sobe o servidor de desenvolvimento do Vite. A pasta `build/` so e gerada com `npm run build`.

## 3. Backend

Entre na pasta do backend:

```bash
cd backend
```

Instale as dependencias Python:

```bash
pip install -r requirements.txt -U
```

Execute o backend em modo desenvolvimento:

```bash
sh dev.sh
```

## 4. Customizacoes no Codigo

### Remover Aba "About"

Arquivo:

```text
src/lib/components/chat/SettingsModal.svelte
```

Comentar ou remover o bloco relacionado a:

```svelte
{:else if tabId === 'about'}
```

### Ajustar Imagem no Sidebar

Arquivo:

```text
src/lib/components/layout/Sidebar.svelte
```

Remover o atributo:

```html
crossorigin="anonymous"
```

na imagem correspondente ao logo/favicon do sidebar.

### Arquivos Estaticos do Backend

Arquivo:

```text
backend/open_webui/config.py
```

O backend usa:

```py
STATIC_DIR = Path(os.getenv('STATIC_DIR', OPEN_WEBUI_DIR / 'static')).resolve()
```

Por padrao, esse diretorio aponta para:

```text
backend/open_webui/static
```

Durante a inicializacao do backend, os arquivos de:

```text
build/static/
```

sao copiados para:

```text
backend/open_webui/static/
```

## 5. Customizar Imagens

Para alterar as imagens que entram no build, edite os arquivos em:

```text
static/static/
```

Principais arquivos:

```text
static/static/splash.png       -> build/static/splash.png
static/static/splash-dark.png  -> build/static/splash-dark.png
static/static/favicon.png      -> build/static/favicon.png
static/static/favicon.svg      -> build/static/favicon.svg
static/static/logo.png         -> build/static/logo.png
```

Depois de alterar as imagens, gere o build:

```bash
npm run build
```

Ao iniciar o backend, ele copia os arquivos de `build/static/` para `backend/open_webui/static/`.

## 6. Erro de Memoria no Build

Se o build falhar com erro parecido com:

```text
FATAL ERROR: Reached heap limit Allocation failed - JavaScript heap out of memory
```

execute aumentando a memoria disponivel para o Node:

```bash
NODE_OPTIONS="--max-old-space-size=8192" npm run build
```

Se a maquina tiver menos memoria disponivel, tente:

```bash
NODE_OPTIONS="--max-old-space-size=4096" npm run build
```

## 7. Fluxo Recomendado Apos Customizar Imagens

```bash
npm run build
cd backend
sh dev.sh
```

Em desenvolvimento, use `npm run dev` para trabalhar no frontend com hot reload. Para validar imagens finais servidas pelo backend, use `npm run build` antes de iniciar o backend.
