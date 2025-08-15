# 🚀 Guía de Despliegue - Executive Service Business

## 📋 Información del Proyecto

**Proyecto**: Executive Service Business Multi-Site  
**Aplicaciones**: Corporativa + Eyenga  
**Tecnología**: React 18.x + TypeScript  
**Infraestructura**: Oracle Cloud Infrastructure (OCI) Free Tier  
**Estado**: ✅ Infraestructura desplegada, aplicaciones pendientes  
**Costo**: **$0.00 USD/mes** (Always Free)

## 🎯 Estado Actual del Despliegue

### ✅ Completado

- [x] **Infraestructura Oracle Cloud**
  - [x] VM ARM: 4 OCPU, 24GB RAM, 150GB storage (Free Tier)
  - [x] VCN, Subnet, Internet Gateway, Route Table
  - [x] Security List (Firewall): puertos 22 y 443
  - [x] IP Pública: `143.47.38.168`
  - [x] SSH configurado y funcionando
- [x] **Configuración de Desarrollo**
  - [x] Oracle CLI configurado
  - [x] Terraform Infrastructure as Code
  - [x] Claves SSH generadas
  - [x] .gitignore para archivos sensibles

### 🔄 En Desarrollo

- [x] **Automatización con Ansible**

  - [x] Framework completo de Ansible creado
  - [x] Roles para DuckDNS, Nginx y aplicaciones
  - [x] Playbooks de deployment y mantenimiento
  - [x] Scripts de utilidades automatizados
  - [ ] Configuración de tokens DuckDNS
  - [ ] Ejecución de deployment inicial

- [ ] **Instalación de Aplicaciones**

  - [ ] Deployment automático con Ansible
  - [ ] Configuración de Nginx multi-site
  - [ ] Configuración de dominios DuckDNS

- [ ] **Configuración SSL**
  - [ ] Configuración automatizada Let's Encrypt
  - [ ] HTTPS redirect
  - [ ] Renovación automática de certificados

## 🏗️ Proceso de Build y Despliegue Manual (Alternativo)

```
┌─────────────────────────────────────────┐
│        Internet Gateway (FREE)         │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│           VCN 10.0.0.0/16 (FREE)       │
│  ┌─────────────────────────────────────┐│
│  │     Subnet 10.0.1.0/24 (FREE)      ││
│  │  ┌─────────────────────────────────┐││
│  │  │     VM vm-esb (FREE)            │││
│  │  │   IP: 143.47.38.168             │││
│  │  │   VM.Standard.A1.Flex ARM       │││
│  │  │   4 OCPU, 24GB RAM, 150GB       │││
│  │  │  ┌─────────────────────────────┐│││
│  │  │  │         Nginx               ││││
│  │  │  │ :443 -> corporativa/eyenga  ││││
│  │  │  └─────────────────────────────┘│││
│  │  └─────────────────────────────────┘││
│  └─────────────────────────────────────┘│
└─────────────────────────────────────────┘
```

## ⚙️ Configuración de Entorno

### Variables de Entorno para Oracle Cloud

```bash
# Información de la VM actual
VM_IP=143.47.38.168
VM_HOSTNAME=vm-esb
SSH_KEY=~/.ssh/oracle_key
SSH_USER=ubuntu

# Oracle Cloud IDs
TENANCY_OCID=ocid1.tenancy.oc1..aaaaaaaas6unwuf3wsbpw4r4gnldgzliqebbw3sk7ibozkcmwlchksxe3lsa
USER_OCID=ocid1.user.oc1..aaaaaaaahu4icrylrpamush4g36p6tsvicup5fvgfp2aevc7xol435jm5omq
REGION=eu-madrid-1
```

### Configuración de Dominios DuckDNS

```json
{
  "sites": {
    "corporativa": {
      "local": { "domain": "corporativa.local", "port": 3000 },
      "development": { "domain": "143.47.38.168/corporativa", "port": 443 },
      "production": {
        "domain": "executiveservicebusiness.duckdns.org",
        "port": 443
      }
    },
    "eyenga": {
      "local": { "domain": "eyenga.local", "port": 3001 },
      "development": { "domain": "143.47.38.168/eyenga", "port": 443 },
      "production": { "domain": "eyenga.duckdns.org", "port": 443 }
    }
  }
}
```

## 🔒 SSL/HTTPS con Renovación Automática

### Certificados Let's Encrypt

