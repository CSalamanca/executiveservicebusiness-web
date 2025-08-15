#!/bin/bash
# Script de utilidades para mantenimiento del servidor

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_menu() {
    echo -e "${BLUE}🛠️  Executive Service Business - Utilidades${NC}"
    echo "============================================="
    echo ""
    echo "1) 📊 Estado del sistema"
    echo "2) 🔍 Verificar dominios DuckDNS"
    echo "3) 🔄 Reiniciar servicios"
    echo "4) 📝 Ver logs en tiempo real"
    echo "5) 🧹 Limpiar logs antiguos"
    echo "6) 💽 Información de almacenamiento"
    echo "7) 🌐 Test de conectividad"
    echo "8) 🔧 Actualizar sistema"
    echo "9) 🚪 SSH directo al servidor"
    echo "0) ❌ Salir"
    echo ""
}

system_status() {
    echo -e "${BLUE}📊 Estado del sistema${NC}"
    echo "====================="
    
    ansible esb_vms -m shell -a "uptime"
    echo ""
    
    ansible esb_vms -m shell -a "free -h"
    echo ""
    
    ansible esb_vms -m shell -a "df -h /"
    echo ""
    
    echo "Estado de servicios:"
    ansible esb_vms -m shell -a "systemctl is-active nginx" --one-line
}

check_domains() {
    echo -e "${BLUE}🔍 Verificando dominios DuckDNS${NC}"
    echo "================================="
    
    echo "Resolviendo dominios..."
    for domain in "executiveservicebusiness.duckdns.org" "eyenga.duckdns.org"; do
        echo -n "• $domain: "
        ip=$(dig +short $domain @8.8.8.8)
        if [ "$ip" = "143.47.38.168" ]; then
            echo -e "${GREEN}✅ OK ($ip)${NC}"
        elif [ -n "$ip" ]; then
            echo -e "${YELLOW}⚠️  Apunta a $ip (esperado: 143.47.38.168)${NC}"
        else
            echo -e "${RED}❌ No resuelve${NC}"
        fi
    done
    
    echo ""
    echo "Última actualización DuckDNS:"
    ansible esb_vms -m shell -a "tail -2 /var/log/duckdns.log" 2>/dev/null || echo "No hay logs"
}

restart_services() {
    echo -e "${BLUE}🔄 Reiniciando servicios${NC}"
    echo "========================="
    
    echo "Reiniciando Nginx..."
    ansible esb_vms -m service -a "name=nginx state=restarted" --become
    
    echo -e "${GREEN}✅ Servicios reiniciados${NC}"
}

watch_logs() {
    echo -e "${BLUE}📝 Logs en tiempo real${NC}"
    echo "======================"
    echo "Presiona Ctrl+C para salir"
    echo ""
    
    # SSH directo para tail -f
    ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo tail -f /var/log/nginx/access.log /var/log/nginx/error.log /var/log/duckdns.log"
}

clean_logs() {
    echo -e "${BLUE}🧹 Limpiando logs antiguos${NC}"
    echo "=========================="
    
    echo "Rotando logs de Nginx..."
    ansible esb_vms -m shell -a "sudo logrotate -f /etc/logrotate.d/nginx" --become
    
    echo "Limpiando logs de DuckDNS (manteniendo últimas 100 líneas)..."
    ansible esb_vms -m shell -a "tail -100 /var/log/duckdns.log > /tmp/duckdns_temp && mv /tmp/duckdns_temp /var/log/duckdns.log" --become
    
    echo -e "${GREEN}✅ Logs limpiados${NC}"
}

storage_info() {
    echo -e "${BLUE}💽 Información de almacenamiento${NC}"
    echo "================================="
    
    ansible esb_vms -m shell -a "df -h"
    echo ""
    
    echo "Uso por directorio:"
    ansible esb_vms -m shell -a "du -sh /home/ubuntu/executiveservicebusiness-web 2>/dev/null || echo 'No hay aplicaciones desplegadas'"
    echo ""
    
    ansible esb_vms -m shell -a "du -sh /var/log/nginx/* 2>/dev/null || echo 'No hay logs de Nginx'"
    echo ""
    
    ansible esb_vms -m shell -a "du -sh /var/log/pm2/* 2>/dev/null || echo 'No hay logs de PM2'"
}

connectivity_test() {
    echo -e "${BLUE}🌐 Test de conectividad${NC}"
    echo "======================="
    
    echo "Ping al servidor:"
    if ping -c 3 143.47.38.168 > /dev/null 2>&1; then
        echo -e "${GREEN}✅ Ping OK${NC}"
    else
        echo -e "${RED}❌ Ping FAIL${NC}"
    fi
    
    echo ""
    echo "Test HTTP/HTTPS:"
    for url in "https://143.47.38.168" "https://executiveservicebusiness.duckdns.org" "https://eyenga.duckdns.org"; do
        echo -n "• $url: "
        if curl -s -k -o /dev/null -w "%{http_code}" --connect-timeout 5 "$url" | grep -q "200\|301\|302"; then
            echo -e "${GREEN}✅ OK${NC}"
        else
            echo -e "${RED}❌ FAIL${NC}"
        fi
    done
    
    echo ""
    echo "Test aplicaciones React (interno):"
    for port in "3000" "3001"; do
        echo -n "• Puerto $port: "
        if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "http://127.0.0.1:$port" | grep -q "200"; then
            echo -e "${GREEN}✅ OK${NC}"
        else
            echo -e "${RED}❌ FAIL${NC}"
        fi
    done
}

update_system() {
    echo -e "${BLUE}🔧 Actualizando sistema${NC}"
    echo "======================="
    
    echo "Actualizando paquetes..."
    ansible esb_vms -m apt -a "update_cache=yes upgrade=yes" --become
    
    echo -e "${GREEN}✅ Sistema actualizado${NC}"
}

ssh_direct() {
    echo -e "${BLUE}🚪 Conectando directamente al servidor...${NC}"
    ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168
}

# Menú principal
while true; do
    show_menu
    read -p "Selecciona una opción (0-9): " choice
    
    case $choice in
        1) system_status ;;
        2) check_domains ;;
        3) restart_services ;;
        4) watch_logs ;;
        5) clean_logs ;;
        6) storage_info ;;
        7) connectivity_test ;;
        8) update_system ;;
        9) ssh_direct ;;
        0) echo -e "${GREEN}¡Hasta luego!${NC}"; exit 0 ;;
        *) echo -e "${RED}Opción inválida${NC}" ;;
    esac
    
    echo ""
    read -p "Presiona Enter para continuar..."
    clear
done
