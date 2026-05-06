#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
	echo "Uso: $0 <image_dir_origem> <image_dir_destino> <container_id>"
	echo
	echo "Exemplo:"
	echo "$0 /mnt/c/Users/robso/OneDrive/Imagens/openwebui/inteligenciomica /app/backend/open_webui/static open-webui"
	exit 1
fi

image_dir_origem="${1%/}"
image_dir_destino="${2%/}"
container_id="$3"

images=(
	"favicon-96x96.png"
	"favicon-dark.png"
	"favicon.png"
	"favicon.svg"
	"logo.png"
	"splash-dark.png"
	"splash.png"
)

if [ ! -d "$image_dir_origem" ]; then
	echo "Diretorio de origem nao encontrado: $image_dir_origem"
	exit 1
fi

if ! docker inspect "$container_id" >/dev/null 2>&1; then
	echo "Container nao encontrado: $container_id"
	exit 1
fi

for image in "${images[@]}"; do
	source_path="$image_dir_origem/$image"

	if [ ! -f "$source_path" ]; then
		echo "Arquivo nao encontrado, pulando: $source_path"
		continue
	fi

	echo "Copiando $source_path -> $container_id:$image_dir_destino/$image"
	docker cp "$source_path" "$container_id:$image_dir_destino/$image"
done

echo
echo "Arquivos no destino:"
docker exec "$container_id" ls -lah \
	"$image_dir_destino/favicon-96x96.png" \
	"$image_dir_destino/favicon-dark.png" \
	"$image_dir_destino/favicon.png" \
	"$image_dir_destino/favicon.svg" \
	"$image_dir_destino/logo.png" \
	"$image_dir_destino/splash-dark.png" \
	"$image_dir_destino/splash.png"
