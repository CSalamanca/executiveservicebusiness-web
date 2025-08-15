# 📋 CONFIGURACIÓN FINAL - Executive Service Business

## 🎯 Estado Actual de Producción

Este documento refleja la configuración **exacta** que está funcionando en producción actualmente.

### 🌐 URLs y Dominios

- **Aplicación Corporativa**: https://executiveservicebusiness.duckdns.org
- **Aplicación Eyenga**: https://eyenga.duckdns.org
- **IP del servidor**: 141.253.199.218

### 🔧 Arquitectura de Aplicaciones

**IMPORTANTE**: Las aplicaciones se sirven como **archivos estáticos**, NO como proxy reverso.

```
Nginx → Archivos estáticos compilados de React
├── /var/www/html/corporativa/   (build de apps/corporativa)
└── /var/www/html/eyenga/        (build de apps/eyenga)
```

### 🔐 Configuración SSL

**Certificados separados** para cada dominio:

```
/etc/letsencrypt/live/executiveservicebusiness.duckdns.org/
├── fullchain.pem
└── privkey.pem

/etc/letsencrypt/live/eyenga.duckdns.org/
├── fullchain.pem
└── privkey.pem
```

### 🛡️ Configuración de Seguridad

#### Oracle Cloud Security Lists

```
Ingress Rules:
- Puerto 22 (SSH)    → 0.0.0.0/0
- Puerto 443 (HTTPS) → 0.0.0.0/0
```

#### UFW Firewall

```
Status: active
To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
443/tcp                    ALLOW IN    Anywhere
3000/tcp                   ALLOW IN    127.0.0.1 (interno)
3001/tcp                   ALLOW IN    127.0.0.1 (interno)
```

### 🔄 Automatización

#### DuckDNS (cada 30 minutos)

```bash
crontab -l
*/30 * * * * /usr/local/bin/duckdns-update.sh
```

#### SSL Renovación (días 1 y 15 de cada mes)

```bash
crontab -l
0 12 1,15 * * /usr/bin/certbot renew --quiet --post-hook '/usr/local/bin/ssl-renewal-hook.sh'
```

### 📁 Configuración de Archivos

#### Nginx configuración principal

```
/etc/nginx/sites-available/ssl-webapp
/etc/nginx/sites-enabled/ssl-webapp → ssl-webapp
```

#### Archivos web

```
/var/www/html/corporativa/
├── index.html
├── static/
│   ├── css/
│   └── js/
└── ...

/var/www/html/eyenga/
├── index.html
├── static/
│   ├── css/
│   └── js/
└── ...
```

### 🚀 Comandos de Despliegue

#### Para aplicar esta configuración exacta:

```bash
cd ansible/
./deploy.sh
# Opción 7: 🎯 Aplicar configuración SSL final (working)
```

#### Para verificar el estado:

```bash
./verify-deployment.sh
```

### 📊 Monitoreo

#### Logs importantes:

```bash
# Logs de Nginx
tail -f /var/log/nginx/error.log
tail -f /var/log/nginx/corporativa-access.log
tail -f /var/log/nginx/eyenga-access.log

# Logs de DuckDNS
tail -f /var/log/duckdns.log

# Logs de SSL
tail -f /var/log/ssl-renewal-hook.log
```

#### Verificación de estado:

```bash
# Certificados SSL
sudo certbot certificates

# Estado de Nginx
sudo systemctl status nginx

# Estado del firewall
sudo ufw status verbose

# Verificación de sitios
curl -I https://executiveservicebusiness.duckdns.org
curl -I https://eyenga.duckdns.org
```

### ⚠️ Puntos Críticos

1. **NO usar proxy reverso** - Los archivos se sirven estáticamente
2. **Certificados separados** - Cada dominio tiene su propio certificado
3. **Puerto 80 cerrado** - Solo se usa temporalmente para renovación SSL
4. **Permisos web** - www-data:www-data para todos los archivos en /var/www/html/

### 📝 Archivos Clave en el Workspace

- `/workspace/nginx-ssl.conf` - Configuración SSL actual
- `/workspace/ansible/roles/nginx/templates/nginx-sites-ssl-final.conf.j2` - Template final
- `/workspace/ansible/playbooks/setup-ssl-final.yml` - Playbook de configuración SSL final
- `/workspace/ansible/verify-deployment.sh` - Script de verificación

Esta configuración ha sido **probada y validada en producción**. 🎉