Los certificados SSL se configuran automáticamente con renovación automática robusta:

```bash
cd ansible/
./deploy.sh
# Opción 3: Configurar SSL/HTTPS
```

#### **Sistema de Renovación Automática**

- **Systemd Timer**: 2 veces al día (06:00, 18:00)
- **Cron Backup**: 1 vez al día (02:30)
- **Verificación**: Diariamente a las 08:00
- **Hooks**: Post-renovación automáticos

#### **Gestión SSL**

```bash
# Herramienta de gestión SSL
./ssl-manager.sh

# Opciones disponibles:
# 1. Ver estado de certificados
# 2. Verificar conectividad HTTPS
# 3. Ver logs de renovación
# 4. Forzar renovación
# 5. Test de renovación (dry-run)
# 6. Reiniciar servicios SSL
# 7. Verificar configuración
# 8. Ver información del sistema
# 9. SSH al servidor
```

### Monitoreo SSL

Los logs de renovación se encuentran en:

- `/var/log/certbot-renewal.log` - Renovación automática
- `/var/log/ssl-check.log` - Verificación diaria
- `/var/log/ssl-renewal-hook.log` - Post-renovación hooks

## 🔧 Comandos de Administración

### Acceso a la VM

```bash
# Conectar por SSH
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168

# Verificar estado del sistema
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "
  echo '=== ESTADO DEL SISTEMA ==='
  uptime
  df -h
  free -h
  systemctl status nginx
"

# Verificar logs
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "
  sudo tail -f /var/log/cloud-init-output.log
"
```

### Terraform - Gestión de Infraestructura

```bash
# Ver estado actual
cd terraform/
terraform output

# Ver información detallada
terraform show

# Aplicar cambios
terraform plan
terraform apply

# Destruir infraestructura (¡CUIDADO!)
terraform destroy
```

## 🚀 Despliegue con Ansible (Recomendado)

### Configuración Inicial

```bash
# 1. Navegar al directorio de Ansible
cd /workspace/ansible

# 2. Configurar tokens DuckDNS en inventory/hosts.yml
# Editar las variables duckdns_tokens con tus tokens reales

# 3. Verificar conectividad
ansible esb_vms -m ping

# 4. Ejecutar deployment completo
./deploy.sh
# Seleccionar opción 1: Deployment completo
```

### Funcionalidades de Ansible

- **DuckDNS**: Actualización automática de DNS cada 30 minutos
- **Nginx**: Configuración multi-dominio con SSL
- **Aplicaciones**: Deployment automatizado desde Git
- **Monitoreo**: Scripts de utilidades y mantenimiento

Ver documentación completa en: `/workspace/ansible/README.md`

---

### Opción 1: Instalación Manual (Recomendado para resolver problemas)

```bash
# 1. Conectar a la VM
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168

# 2. Actualizar sistema
sudo apt update && sudo apt upgrade -y

# 3. Instalar Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# 4. Instalar dependencias
sudo apt install -y nginx git curl wget unzip

# 5. Configurar firewall
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

# 6. Clonar repositorio
git clone https://github.com/CSalamanca/executiveservicebusiness-web.git
cd executiveservicebusiness-web

# 7. Instalar y compilar aplicaciones
npm install
npm run install:all
npm run build:all

# 8. Configurar Nginx
sudo cp terraform/nginx-multisite.conf /etc/nginx/sites-available/webapp
sudo ln -sf /etc/nginx/sites-available/webapp /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# 9. Crear directorios web
sudo mkdir -p /var/www/corporativa /var/www/eyenga /var/www/html

# 10. Copiar builds
sudo cp -r apps/corporativa/build/* /var/www/corporativa/
sudo cp -r apps/eyenga/build/* /var/www/eyenga/

# 11. Configurar permisos
sudo chown -R www-data:www-data /var/www/
sudo chmod -R 755 /var/www/

# 12. Reiniciar Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

### Opción 2: Script Automatizado

```bash
# Crear script de despliegue en la VM
cat > deploy.sh << 'EOF'
#!/bin/bash
set -e

echo "🚀 Iniciando despliegue automatizado..."

# Verificar dependencias
command -v node >/dev/null 2>&1 || {
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
}

command -v nginx >/dev/null 2>&1 || {
    echo "Installing Nginx..."
    sudo apt update
    sudo apt install -y nginx
}

