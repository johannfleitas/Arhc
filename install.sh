#!/bin/bash

# Instalar los paquetes necesarios
echo "Actualizando el sistema e instalando paquetes necesarios..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm hyprland waybar alacritty starship

# Array de carpetas/configs para copiar a ~/.config/
CONFIG_DIRS=("hypr" "waybar" "kitty")

# Arrays para carpetas/archivos a copiar/directorio de destino absoluto
EXTRA_SRC=( "etc" )           # Añade aquí el nombre como está en tu repo
EXTRA_DST=( "/etc" )          # Destino absoluto correspondiente

# Carpeta base (actual)
BASE_DIR="$(pwd)"
CONFIG_DEST="$HOME/.config"

# Copiar a ~/.config/
for dir in "${CONFIG_DIRS[@]}"; do
    SRC="$BASE_DIR/$dir"
    DST="$CONFIG_DEST/$dir"
    if [ -e "$SRC" ]; then
        mkdir -p "$DST"
        cp -ru "$SRC/"* "$DST/"
        echo "Copiado: $SRC --> $DST"
    else
        echo "No existe $SRC, omitiendo..."
    fi
done

# Copiar extras (requiere sudo generalmente)
for i in "${!EXTRA_SRC[@]}"; do
    SRC="$BASE_DIR/${EXTRA_SRC[i]}"
    DST="${EXTRA_DST[i]}"
    if [ -e "$SRC" ]; then
        echo "Copiando $SRC --> $DST (requiere permisos de superusuario)"
        sudo cp -ru "$SRC/"* "$DST/"
        echo "Copiado: $SRC --> $DST"
    else
        echo "No existe $SRC, omitiendo..."
    fi
done

echo "Instalación y copia de configuraciones completada."