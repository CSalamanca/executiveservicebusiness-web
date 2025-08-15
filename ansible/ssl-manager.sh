#!/bin/bash
# Script de gestión SSL/TLS para Executive Service Business
# Generado automáticamente por Ansible

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_menu() {
    echo -e "${BLUE}🔒 Gestión SSL/TLS - Executive Service Business${NC}"
    echo "================================================"
    echo ""
    echo "1) 📊 Estado de certificados"
    echo "2) 🔄 Estado de renovación automática"
    echo "3) 🧪 Test de renovación (dry-run)"
    echo "4) ⚡ Forzar renovación ahora"
    echo "5) 📝 Ver logs de renovación"
    echo "6) 🔍 Verificar conectividad SSL"
    echo "7) 📅 Próximas renovaciones"
    echo "8) 🛠️ Reiniciar servicios SSL"
    echo "9) 📋 Información de certificados"
    echo "0) ❌ Salir"
    echo ""
}

check_certificates() {
    echo -e "${BLUE}📊 Estado de certificados${NC}"
    echo "========================="
    
    ansible esb_vms -m shell -a "/usr/local/bin/check-ssl-certs.sh" 2>/dev/null || {
        echo "Ejecutando verificación directa..."
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "/usr/local/bin/check-ssl-certs.sh"
    }
}

renewal_status() {
    echo -e "${BLUE}🔄 Estado de renovación automática${NC}"
    echo "=================================="
    
    echo "Estado del timer systemd:"
    ansible esb_vms -m shell -a "systemctl status certbot-renewal.timer --no-pager" 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "systemctl status certbot-renewal.timer --no-pager"
    }
    
    echo ""
    echo "Próximas ejecuciones:"
    ansible esb_vms -m shell -a "systemctl list-timers certbot-renewal.timer" 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "systemctl list-timers certbot-renewal.timer"
    }
    
    echo ""
    echo "Cron jobs configurados:"
    ansible esb_vms -m shell -a "crontab -l | grep -i cert" 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo crontab -l | grep -i cert"
    }
}

test_renewal() {
    echo -e "${BLUE}🧪 Test de renovación (dry-run)${NC}"
    echo "==============================="
    
    echo "Ejecutando test de renovación..."
    ansible esb_vms -m shell -a "certbot renew --dry-run" --become 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo certbot renew --dry-run"
    }
}

force_renewal() {
    echo -e "${YELLOW}⚡ Forzar renovación ahora${NC}"
    echo "========================"
    echo -e "${RED}⚠️  ADVERTENCIA: Esto forzará la renovación de certificados${NC}"
    read -p "¿Continuar? (y/N): " confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        echo "Forzando renovación..."
        ansible esb_vms -m shell -a "certbot renew --force-renewal --post-hook 'systemctl reload nginx'" --become 2>/dev/null || {
            ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo certbot renew --force-renewal --post-hook 'systemctl reload nginx'"
        }
        echo -e "${GREEN}✅ Renovación completada${NC}"
    else
        echo "Cancelado"
    fi
}

view_logs() {
    echo -e "${BLUE}📝 Logs de renovación${NC}"
    echo "===================="
    
    echo "Logs de renovación automática:"
    ansible esb_vms -m shell -a "tail -20 /var/log/certbot-renewal.log 2>/dev/null || echo 'No hay logs de renovación'" 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo tail -20 /var/log/certbot-renewal.log 2>/dev/null || echo 'No hay logs de renovación'"
    }
    
    echo ""
    echo "Logs de verificación SSL:"
    ansible esb_vms -m shell -a "tail -10 /var/log/ssl-check.log 2>/dev/null || echo 'No hay logs de verificación'" 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo tail -10 /var/log/ssl-check.log 2>/dev/null || echo 'No hay logs de verificación'"
    }
    
    echo ""
    echo "Logs de Certbot:"
    ansible esb_vms -m shell -a "tail -10 /var/log/letsencrypt/letsencrypt.log 2>/dev/null || echo 'No hay logs de Certbot'" 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo tail -10 /var/log/letsencrypt/letsencrypt.log 2>/dev/null || echo 'No hay logs de Certbot'"
    }
}

