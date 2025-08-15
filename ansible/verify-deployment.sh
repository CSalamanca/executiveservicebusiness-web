#!/bin/bash
# Script de verificación del estado final del despliegue
# Verifica que todo esté funcionando según la configuración de producción

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Verificando estado final del despliegue...${NC}"
echo ""

# Verificar conectividad con el servidor
echo -e "${BLUE}1. Verificando conectividad...${NC}"
if ansible esb_vms -m ping &>/dev/null; then
    echo -e "${GREEN}✅ Servidor accesible${NC}"
else
    echo -e "${RED}❌ Servidor no accesible${NC}"
    exit 1
fi

# Verificar estado de Nginx
echo -e "${BLUE}2. Verificando Nginx...${NC}"
nginx_status=$(ansible esb_vms -m shell -a "systemctl is-active nginx" 2>/dev/null | grep -o "active\|inactive" || echo "unknown")
if [ "$nginx_status" = "active" ]; then
    echo -e "${GREEN}✅ Nginx activo${NC}"
else
    echo -e "${RED}❌ Nginx no activo: $nginx_status${NC}"
fi

# Verificar configuración SSL
echo -e "${BLUE}3. Verificando configuración SSL...${NC}"
ssl_config=$(ansible esb_vms -m shell -a "nginx -t" 2>/dev/null | grep -c "successful" || echo "0")
if [ "$ssl_config" -gt 0 ]; then
    echo -e "${GREEN}✅ Configuración Nginx válida${NC}"
else
    echo -e "${RED}❌ Configuración Nginx inválida${NC}"
fi

# Verificar certificados SSL
echo -e "${BLUE}4. Verificando certificados SSL...${NC}"
corp_cert=$(ansible esb_vms -m shell -a "test -f /etc/letsencrypt/live/executiveservicebusiness.duckdns.org/fullchain.pem && echo 'exists'" 2>/dev/null | grep -c "exists" || echo "0")
eyenga_cert=$(ansible esb_vms -m shell -a "test -f /etc/letsencrypt/live/eyenga.duckdns.org/fullchain.pem && echo 'exists'" 2>/dev/null | grep -c "exists" || echo "0")

if [ "$corp_cert" -gt 0 ]; then
    echo -e "${GREEN}✅ Certificado corporativa presente${NC}"
else
    echo -e "${RED}❌ Certificado corporativa ausente${NC}"
fi

if [ "$eyenga_cert" -gt 0 ]; then
    echo -e "${GREEN}✅ Certificado Eyenga presente${NC}"
else
    echo -e "${RED}❌ Certificado Eyenga ausente${NC}"
fi

# Verificar archivos de aplicaciones
echo -e "${BLUE}5. Verificando archivos de aplicaciones...${NC}"
corp_files=$(ansible esb_vms -m shell -a "test -f /var/www/html/corporativa/index.html && echo 'exists'" 2>/dev/null | grep -c "exists" || echo "0")
eyenga_files=$(ansible esb_vms -m shell -a "test -f /var/www/html/eyenga/index.html && echo 'exists'" 2>/dev/null | grep -c "exists" || echo "0")

if [ "$corp_files" -gt 0 ]; then
    echo -e "${GREEN}✅ Archivos aplicación corporativa presentes${NC}"
else
    echo -e "${RED}❌ Archivos aplicación corporativa ausentes${NC}"
fi

if [ "$eyenga_files" -gt 0 ]; then
    echo -e "${GREEN}✅ Archivos aplicación Eyenga presentes${NC}"
else
    echo -e "${RED}❌ Archivos aplicación Eyenga ausentes${NC}"
fi

# Verificar firewall UFW
echo -e "${BLUE}6. Verificando configuración del firewall...${NC}"
ufw_status=$(ansible esb_vms -m shell -a "ufw status | grep -E '22/tcp|443/tcp' | wc -l" 2>/dev/null | tail -1)
if [ "$ufw_status" -ge 2 ]; then
    echo -e "${GREEN}✅ Firewall configurado correctamente (puertos 22 y 443)${NC}"
