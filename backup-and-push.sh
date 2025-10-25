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
PACMAN_CONF_ORIGEN="/etc/pacman.conf"
HYPRLAND_CONF_ORIGEN="$HOME/.config/hypr/hyprland.conf"
KITTY_CONF_ORIGEN="$HOME/.config/kitty/kitty.conf"

DESTINO_ETC="configs/etc"
DESTINO_HYPRLAND="configs/hyprland"
DESTINO_KITTY="configs/kitty"

# Crear directorios de destino si no existen
mkdir -p "$DESTINO_ETC"
mkdir -p "$DESTINO_HYPRLAND"
mkdir -p "$DESTINO_KITTY"

# Copiar los archivos de configuración mostrando qué se está haciendo
echo "Copiando pacman.conf..."
cp -v "$PACMAN_CONF_ORIGEN" "$DESTINO_ETC/"
echo "Copiando hyprland.conf..."
cp -v "$HYPRLAND_CONF_ORIGEN" "$DESTINO_HYPRLAND/"
echo "Copiando kitty.conf..."
cp -v "$KITTY_CONF_ORIGEN" "$DESTINO_KITTY/"

echo -e "\n${GREEN}¡Copia de seguridad local completada!${NC}"

# --- SECCIÓN DE GIT ---
# Comprobar si estamos en un repositorio de Git
if [ -d ".git" ]; then
    echo -e "\n${GREEN}--- Subiendo cambios a GitHub ---${NC}"
    # Añadir todos los cambios al área de preparación de Git
    git add .
    # Comprobar si hay cambios para commitear
    if git diff --staged --quiet; then
        echo "No hay cambios que subir. ¡Tu repositorio ya está actualizado!"
    else
        # Crear un commit con un mensaje que incluye la fecha y hora
        COMMIT_MESSAGE="Actualización de configuraciones $(date +'%Y-%m-%d %H:%M:%S')"
        git commit -m "$COMMIT_MESSAGE"
        # Subir los cambios a la rama principal del repositorio remoto
        git push
        echo -e "\n${GREEN}¡Cambios subidos a GitHub exitosamente!${NC}"
    fi
else
    echo -e "\n${YELLOW}AVISO: Esta carpeta no es un repositorio de Git.${NC}"
    echo "Para poder subir los cambios, primero inicializa Git y conéctalo a GitHub."
fi