test_ssl_connectivity() {
    echo -e "${BLUE}🔍 Verificar conectividad SSL${NC}"
    echo "============================="
    
    domains=("executiveservicebusiness.duckdns.org" "eyenga.duckdns.org")
    
    for domain in "${domains[@]}"; do
        echo -n "• $domain: "
        if curl -s -I "https://$domain" > /dev/null 2>&1; then
            echo -e "${GREEN}✅ OK${NC}"
            
            # Verificar detalles del certificado
            expiry=$(echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null | openssl x509 -enddate -noout | cut -d= -f2)
            echo "  Expira: $expiry"
        else
            echo -e "${RED}❌ Error${NC}"
        fi
    done
    
    echo ""
    echo "Test de redirección HTTP → HTTPS:"
    for domain in "${domains[@]}"; do
        echo -n "• $domain: "
        if curl -s -I "http://$domain" | grep -q "301\|302"; then
            echo -e "${GREEN}✅ Redirige correctamente${NC}"
        else
            echo -e "${YELLOW}⚠️  Sin redirección${NC}"
        fi
    done
}

next_renewals() {
    echo -e "${BLUE}📅 Próximas renovaciones${NC}"
    echo "========================"
    
    echo "Información de certificados:"
    ansible esb_vms -m shell -a "certbot certificates" --become 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo certbot certificates"
    }
    
    echo ""
    echo "Próximas ejecuciones del timer:"
    ansible esb_vms -m shell -a "systemctl list-timers | grep certbot" 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "systemctl list-timers | grep certbot"
    }
}

restart_ssl_services() {
    echo -e "${BLUE}🛠️ Reiniciar servicios SSL${NC}"
    echo "=========================="
    
    echo "Reiniciando timer de renovación..."
    ansible esb_vms -m systemd -a "name=certbot-renewal.timer state=restarted" --become 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo systemctl restart certbot-renewal.timer"
    }
    
    echo "Recargando Nginx..."
    ansible esb_vms -m systemd -a "name=nginx state=reloaded" --become 2>/dev/null || {
        ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo systemctl reload nginx"
    }
    
    echo -e "${GREEN}✅ Servicios reiniciados${NC}"
}

certificate_info() {
    echo -e "${BLUE}📋 Información detallada de certificados${NC}"
    echo "========================================"
    
    domains=("executiveservicebusiness.duckdns.org" "eyenga.duckdns.org")
    
    for domain in "${domains[@]}"; do
        echo ""
        echo "=== $domain ==="
        
        # Información del certificado
        if echo | openssl s_client -connect "$domain:443" -servername "$domain" 2>/dev/null | openssl x509 -text -noout 2>/dev/null; then
            echo "Certificado válido"
        else
            echo -e "${RED}❌ Error al obtener información del certificado${NC}"
        fi
        
        # Archivos locales
        echo ""
        echo "Archivos en el servidor:"
        ansible esb_vms -m shell -a "ls -la /etc/letsencrypt/live/$domain/ 2>/dev/null || echo 'Certificados no encontrados'" 2>/dev/null || {
            ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "sudo ls -la /etc/letsencrypt/live/$domain/ 2>/dev/null || echo 'Certificados no encontrados'"
        }
    done
}

# Menú principal
while true; do
    show_menu
    read -p "Selecciona una opción (0-9): " choice
    
    case $choice in
        1) check_certificates ;;
        2) renewal_status ;;
        3) test_renewal ;;
        4) force_renewal ;;
        5) view_logs ;;
        6) test_ssl_connectivity ;;
        7) next_renewals ;;
        8) restart_ssl_services ;;
        9) certificate_info ;;
        0) echo -e "${GREEN}¡Hasta luego!${NC}"; exit 0 ;;
        *) echo -e "${RED}Opción inválida${NC}" ;;
    esac
    
    echo ""
    read -p "Presiona Enter para continuar..."
    clear
done
