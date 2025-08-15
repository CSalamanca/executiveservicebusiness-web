# Executive Service Business - Guía de Ansible

## 📋 Tabla de Contenidos

1. [Prerequisitos](#prerequisitos)
2. [Configuración Inicial](#configuración-inicial)
3. [Estructura del Proyecto](#estructura-del-proyecto)
4. [Configuración de DuckDNS](#configuración-de-duckdns)
5. [Ejecución de Playbooks](#ejecución-de-playbooks)
6. [Scripts de Utilidades](#scripts-de-utilidades)
7. [Mantenimiento](#mantenimiento)
8. [Troubleshooting](#troubleshooting)

## 🚀 Prerequisitos

### Sistema Local

- **Ansible**: Versión 2.9 o superior
- **SSH**: Cliente SSH configurado
- **Git**: Para gestión de código

### Servidor Oracle Cloud

- **VM**: VM.Standard.A1.Flex ARM (4 OCPU, 24GB RAM, 150GB storage)
- **IP**: 143.47.38.168
- **SSH**: Acceso por clave SSH configurado
- **Puertos**: 22, 80, 443 abiertos

### Dominios DuckDNS

- `executiveservicebusiness.duckdns.org`
- `eyenga.duckdns.org`
- **Tokens**: Tokens de DuckDNS configurados

## ⚙️ Configuración Inicial

### 1. Instalar Ansible (Debian/Ubuntu)

```bash
sudo apt update
sudo apt install ansible
```

### 2. Configurar SSH

```bash
# Generar clave SSH si no existe
ssh-keygen -t rsa -b 4096 -f ~/.ssh/oracle_key

# Copiar clave pública al servidor
ssh-copy-id -i ~/.ssh/oracle_key.pub ubuntu@143.47.38.168
```

### 3. Configurar tokens DuckDNS

Edita el archivo `inventory/hosts.yml` y actualiza los tokens:

```yaml
esb_vms:
  hosts:
    oracle_vm:
      # ... otras configuraciones ...
      duckdns_tokens:
        executiveservicebusiness: "TU_TOKEN_AQUI"
        eyenga: "TU_TOKEN_AQUI"
```

### 4. Verificar conectividad

```bash
cd /workspace/ansible
ansible esb_vms -m ping
```

## 📁 Estructura del Proyecto

```
ansible/
├── ansible.cfg                 # Configuración de Ansible
├── deploy.sh                   # Script principal de deployment
├── utils.sh                   # Script de utilidades y mantenimiento
├── inventory/
│   └── hosts.yml              # Inventario con configuración de servidores
├── playbooks/
│   ├── deploy-apps.yml        # Playbook principal de deployment
│   ├── update-apps.yml        # Playbook para actualizar aplicaciones
│   └── setup-ssl.yml          # Playbook para configurar SSL
└── roles/
    ├── duckdns/               # Gestión de DNS dinámico
    ├── nginx/                 # Configuración de web server
    └── apps/                  # Deployment de aplicaciones React
```

### Roles Detallados

#### 🌐 Role: duckdns

- **Propósito**: Gestión automática de DNS dinámico
- **Funciones**:
  - Crear scripts de actualización automática
  - Configurar cron jobs (actualización cada 30 minutos)
  - Logging de actualizaciones
  - Gestión de múltiples dominios

#### 🔧 Role: nginx

- **Propósito**: Configuración del servidor web
- **Funciones**:
  - Instalación y configuración de Nginx
  - Virtual hosts para múltiples dominios
  - Configuración SSL/HTTPS
  - Proxy reverso para aplicaciones
  - Configuración de seguridad

#### 📱 Role: apps

- **Propósito**: Deployment de aplicaciones React
- **Funciones**:
  - Clonado desde repositorio Git
  - Instalación de dependencias Node.js
  - Build de aplicaciones
  - Deployment con zero-downtime
  - Backup de versiones anteriores

## 🔑 Configuración de DuckDNS

### 1. Obtener tokens

1. Visita [DuckDNS.org](https://www.duckdns.org)
2. Inicia sesión con tu cuenta
3. Copia los tokens para tus dominios

### 2. Configurar en Ansible

Edita `inventory/hosts.yml`:

```yaml
duckdns_tokens:
  executiveservicebusiness: "12345678-1234-1234-1234-123456789abc"
  eyenga: "87654321-4321-4321-4321-cba987654321"
```

### 3. Verificar funcionamiento

```bash
# Ejecutar actualización manual
./utils.sh
# Opción 2: Verificar dominios DuckDNS
```

## 🔐 Configuración SSL/TLS con Renovación Automática

### Certificados Let's Encrypt

El sistema está configurado con renovación automática robusta de certificados SSL:

#### **Métodos de Renovación**

1. **Systemd Timer (Principal)**

   - Ejecuta 2 veces al día: 06:00 y 18:00
   - Delay aleatorio de hasta 1 hora para evitar sobrecarga
   - Persistente entre reinicios del sistema

2. **Cron Job (Respaldo)**

   - Ejecuta 1 vez al día: 02:30
   - Funciona como método de respaldo

3. **Verificación Diaria**
   - Cada día a las 08:00
   - Verifica estado y vigencia de certificados

#### **Sistema de Hooks**

Cada renovación ejecuta un hook personalizado que:

- ✅ Verifica la validez de los certificados renovados
- ✅ Valida la configuración de Nginx
- ✅ Recarga Nginx automáticamente
- ✅ Verifica que las aplicaciones React siguen funcionando
- ✅ Prueba la conectividad HTTPS externa
- ✅ Registra todo en logs detallados

#### **Gestión y Monitoreo**

```bash
# Script principal de gestión SSL
./ssl-manager.sh

# Comandos útiles en el servidor
systemctl status certbot-renewal.timer  # Estado del timer
tail -f /var/log/certbot-renewal.log     # Logs de renovación
/usr/local/bin/check-ssl-certs.sh       # Verificación manual
certbot renew --dry-run                  # Test de renovación
```

#### **Logs y Monitoreo**

- `/var/log/certbot-renewal.log` - Logs de renovación automática
- `/var/log/ssl-check.log` - Logs de verificación diaria
- `/var/log/ssl-renewal-hook.log` - Logs del hook post-renovación
- `/var/log/letsencrypt/letsencrypt.log` - Logs detallados de Certbot

### Configuración de Certificados

Los certificados se obtienen automáticamente para:

- `executiveservicebusiness.duckdns.org`
- `eyenga.duckdns.org`

**Requisitos previos:**

1. Los dominios deben apuntar correctamente al servidor
2. Las aplicaciones React deben estar funcionando
3. Los puertos 22 y 443 deben estar abiertos

**Proceso de configuración:**

```bash
./deploy.sh  # Opción 3: Configurar SSL/HTTPS
```

### Renovación Manual

Si necesitas forzar una renovación:

```bash
# Usando el script de gestión
./ssl-manager.sh  # Opción 4: Forzar renovación

# Directamente en el servidor
sudo certbot renew --force-renewal --post-hook "/usr/local/bin/ssl-renewal-hook.sh"
```

## 🎯 Ejecución de Playbooks

### Deployment Completo

```bash
# Usando script automático (recomendado)
./deploy.sh

# Manual
ansible-playbook -i inventory/hosts.yml playbooks/deploy-apps.yml -v
```

### Solo Actualizar Aplicaciones

```bash
# Usando script automático
./deploy.sh
# Opción 2

# Manual
ansible-playbook -i inventory/hosts.yml playbooks/update-apps.yml -v
```

### Configurar SSL

```bash
# Usando script automático
./deploy.sh
# Opción 3

# Manual
ansible-playbook -i inventory/hosts.yml playbooks/setup-ssl.yml -v
```

## 🛠️ Scripts de Utilidades

### Script Principal: `deploy.sh`

```bash
./deploy.sh
```

**Opciones disponibles:**

1. 🏗️ Deployment completo (DuckDNS + Nginx + Apps)
2. 🔄 Solo actualizar aplicaciones
3. 🔒 Configurar SSL/HTTPS
4. 🧪 Solo verificar conectividad
5. 📋 Ver logs del servidor

### Script de Utilidades: `utils.sh`

```bash
./utils.sh
```

**Funciones disponibles:**

1. 📊 Estado del sistema
2. 🔍 Verificar dominios DuckDNS
3. 🔄 Reiniciar servicios
4. 📝 Ver logs en tiempo real
5. 🧹 Limpiar logs antiguos
6. 💽 Información de almacenamiento
7. 🌐 Test de conectividad
8. 🔧 Actualizar sistema
9. 🚪 SSH directo al servidor

## 🔧 Mantenimiento

### Monitoreo Regular

```bash
# Verificar estado del sistema cada semana
./utils.sh
# Opción 1: Estado del sistema

# Verificar dominios DuckDNS
./utils.sh
# Opción 2: Verificar dominios DuckDNS
```

### Actualizaciones

```bash
# Actualizar solo aplicaciones (sin downtime)
./deploy.sh
# Opción 2

# Actualizar sistema completo
./utils.sh
# Opción 8: Actualizar sistema
```

### Backup y Logs

```bash
# Limpiar logs antiguos (mensual)
./utils.sh
# Opción 5: Limpiar logs antiguos

# Ver logs en tiempo real para debugging
./utils.sh
# Opción 4: Ver logs en tiempo real
```

## 🚨 Troubleshooting

### Problemas Comunes

#### 1. Error de Conectividad SSH

```bash
# Síntoma: ansible esb_vms -m ping falla
# Solución:
ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168
# Si no conecta, verificar:
# - IP correcta en inventory/hosts.yml
# - Clave SSH correcta
# - VM encendida en Oracle Cloud
```

#### 2. Dominios DuckDNS no resuelven

```bash
# Verificar resolución DNS
./utils.sh
# Opción 2: Verificar dominios DuckDNS

# Forzar actualización manual
ansible esb_vms -m shell -a "/usr/local/bin/update-duckdns.sh"
```

#### 3. Nginx no responde

```bash
# Verificar estado
ansible esb_vms -m shell -a "systemctl status nginx"

# Reiniciar servicio
./utils.sh
# Opción 3: Reiniciar servicios

# Ver logs de error
ansible esb_vms -m shell -a "tail -50 /var/log/nginx/error.log"
```

#### 4. Aplicaciones no cargan

```bash
# Verificar archivos desplegados
ansible esb_vms -m shell -a "ls -la /var/www/"

# Re-deployar aplicaciones
./deploy.sh
# Opción 2: Solo actualizar aplicaciones
```

#### 5. SSL/HTTPS no funciona

```bash
# Verificar certificados
ansible esb_vms -m shell -a "certbot certificates"

# Renovar certificados
ansible esb_vms -m shell -a "certbot renew --dry-run"

# Re-configurar SSL
./deploy.sh
# Opción 3: Configurar SSL/HTTPS
```

### Comandos de Diagnóstico

#### Sistema

```bash
# Uso de recursos
ansible esb_vms -m shell -a "htop -b -n 1 | head -20"

# Espacio en disco
ansible esb_vms -m shell -a "df -h"

# Memoria
ansible esb_vms -m shell -a "free -h"
```

#### Red

```bash
# Puertos abiertos
ansible esb_vms -m shell -a "netstat -tlnp"

# Test de conectividad externa
ansible esb_vms -m shell -a "curl -I google.com"
```

#### Aplicaciones

```bash
# Procesos de Node.js
ansible esb_vms -m shell -a "ps aux | grep node"

# Logs de aplicación
ansible esb_vms -m shell -a "journalctl -u nginx -n 50"
```

## 🌐 URLs de Acceso

### Producción (con SSL)

- **Executive Service Business**: https://executiveservicebusiness.duckdns.org
- **Eyenga**: https://eyenga.duckdns.org

### Desarrollo/Testing (sin SSL)

- **Executive Service Business**: http://143.47.38.168/corporativa
- **Eyenga**: http://143.47.38.168/eyenga

### Monitoreo

- **Nginx Status**: http://143.47.38.168/nginx_status (si está habilitado)

## 📞 Contacto y Soporte

Para problemas técnicos:

1. Revisar logs con `./utils.sh`
2. Verificar conectividad
3. Consultar esta documentación
4. Contactar al administrador del sistema

---

_Documentación actualizada: 2024_
_Versión: 1.0_
