#!/bin/bash

# Script para remover hosts locales del sistema
# Ejecutar con permisos de administrador: sudo ./remove-hosts.sh

HOSTS_FILE="/etc/hosts"
CORPORATIVA_DOMAIN="corporativa.local"
EYENGA_DOMAIN="eyenga.local"

echo "Removiendo dominios locales..."

# Backup del archivo hosts
cp $HOSTS_FILE $HOSTS_FILE.backup.$(date +%Y%m%d_%H%M%S)

# Eliminar entradas
sed -i '' "/$CORPORATIVA_DOMAIN/d" $HOSTS_FILE
sed -i '' "/$EYENGA_DOMAIN/d" $HOSTS_FILE

echo "✅ Dominios removidos del archivo hosts"
echo "   - $CORPORATIVA_DOMAIN"
echo "   - $EYENGA_DOMAIN"