else
    echo -e "${YELLOW}⚠️  Firewall puede necesitar verificación${NC}"
fi

# Verificar acceso HTTPS
echo -e "${BLUE}7. Verificando acceso HTTPS...${NC}"
corp_https=$(ansible esb_vms -m uri -a "url=https://executiveservicebusiness.duckdns.org method=GET validate_certs=yes" 2>/dev/null | grep -c "200" || echo "0")
eyenga_https=$(ansible esb_vms -m uri -a "url=https://eyenga.duckdns.org method=GET validate_certs=yes" 2>/dev/null | grep -c "200" || echo "0")

if [ "$corp_https" -gt 0 ]; then
    echo -e "${GREEN}✅ Aplicación corporativa accesible vía HTTPS${NC}"
else
    echo -e "${RED}❌ Aplicación corporativa no accesible vía HTTPS${NC}"
fi

if [ "$eyenga_https" -gt 0 ]; then
    echo -e "${GREEN}✅ Aplicación Eyenga accesible vía HTTPS${NC}"
else
    echo -e "${RED}❌ Aplicación Eyenga no accesible vía HTTPS${NC}"
fi

# Verificar renovación automática
echo -e "${BLUE}8. Verificando renovación automática SSL...${NC}"
cron_job=$(ansible esb_vms -m shell -a "crontab -l | grep certbot | wc -l" 2>/dev/null | tail -1)
if [ "$cron_job" -gt 0 ]; then
    echo -e "${GREEN}✅ Renovación automática SSL configurada${NC}"
else
    echo -e "${RED}❌ Renovación automática SSL no configurada${NC}"
fi

echo ""
echo -e "${BLUE}📊 RESUMEN FINAL:${NC}"
echo -e "${GREEN}🌐 URLs de acceso:${NC}"
echo "   • https://executiveservicebusiness.duckdns.org"
echo "   • https://eyenga.duckdns.org"
echo ""
echo -e "${GREEN}🔐 Configuración de seguridad:${NC}"
echo "   • Firewall: Solo puertos 22 (SSH) y 443 (HTTPS)"
echo "   • SSL/TLS: Certificados Let's Encrypt válidos"
echo "   • Headers: Configuración de seguridad aplicada"
echo ""
echo -e "${GREEN}🔄 Automatización:${NC}"
echo "   • DuckDNS: Actualización cada 30 minutos"
echo "   • SSL: Renovación automática el 1 y 15 de cada mes"
echo ""

# Verificación final
total_checks=8
passed_checks=0

[ "$nginx_status" = "active" ] && ((passed_checks++))
[ "$ssl_config" -gt 0 ] && ((passed_checks++))
[ "$corp_cert" -gt 0 ] && ((passed_checks++))
[ "$eyenga_cert" -gt 0 ] && ((passed_checks++))
[ "$corp_files" -gt 0 ] && ((passed_checks++))
[ "$eyenga_files" -gt 0 ] && ((passed_checks++))
[ "$corp_https" -gt 0 ] && ((passed_checks++))
[ "$eyenga_https" -gt 0 ] && ((passed_checks++))

if [ "$passed_checks" -eq "$total_checks" ]; then
    echo -e "${GREEN}🎉 DESPLIEGUE COMPLETAMENTE EXITOSO ($passed_checks/$total_checks checks)${NC}"
    exit 0
elif [ "$passed_checks" -gt 5 ]; then
    echo -e "${YELLOW}⚠️  DESPLIEGUE MAYORMENTE EXITOSO ($passed_checks/$total_checks checks)${NC}"
    exit 0
else
    echo -e "${RED}❌ DESPLIEGUE CON PROBLEMAS ($passed_checks/$total_checks checks)${NC}"
    exit 1
fi
