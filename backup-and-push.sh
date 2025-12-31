#!/bin/bash

# -----------------------------------------------------------------------------
# Script para hacer una copia de seguridad de las configuraciones locales
# y subirlas a un repositorio de GitHub.
# -----------------------------------------------------------------------------

# Salir inmediatamente si un comando falla
set -e

# --- Colores para la salida ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}--- Iniciando copia de seguridad de configuraciones ---${NC}"

#Rutas de origen de mis config en hyperland
CONFIGS=(
    "/etc/pacman.conf:configs/etc"
    "$HOME/.config/hypr/hyprland.conf:configs/hyprland"
    "$HOME/.config/hypr/hyprpaper.conf:configs/hyprland"
    "$HOME/.config/kitty/kitty.conf:configs/kitty"
    "$HOME/.config/waybar/config.jsonc:configs/waybar"
    "$HOME/.config/waybar/style.css:configs/waybar"
    "$HOME/.config/eww/eww.scss:configs/eww"
    "$HOME/.config/eww/eww.yuck:configs/eww"
    "$HOME/.config/alacritty/alacritty.toml:configs/alacritty"
    "$HOME/.config/rofi/config.rasi:configs/rofi"
)

# Crear directorios de destino si no existen
for entry in "${CONFIGS[@]}"; do
    ORIGEN="${entry%%:*}"   # Parte antes de los dos puntos
    DESTINO_DIR="${entry##*:}"  # Parte después de los dos puntos

    # Crear directorio si no existe (mkdir -p ya es seguro)
    mkdir -p "$DESTINO_DIR"

    # Copiar archivo
    echo "Copiando $(basename "$ORIGEN") a $DESTINO_DIR..."
    cp -v "$ORIGEN" "$DESTINO_DIR/"
done

echo -e "\n${GREEN}¡Copia de seguridad local completada!${NC}"

# --- SECCIÓN DE GIT ---
if [ -d ".git" ]; then
    echo -e "\n${GREEN}--- Subiendo cambios a GitHub ---${NC}"

    # Mostrar archivos que se van a añadir (verboso)
    echo -e "\nArchivos que se agregarán al commit:"
    git add -v . || { echo -e "${YELLOW}Error al agregar archivos.${NC}"; exit 1; }

    # Comprobar si hay cambios para commitear
    if git diff --staged --quiet; then
        echo -e "\n${YELLOW}No hay cambios que subir. ¡Tu repositorio ya está actualizado!${NC}"
    else
        # Crear un commit con fecha y hora
        COMMIT_MESSAGE="Actualización de configuraciones $(date +'%Y-%m-%d %H:%M:%S')"
        git commit -m "$COMMIT_MESSAGE"
        echo -e "${GREEN}Commit creado: $COMMIT_MESSAGE${NC}"

        # Subir cambios al repositorio remoto
        git push || { echo -e "${YELLOW}Error al hacer push. Revisa tu conexión o configuración de Git.${NC}"; exit 1; }
        echo -e "\n${GREEN}¡Cambios subidos a GitHub exitosamente!${NC}"
    fi
else
    echo -e "\n${YELLOW}AVISO: Esta carpeta no es un repositorio de Git.${NC}"
    echo "Para poder subir los cambios, primero inicializa Git y conéctalo a GitHub."
fi 