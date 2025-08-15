# 🛠️ Guía de Comandos - Proyecto Eyenga

## 📋 Índice

- [🚀 Comandos Principales](#-comandos-principales)
- [🔧 Comandos de Desarrollo](#-comandos-de-desarrollo)
- [🏗️ Comandos de Build](#️-comandos-de-build)
- [🧪 Comandos de Testing](#-comandos-de-testing)
- [🧹 Comandos de Limpieza](#-comandos-de-limpieza)
- [🌐 Gestión de Dominios](#-gestión-de-dominios)
- [❌ Resolución de Problemas](#-resolución-de-problemas)
- [🔍 Comandos de Diagnóstico](#-comandos-de-diagnóstico)

---

## 🚀 Comandos Principales

### Configuración Inicial

```bash
# Configurar todo el workspace desde cero
./setup.sh

# Hacer ejecutable el script (si es necesario)
chmod +x setup.sh

# Instalar dependencias del workspace
npm install
```

### Desarrollo - Aplicación Eyenga

```bash
# Iniciar aplicación Eyenga (principal)
npm run dev:eyenga

# Comando directo
cd apps/eyenga && npm start

# Con dominio local (requiere configuración de hosts)
npm run dev:eyenga  # Acceder en http://eyenga.local:3001
```

### Desarrollo - Todas las aplicaciones (opcional)

```bash
# Iniciar todas las aplicaciones disponibles
npm run dev:all

# Iniciar aplicación corporativa (no desarrollada)
npm run dev:corporativa    # Puerto 3000 - Esqueleto básico
```

### Parar Aplicaciones

```bash
# En la terminal donde están ejecutándose
Ctrl + C

# O matar procesos específicos
sudo lsof -ti:3001 | xargs kill -9  # Eyenga
sudo lsof -ti:3000 | xargs kill -9  # Corporativa
```

---

## 🔧 Comandos de Desarrollo

### Navegar entre aplicaciones

```bash
# Ir a app corporativa
cd apps/corporativa

# Ir a app Eyenga
cd apps/eyenga

# Volver al workspace root
cd ../..
```

### Comandos dentro de cada app

```bash
# Desde apps/corporativa/ o apps/eyenga/
npm start                 # Iniciar desarrollo
npm run build            # Build para producción
npm test                # Ejecutar tests
npm run test -- --watch # Tests en modo watch
npm install <package>   # Instalar nueva dependencia
```

### Agregar dependencias

```bash
# Al workspace principal
npm install <package>

# A aplicación específica
cd apps/corporativa && npm install <package>
cd apps/eyenga && npm install <package>

# Dependencias de desarrollo
npm install -D <package>
```

---

## 🏗️ Comandos de Build

### Build de todas las aplicaciones

```bash
# Desde workspace root
npm run build:all
```

### Build individual

```bash
# Build solo corporativa
npm run build:corporativa

# Build solo Eyenga
npm run build:eyenga
```

### Servir build localmente

```bash
# Instalar serve globalmente
npm install -g serve

# Servir build de corporativa
cd apps/corporativa && serve -s build -l 3000

# Servir build de Eyenga
cd apps/eyenga && serve -s build -l 3001
```

---

## 🧪 Comandos de Testing

### Tests de todas las aplicaciones

```bash
npm run test:all
```

### Tests individuales

```bash
npm run test:corporativa
npm run test:eyenga
```

### Tests específicos dentro de cada app

```bash
# Desde apps/corporativa/ o apps/eyenga/
npm test                           # Ejecutar todos los tests
npm test -- --watch              # Modo watch
npm test -- --coverage           # Con coverage
npm test App.test.tsx            # Test específico
npm test -- --verbose           # Output detallado
```

---

## 🧹 Comandos de Limpieza

### Limpiar node_modules

```bash
# Limpiar workspace completo
npm run clean

# Limpiar manualmente
rm -rf node_modules
rm -rf apps/*/node_modules
rm -rf package-lock.json
rm -rf apps/*/package-lock.json
```

### Reinstalar todo

```bash
# Después de limpiar
npm install
cd apps/corporativa && npm install
cd ../eyenga && npm install
```

### Limpiar caché de npm

```bash
npm cache clean --force
```

---

## 🌐 Gestión de Dominios

### Configurar dominios locales

```bash
# En tu sistema host (NO en el devcontainer)
sudo ./scripts/setup-hosts.sh
```

### Remover dominios locales

```bash
# En tu sistema host
sudo ./scripts/remove-hosts.sh
```

### Verificar configuración de hosts

```bash
# Ver entradas en /etc/hosts
cat /etc/hosts | grep -E "(corporativa|eyenga)\.local"

# Resultado esperado:
# 127.0.0.1 corporativa.local
# 127.0.0.1 eyenga.local
```

### Probar dominios

```bash
# Ping a dominios locales
ping corporativa.local
ping eyenga.local
```

---

## ❌ Resolución de Problemas

### Problema: Las aplicaciones no se inician

#### Síntomas:

- Error "EADDRINUSE"
- Puerto ya en uso
- Apps no cargan en navegador

#### Solución:

```bash
# 1. Verificar qué está usando los puertos
netstat -tlnp | grep :3000
netstat -tlnp | grep :3001

# 2. Matar procesos en esos puertos
sudo lsof -ti:3000 | xargs kill -9
sudo lsof -ti:3001 | xargs kill -9

# 3. Verificar que se liberaron
netstat -tlnp | grep :300

# 4. Reiniciar aplicaciones
npm run dev:all
```

### Problema: DevContainer no se abre

#### Síntomas:

- VS Code no detecta devcontainer
- Error al construir container
- Extensions no se instalan

#### Solución:

```bash
# 1. Verificar que Docker está ejecutándose
docker --version
docker ps

# 2. Reconstruir container
# En VS Code: Ctrl/Cmd + Shift + P
# "Dev Containers: Rebuild Container"

# 3. Limpiar caché Docker (último recurso)
docker system prune -a
docker volume prune
```

### Problema: Errores de dependencias

#### Síntomas:

- Error de módulos no encontrados
- Versiones incompatibles
- Build falla

#### Solución:

```bash
# 1. Limpiar completamente
rm -rf node_modules package-lock.json
rm -rf apps/*/node_modules apps/*/package-lock.json

# 2. Limpiar caché
npm cache clean --force

# 3. Reinstalar todo
npm install
cd apps/corporativa && npm install
cd ../eyenga && npm install

# 4. Verificar instalación
npm list --depth=0
```

### Problema: Dominios locales no funcionan

#### Síntomas:

- corporativa.local no resuelve
- Browser muestra error "site can't be reached"

#### Solución:

```bash
# 1. Verificar archivo hosts (en sistema host, no container)
cat /etc/hosts | grep local

# 2. Si no están las entradas, ejecutar:
sudo ./scripts/remove-hosts.sh  # Limpiar primero
sudo ./scripts/setup-hosts.sh   # Reconfigurar

# 3. Limpiar caché DNS (macOS)
sudo dscacheutil -flushcache

# 3. Limpiar caché DNS (Linux)
sudo systemctl flush-dns

# 4. Reiniciar navegador
```

### Problema: Hot reload no funciona

#### Síntomas:

- Cambios en código no se reflejan automáticamente
- Necesita refresh manual

#### Solución:

```bash
# 1. Verificar que el servidor de desarrollo esté corriendo
ps aux | grep react-scripts

# 2. Reiniciar aplicación específica
# Ctrl+C para parar, luego:
npm run dev:corporativa  # o eyenga

# 3. Verificar configuración de puerto
cat apps/corporativa/package.json | grep start
```

---

## 🔍 Comandos de Diagnóstico

### Información del sistema

```bash
# Información de Node.js y npm
node --version
npm --version

# Información del sistema
cat /etc/os-release

# Información de Docker (desde host)
docker --version
```

### Verificar estado de aplicaciones

```bash
# Ver procesos de Node.js activos
ps aux | grep node

# Ver qué puertos están en uso
netstat -tlnp | grep LISTEN

# Ver uso de memoria y CPU
top | grep node
```

### Información de red

```bash
# Ver configuración de red del container
ip addr show

# Probar conectividad
curl http://localhost:3000
curl http://localhost:3001
```

### Logs de aplicaciones

```bash
# Ver logs en tiempo real
# (ejecutar en terminal separada)
tail -f apps/corporativa/npm-debug.log
tail -f apps/eyenga/npm-debug.log
```

### Verificar dependencias

```bash
# Ver árbol de dependencias
npm list --depth=0

# Verificar vulnerabilidades
npm audit

# Ver dependencias desactualizadas
npm outdated
```

---

## 🆘 Comandos de Emergencia

### Reset completo del workspace

```bash
#!/bin/bash
echo "🚨 RESET COMPLETO - Esto borrará todo y empezará desde cero"
read -p "¿Estás seguro? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Limpiar todo
    rm -rf node_modules package-lock.json
    rm -rf apps/*/node_modules apps/*/package-lock.json
    rm -rf apps/*/build

    # Reconfigurar
    ./setup.sh

    echo "✅ Reset completo completado"
else
    echo "❌ Reset cancelado"
fi
```

### Verificación rápida de salud del sistema

```bash
#!/bin/bash
echo "🔍 VERIFICACIÓN DE SALUD DEL SISTEMA"
echo "=================================="

# Docker
echo "🐳 Docker:"
docker --version || echo "❌ Docker no disponible"

# Node.js y npm
echo "🟢 Node.js: $(node --version)"
echo "📦 npm: $(npm --version)"

# Puertos
echo "🌐 Puertos en uso:"
netstat -tlnp | grep -E ':300[0-1]' || echo "✅ Puertos 3000-3001 libres"

# Aplicaciones
echo "🏗️ Aplicaciones:"
[ -d "apps/corporativa" ] && echo "✅ Corporativa existe" || echo "❌ Corporativa falta"
[ -d "apps/eyenga" ] && echo "✅ Eyenga existe" || echo "❌ Eyenga falta"

# Configuración
echo "⚙️ Configuración:"
[ -f "config/domains.json" ] && echo "✅ domains.json existe" || echo "❌ domains.json falta"
[ -f "shared/config.ts" ] && echo "✅ config.ts existe" || echo "❌ config.ts falta"

echo "=================================="
echo "✅ Verificación completada"
```

---

**Autor**: Equipo de Desarrollo  
**Última actualización**: 15 de Agosto, 2025  
**Versión**: v1.0
