#!/bin/bash

# Script para configurar hosts locales en el sistema
# Ejecutar con permisos de administrador: sudo ./setup-hosts.sh

HOSTS_FILE="/etc/hosts"
CORPORATIVA_DOMAIN="corporativa.local"
EYENGA_DOMAIN="eyenga.local"

echo "Configurando dominios locales..."

# Backup del archivo hosts
cp $HOSTS_FILE $HOSTS_FILE.backup.$(date +%Y%m%d_%H%M%S)

# Eliminar entradas existentes si las hay
sed -i '' "/$CORPORATIVA_DOMAIN/d" $HOSTS_FILE
sed -i '' "/$EYENGA_DOMAIN/d" $HOSTS_FILE

# Agregar nuevas entradas
echo "127.0.0.1    $CORPORATIVA_DOMAIN" >> $HOSTS_FILE
echo "127.0.0.1    $EYENGA_DOMAIN" >> $HOSTS_FILE

echo "✅ Dominios configurados:"
echo "   - $CORPORATIVA_DOMAIN -> 127.0.0.1"
echo "   - $EYENGA_DOMAIN -> 127.0.0.1"
echo ""
echo "💡 Para usar estos dominios:"
echo "   - Corporativa: http://$CORPORATIVA_DOMAIN:3000"
echo "   - Eyenga: http://$EYENGA_DOMAIN:3001"
echo ""
echo "🔄 Para revertir los cambios, ejecuta: sudo ./remove-hosts.sh"
