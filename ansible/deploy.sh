#!/bin/bash
# Script principal para desplegar Executive Service Business con Ansible

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Executive Service Business - Deployment con Ansible${NC}"
echo "=================================================="

# Verificar que Ansible esté instalado
if ! command -v ansible-playbook &> /dev/null; then
    echo -e "${RED}❌ Error: Ansible no está instalado${NC}"
    echo "Instala Ansible con: sudo apt install ansible"
    exit 1
fi

# Verificar que la clave SSH existe
if [ ! -f ~/.ssh/oracle_key ]; then
    echo -e "${RED}❌ Error: Clave SSH no encontrada en ~/.ssh/oracle_key${NC}"
    echo "Genera la clave con: ssh-keygen -t rsa -b 4096 -f ~/.ssh/oracle_key"
    exit 1
fi

# Verificar conectividad al servidor
echo -e "${YELLOW}🔍 Verificando conectividad al servidor...${NC}"
if ! ansible esb_vms -m ping > /dev/null 2>&1; then
    echo -e "${RED}❌ Error: No se puede conectar al servidor${NC}"
    echo "Verifica:"
    echo "1. Que el servidor esté encendido"
    echo "2. Que la IP en inventory/hosts.yml sea correcta"
    echo "3. Que la clave SSH sea correcta"
    exit 1
fi

echo -e "${GREEN}✅ Conectividad OK${NC}"

# Menú de opciones
echo ""
echo "Selecciona una opción:"
echo "1) 🏗️  Deployment completo (DuckDNS + Nginx + Apps)"
echo "2) 🔄 Solo actualizar aplicaciones"
echo "3) 🔒 Configurar SSL/HTTPS"
echo "4) 🛡️  Gestión avanzada SSL"
echo "5) 🧪 Solo verificar conectividad"
echo "6) 📋 Ver logs del servidor"
echo ""
read -p "Opción (1-6): " choice

case $choice in
    1)
        echo -e "${BLUE}🏗️  Iniciando deployment completo...${NC}"
        ansible-playbook -i inventory/hosts.yml playbooks/deploy-apps.yml -v
        ;;
    2)
        echo -e "${BLUE}🔄 Actualizando aplicaciones...${NC}"
        ansible-playbook -i inventory/hosts.yml playbooks/update-apps.yml -v
        ;;
    3)
        echo -e "${BLUE}🔒 Configurando SSL...${NC}"
        echo -e "${YELLOW}⚠️  Asegúrate de que los dominios apunten al servidor antes de continuar${NC}"
        read -p "¿Continuar? (y/N): " confirm
        if [[ $confirm =~ ^[Yy]$ ]]; then
            ansible-playbook -i inventory/hosts.yml playbooks/setup-ssl.yml -v
        else
            echo "Cancelado"
        fi
        ;;
    4)
        echo -e "${BLUE}🛡️  Gestión avanzada SSL...${NC}"
        ./ssl-manager.sh
        ;;
    5)
        echo -e "${BLUE}🧪 Verificando conectividad...${NC}"
        ansible esb_vms -m ping
        ansible esb_vms -m setup -a "filter=ansible_default_ipv4"
        ;;
    6)
        echo -e "${BLUE}📋 Logs del servidor...${NC}"
        echo "1. Logs de DuckDNS:"
        ansible esb_vms -m shell -a "tail -20 /var/log/duckdns.log" || echo "No hay logs de DuckDNS"
        echo ""
        echo "2. Logs de Nginx (errores):"
        ansible esb_vms -m shell -a "tail -10 /var/log/nginx/error.log" || echo "No hay errores de Nginx"
        echo ""
        echo "3. Estado de servicios:"
        ansible esb_vms -m shell -a "systemctl status nginx --no-pager -l"
        ;;
    *)
        echo -e "${RED}Opción inválida${NC}"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✅ Operación completada${NC}"
echo ""
echo "🌐 URLs de acceso:"
echo "   • https://executiveservicebusiness.duckdns.org"
echo "   • https://eyenga.duckdns.org"
echo "   • https://143.47.38.168 (requiere SSL)"