# Clonar o actualizar repositorio
if [ -d "executiveservicebusiness-web" ]; then
    cd executiveservicebusiness-web
    git pull origin oracle-vm
else
    git clone https://github.com/CSalamanca/executiveservicebusiness-web.git
    cd executiveservicebusiness-web
fi

# Build aplicaciones
echo "📦 Building applications..."
npm install
npm run install:all
npm run build:all

# Configurar web server
echo "🌐 Configuring web server..."
sudo mkdir -p /var/www/{corporativa,eyenga,html}
sudo cp -r apps/corporativa/build/* /var/www/corporativa/
sudo cp -r apps/eyenga/build/* /var/www/eyenga/

# Crear página de índice
sudo tee /var/www/html/index.html > /dev/null << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Executive Service Business</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin: 50px; }
        .container { max-width: 600px; margin: 0 auto; }
        .app-link { display: inline-block; margin: 20px; padding: 20px;
                   background: #f4f4f4; text-decoration: none; color: #333;
                   border-radius: 8px; transition: background 0.3s; }
        .app-link:hover { background: #e4e4e4; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Executive Service Business</h1>
        <p>Selecciona una aplicación:</p>
        <a href="/corporativa" class="app-link">
            <h3>Aplicación Corporativa</h3>
            <p>Sitio web corporativo</p>
        </a>
        <a href="/eyenga" class="app-link">
            <h3>Eyenga</h3>
            <p>Plataforma educativa</p>
        </a>
    </div>
</body>
</html>
HTML

# Configurar Nginx
sudo tee /etc/nginx/sites-available/webapp > /dev/null << 'NGINX'
server {
    listen 80 default_server;
    server_name _;

    root /var/www/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /corporativa {
        alias /var/www/corporativa;
        try_files $uri $uri/ /corporativa/index.html;
    }

    location /eyenga {
        alias /var/www/eyenga;
        try_files $uri $uri/ /eyenga/index.html;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
}
NGINX

# Activar configuración
sudo ln -sf /etc/nginx/sites-available/webapp /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Configurar permisos
sudo chown -R www-data:www-data /var/www/
sudo chmod -R 755 /var/www/

# Reiniciar servicios
sudo systemctl restart nginx
sudo systemctl enable nginx

# Configurar firewall
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw --force enable

echo "✅ Despliegue completado exitosamente!"
echo "🌐 Aplicaciones disponibles en:"
echo "   - http://$(curl -s ifconfig.me)/"
echo "   - http://$(curl -s ifconfig.me)/corporativa"
echo "   - http://$(curl -s ifconfig.me)/eyenga"

EOF

chmod +x deploy.sh
```

### Ejecutar Despliegue Automatizado

```bash
# Copiar script a la VM y ejecutar
scp -i ~/.ssh/oracle_key deploy.sh ubuntu@143.47.38.168:~/
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "~/deploy.sh"
```

## 🌐 Configuración de Dominios

### Configuración DNS (Para dominios personalizados)

```bash
# Configurar registros DNS apuntando a la IP pública
IP_PUBLICA=143.47.38.168

# Registros DNS necesarios:
# Tipo  Nombre              Valor              TTL
# A     @                   143.47.38.168     300
# A     www                 143.47.38.168     300
# A     corporativa         143.47.38.168     300
# A     eyenga             143.47.38.168     300
```

### Configuración SSL con Let's Encrypt

```bash
# 1. Conectar a la VM
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168

# 2. Instalar Certbot
sudo apt install -y certbot python3-certbot-nginx

# 3. Obtener certificados (solo después de configurar DNS)
sudo certbot --nginx -d corporativa.tudominio.com -d eyenga.tudominio.com

# 4. Verificar auto-renovación
sudo certbot renew --dry-run

# 5. Configurar renovación automática
echo "0 12 * * * /usr/bin/certbot renew --quiet" | sudo crontab -
```

### Configuración de Nginx con SSL

```nginx
# /etc/nginx/sites-available/webapp-ssl
server {
    listen 80;
    server_name corporativa.tudominio.com eyenga.tudominio.com 143.47.38.168;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name corporativa.tudominio.com;

    ssl_certificate /etc/letsencrypt/live/corporativa.tudominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/corporativa.tudominio.com/privkey.pem;

    root /var/www/corporativa;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}

server {
    listen 443 ssl http2;
    server_name eyenga.tudominio.com;

    ssl_certificate /etc/letsencrypt/live/eyenga.tudominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/eyenga.tudominio.com/privkey.pem;

    root /var/www/eyenga;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}
```

## 🔒 Seguridad en Oracle Cloud

### Configuración del Firewall en Oracle Cloud Console

```bash
# Security List Rules ya configuradas en Terraform:
# Ingress Rules:
#   - Puerto 22 (SSH): 0.0.0.0/0
#   - Puerto 443 (HTTPS): 0.0.0.0/0
#   - ICMP (Ping): 0.0.0.0/0

# Egress Rules:
#   - All traffic: 0.0.0.0/0
```

### Configuración del Firewall del Sistema (UFW)

```bash
# Conectar a la VM
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168

# Configurar UFW
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Permitir SSH
sudo ufw allow ssh
sudo ufw allow 22

# Permitir HTTP/HTTPS
sudo ufw allow 'Nginx Full'
sudo ufw allow 80
sudo ufw allow 443

# Habilitar firewall
sudo ufw --force enable

# Verificar estado
sudo ufw status verbose
```

### Endurecimiento de SSH

```bash
# Configuración SSH más segura
sudo tee -a /etc/ssh/sshd_config << EOF

# Executive Service Business SSH Security
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
X11Forwarding no
MaxAuthTries 3
ClientAliveInterval 300
ClientAliveCountMax 2
EOF

# Reiniciar SSH
sudo systemctl restart ssh
```

## 📊 Monitoreo y Mantenimiento

### Scripts de Monitoreo

```bash
# Script de estado del sistema
cat > monitor.sh << 'EOF'
#!/bin/bash

echo "=== MONITOREO SISTEMA - $(date) ==="
echo "📊 RECURSOS:"
echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')%"
echo "RAM: $(free | grep Mem | awk '{printf "%.2f%%", $3/$2 * 100.0}')"
echo "Disk: $(df -h / | awk 'NR==2{print $5}')"

echo "🌐 SERVICIOS:"
systemctl is-active nginx && echo "✅ Nginx: Running" || echo "❌ Nginx: Stopped"

echo "🔗 CONECTIVIDAD:"
curl -s -I http://localhost > /dev/null && echo "✅ HTTP: OK" || echo "❌ HTTP: Error"

echo "📈 LOGS RECIENTES:"
echo "Nginx errors (last 5):"
sudo tail -5 /var/log/nginx/error.log 2>/dev/null || echo "No errors"

EOF

chmod +x monitor.sh
```

### Copiar script a la VM y configurar cron

```bash
# Copiar script
scp -i ~/.ssh/oracle_key monitor.sh ubuntu@143.47.38.168:~/

# Configurar ejecución automática
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "
chmod +x ~/monitor.sh
# Ejecutar cada hora
(crontab -l 2>/dev/null; echo '0 * * * * ~/monitor.sh >> ~/system-monitor.log') | crontab -
"
```

### Backup Automático

```bash
# Script de backup
cat > backup.sh << 'EOF'
#!/bin/bash

BACKUP_DIR="/home/ubuntu/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

echo "🗄️ Backup iniciado: $DATE"

# Backup de aplicaciones web
tar -czf "$BACKUP_DIR/web_$DATE.tar.gz" -C /var/www . 2>/dev/null

# Backup de configuración Nginx
sudo cp /etc/nginx/sites-available/webapp "$BACKUP_DIR/nginx_$DATE.conf"

# Limpiar backups antiguos (mantener solo los últimos 7 días)
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
find $BACKUP_DIR -name "*.conf" -mtime +7 -delete

echo "✅ Backup completado: $BACKUP_DIR/web_$DATE.tar.gz"
EOF

# Copiar y configurar
scp -i ~/.ssh/oracle_key backup.sh ubuntu@143.47.38.168:~/
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "
chmod +x ~/backup.sh
# Backup diario a las 2 AM
(crontab -l 2>/dev/null; echo '0 2 * * * ~/backup.sh') | crontab -
```

## 🐛 Troubleshooting y Diagnóstico

### Problemas Comunes y Soluciones

#### 1. Error de conexión SSH

```bash
# Problema: Permission denied (publickey)
# Solución:
ssh-add ~/.ssh/oracle_key
ssh -i ~/.ssh/oracle_key -v ubuntu@143.47.38.168

# Verificar permisos de la clave
chmod 600 ~/.ssh/oracle_key
```

#### 2. Aplicaciones no cargan

```bash
# Conectar a la VM
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168

# Verificar status de Nginx
sudo systemctl status nginx

# Revisar logs de Nginx
sudo tail -f /var/log/nginx/error.log
sudo tail -f /var/log/nginx/access.log

# Verificar archivos web
ls -la /var/www/corporativa/
ls -la /var/www/eyenga/

# Verificar configuración Nginx
sudo nginx -t

# Recargar configuración
sudo systemctl reload nginx
```

#### 3. Error en cloud-init

```bash
# Revisar logs de cloud-init
sudo tail -f /var/log/cloud-init-output.log
sudo cloud-init status

# Re-ejecutar cloud-init si es necesario
sudo cloud-init clean --logs
sudo cloud-init init
```

#### 4. Problemas de firewall

```bash
# Verificar reglas UFW
sudo ufw status verbose

# Verificar Security List en Oracle Cloud Console
# Navegar a: VCN Details > Security Lists > Default Security List

# Verificar conectividad
curl -I http://143.47.38.168
telnet 143.47.38.168 443
```

### Comandos de Diagnóstico

```bash
# Script de diagnóstico completo
cat > diagnose.sh << 'EOF'
#!/bin/bash

echo "🔍 DIAGNÓSTICO COMPLETO - $(date)"
echo "=================================================="

echo "📋 INFORMACIÓN DEL SISTEMA:"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
echo "Load: $(uptime | awk -F'load average:' '{print $2}')"

echo ""
echo "💾 RECURSOS:"
echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | awk -F'%' '{print $1}')%"
echo "Memory:"
free -h

echo "Disk Usage:"
df -h

echo ""
echo "🌐 SERVICIOS:"
echo "Nginx: $(systemctl is-active nginx)"
echo "SSH: $(systemctl is-active ssh)"

echo ""
echo "🔥 FIREWALL:"
echo "UFW Status:"
sudo ufw status verbose

echo ""
echo "📡 CONECTIVIDAD:"
echo "External IP Check:"
curl -s ipinfo.io/ip || echo "No external connectivity"

echo "Port Checks:"
ss -tulpn | grep -E ':(22|80|443|8080)'

echo ""
echo "📁 ARCHIVOS WEB:"
echo "Corporativa files:"
ls -la /var/www/corporativa/ 2>/dev/null | head -5

echo "Eyenga files:"
ls -la /var/www/eyenga/ 2>/dev/null | head -5

echo ""
echo "🗃️ LOGS RECIENTES:"
echo "Nginx Errors (last 3):"
sudo tail -3 /var/log/nginx/error.log 2>/dev/null || echo "No errors found"

echo "System Errors (last 3):"
sudo tail -3 /var/log/syslog | grep -i error || echo "No recent errors"

echo ""
echo "✅ DIAGNÓSTICO COMPLETADO"
EOF

# Hacer ejecutable y copiar a la VM
chmod +x diagnose.sh
scp -i ~/.ssh/oracle_key diagnose.sh ubuntu@143.47.38.168:~/

# Ejecutar diagnóstico
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "./diagnose.sh"
```

## 📈 Optimización de Performance

### Configuración Avanzada de Nginx

```bash
# Copiar configuración optimizada
cat > nginx-optimized.conf << 'EOF'
# /etc/nginx/nginx.conf - Configuración optimizada

user www-data;
worker_processes auto;
worker_rlimit_nofile 65535;
pid /run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    charset utf-8;
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    server_tokens off;
    log_not_found off;
    types_hash_max_size 4096;
    client_max_body_size 16M;

    # MIME
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Logging
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log warn;

    # Gzip Compression
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;

    # Load configs
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
EOF

# Aplicar configuración
scp -i ~/.ssh/oracle_key nginx-optimized.conf ubuntu@143.47.38.168:~/
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "
sudo cp nginx-optimized.conf /etc/nginx/nginx.conf
sudo nginx -t && sudo systemctl reload nginx
"
```

### Cache para Assets Estáticos

```bash
# Configuración de cache para React apps
cat > cache-config.conf << 'EOF'
# /etc/nginx/conf.d/cache.conf

# HTML files - no cache
location ~* \.html$ {
    expires -1;
    add_header Cache-Control "no-cache, no-store, must-revalidate";
    add_header Pragma "no-cache";
}

# CSS and JavaScript - long cache
location ~* \.(css|js)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# Images - medium cache
location ~* \.(jpg|jpeg|png|gif|ico|svg|webp)$ {
    expires 6M;
    add_header Cache-Control "public";
}

# Fonts - long cache
location ~* \.(woff|woff2|ttf|eot)$ {
    expires 1y;
    add_header Cache-Control "public";
    access_log off;
}

# Manifest and service worker - no cache
location ~* \.(manifest|sw\.js)$ {
    expires -1;
    add_header Cache-Control "no-cache";
}
EOF

# Aplicar configuración de cache
scp -i ~/.ssh/oracle_key cache-config.conf ubuntu@143.47.38.168:~/
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168 "
sudo cp cache-config.conf /etc/nginx/conf.d/
sudo nginx -t && sudo systemctl reload nginx
"
```

## � Checklist de Despliegue

### ✅ Pre-despliegue

- [ ] Oracle Cloud CLI configurado localmente
- [ ] Credenciales OCI configuradas (`~/.oci/config`)
- [ ] Clave SSH generada (`~/.ssh/oracle_key`)
- [ ] Aplicaciones React funcionando localmente
- [ ] Terraform instalado y configurado

### ✅ Infraestructura

- [ ] VCN y subnet creados en Oracle Cloud
- [ ] VM ARM Instance desplegada
- [ ] Security Lists configurados (puertos 22, 443)
- [ ] Instancia accesible vía SSH
- [ ] IP pública asignada: `143.47.38.168`

### ✅ Servidor Web

- [ ] Nginx instalado y corriendo
- [ ] Aplicaciones React desplegadas en `/var/www/`
- [ ] Configuración de virtual hosts
- [ ] Firewall UFW configurado
- [ ] SSL/TLS configurado (si aplica)

### ✅ Aplicaciones

- [ ] App Corporativa accesible
- [ ] App Eyenga accesible
- [ ] Routing de React Router funcionando
- [ ] Assets estáticos cargando correctamente
- [ ] Responsive design verificado

### ✅ Monitoreo y Mantenimiento

- [ ] Scripts de monitoreo configurados
- [ ] Backup automático configurado
- [ ] Logs de Nginx monitoreados
- [ ] Cron jobs configurados
- [ ] Documentación actualizada

## 📞 Soporte y Contacto

### Información de Acceso Rápido

```bash
# SSH a la VM
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168

# URLs de las aplicaciones
echo "Corporativa: http://143.47.38.168"
echo "Eyenga: http://143.47.38.168/eyenga"

# Comandos útiles en la VM
sudo systemctl status nginx    # Estado de Nginx
sudo nginx -t                  # Verificar configuración
sudo systemctl reload nginx    # Recargar configuración
./monitor.sh                   # Estado del sistema
./diagnose.sh                  # Diagnóstico completo
```

### Recursos Adicionales

- **Oracle Cloud Console**: https://cloud.oracle.com/
- **Documentación Oracle Cloud**: https://docs.oracle.com/en-us/iaas/
- **Terraform Oracle Provider**: https://registry.terraform.io/providers/oracle/oci/latest/docs
- **Nginx Documentation**: https://nginx.org/en/docs/

---

**Fecha de última actualización**: $(date '+%Y-%m-%d %H:%M:%S')
**Versión**: v1.0.0
**Mantenido por**: Executive Service Business Development Team

### Google Analytics 4

```typescript
// src/utils/analytics.ts
declare global {
  interface Window {
    gtag: (...args: any[]) => void;
  }
}

export const GA_TRACKING_ID = process.env.REACT_APP_ANALYTICS_ID;

// Initialize GA
export const initGA = (): void => {
  if (!GA_TRACKING_ID) return;

  window.gtag("config", GA_TRACKING_ID, {
    page_title: document.title,
    page_location: window.location.href,
  });
};

// Track page views
export const trackPageView = (path: string): void => {
  if (!GA_TRACKING_ID) return;

  window.gtag("config", GA_TRACKING_ID, {
    page_path: path,
  });
};

// Track events
export const trackEvent = (
  action: string,
  category: string,
  label?: string,
  value?: number
): void => {
  if (!GA_TRACKING_ID) return;

  window.gtag("event", action, {
    event_category: category,
    event_label: label,
    value: value,
  });
};
```

### Error Monitoring con Sentry

```typescript
// src/utils/sentry.ts
import * as Sentry from "@sentry/react";

export const initSentry = (): void => {
  if (process.env.REACT_APP_SENTRY_DSN) {
    Sentry.init({
      dsn: process.env.REACT_APP_SENTRY_DSN,
      environment: process.env.REACT_APP_ENVIRONMENT,
      integrations: [new Sentry.BrowserTracing()],
      tracesSampleRate: 1.0,
    });
  }
};
```

---

## 🔄 CI/CD Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: "20"
          cache: "npm"

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm run test:all

      - name: Build applications
        run: npm run build:all

      - name: Check bundle size
        run: node scripts/check-bundle-size.js

  deploy:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'

    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: "20"
          cache: "npm"

      - name: Install dependencies
        run: npm ci

      - name: Build for production
        run: npm run build:all
        env:
          REACT_APP_ENVIRONMENT: production

      - name: Deploy Corporativa
        uses: SamKirkland/FTP-Deploy-Action@4.3.3
        with:
          server: ${{ secrets.CORPORATIVA_FTP_SERVER }}
          username: ${{ secrets.CORPORATIVA_FTP_USERNAME }}
          password: ${{ secrets.CORPORATIVA_FTP_PASSWORD }}
          local-dir: ./apps/corporativa/build/
          server-dir: /public_html/

      - name: Deploy Eyenga
        uses: SamKirkland/FTP-Deploy-Action@4.3.3
        with:
          server: ${{ secrets.EYENGA_FTP_SERVER }}
          username: ${{ secrets.EYENGA_FTP_USERNAME }}
          password: ${{ secrets.EYENGA_FTP_PASSWORD }}
          local-dir: ./apps/eyenga/build/
          server-dir: /public_html/
```

---

## 🌍 Plataformas de Deployment

### Vercel

```json
{
  "version": 2,
  "builds": [
    {
      "src": "apps/corporativa/build/**",
      "use": "@vercel/static"
    },
    {
      "src": "apps/eyenga/build/**",
      "use": "@vercel/static"
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/apps/corporativa/build/$1"
    }
  ]
}
```

### Netlify

```toml
# netlify.toml para corporativa
[build]
  base = "apps/corporativa"
  publish = "build"
  command = "npm run build"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

### Docker para Producción

```dockerfile
# Dockerfile.production
FROM node:20-alpine as builder

# Build de ambas aplicaciones
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build:all

# Nginx para servir archivos estáticos
FROM nginx:alpine

# Copiar builds
COPY --from=builder /app/apps/corporativa/build /usr/share/nginx/html/corporativa
COPY --from=builder /app/apps/eyenga/build /usr/share/nginx/html/eyenga

# Configuración de Nginx
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
```

### Configuración de Nginx Multi-Site

```nginx
# nginx.conf
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # Servidor para Corporativa
    server {
        listen 80;
        server_name corporativa.com www.corporativa.com;
        root /usr/share/nginx/html/corporativa;
        index index.html;

        location / {
            try_files $uri $uri/ /index.html;
        }
    }

    # Servidor para Eyenga
    server {
        listen 80;
        server_name eyenga.com www.eyenga.com;
        root /usr/share/nginx/html/eyenga;
        index index.html;

        location / {
            try_files $uri $uri/ /index.html;
        }
    }
}
```

---

## 🎯 Post-Deployment Checklist

```bash
# Script de verificación post-deployment
#!/bin/bash

echo "🔍 Verificación post-deployment"
echo "==============================="

# URLs a verificar
URLS=(
    "https://corporativa.com"
    "https://www.corporativa.com"
    "https://eyenga.com"
    "https://www.eyenga.com"
)

for url in "${URLS[@]}"; do
    echo "🌐 Verificando: $url"

    # Verificar que el sitio responda
    if curl -s --head "$url" | head -n 1 | grep -q "200 OK"; then
        echo "✅ $url - Respondiendo correctamente"
    else
        echo "❌ $url - Error de respuesta"
    fi

    # Verificar certificado SSL
    if echo | openssl s_client -connect "${url#https://}:443" 2>/dev/null | grep -q "Verify return code: 0"; then
        echo "🔒 $url - SSL válido"
    else
        echo "🚨 $url - Problema con SSL"
    fi
done

echo "==============================="
echo "✅ Verificación completada"
```

---

**Autor**: Equipo de Desarrollo  
**Última actualización**: 15 de Agosto, 2025  
**Versión**: v1.0
