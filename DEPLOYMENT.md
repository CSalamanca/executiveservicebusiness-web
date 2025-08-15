# 🚀 Guía de Deployment - Proyecto Eyenga

## 📋 Información del Proyecto

**Proyecto**: Website Educativo Eyenga  
**Tecnología**: React 18.x + TypeScript  
**Estado**: ✅ Listo para Producción  
**Puerto de desarrollo**: 3001  
**Dominio objetivo**: www.eyenga-project.org

## 🎯 Preparación para Producción

### ✅ Estado Actual del Proyecto

- ✅ **Funcionalidades completadas**:

  - Diseño moderno con gradientes coloridos
  - Navegación inteligente con flechas de scroll dual
  - Modal de contacto funcional
  - Galería con imágenes auténticas del proyecto
  - Contenido real del proyecto educativo Eyenga
  - Responsive design (móvil, tablet, desktop)
  - Optimización de performance

- ✅ **Componentes implementados**:
  - Hero section con logo personalizado
  - Estadísticas del proyecto (2600 estudiantes, 90% inserción laboral, etc.)
  - Programas de formación (agricultura, ganadería, construcción)
  - Galería de campus e instalaciones
  - Sección "Sobre Eyenga" con misión y visión
  - Call-to-action con información de inversión
  - Footer con información de contacto

### Checklist Pre-Deployment

- [x] **Código funcional**

  - [x] Todas las secciones funcionando
  - [x] Navegación entre secciones fluida
  - [x] Modal de contacto operativo
  - [x] Flechas de scroll con lógica inteligente
  - [x] Responsive design verificado

- [x] **Assets optimizados**

  - [x] Imágenes específicas del proyecto integradas
  - [x] Logo personalizado (image010.png) implementado
  - [x] Imágenes de galería optimizadas
  - [x] Assets de tamaño apropiado

- [ ] **Configuración de producción**
  - [ ] Variables de entorno configuradas
  - [ ] Dominio www.eyenga-project.org configurado
  - [ ] Certificado SSL obtenido
  - [ ] Analytics configurado

## ⚙️ Configuración de Entorno

### Variables de Entorno para Producción

```env
# apps/eyenga/.env.production
REACT_APP_ENVIRONMENT=production
REACT_APP_DOMAIN=www.eyenga-project.org
REACT_APP_VERSION=1.0.0
REACT_APP_CONTACT_EMAIL=info@eyenga-project.org
REACT_APP_ANALYTICS_ID=UA-XXXXXXXX-1

# Información del proyecto
REACT_APP_CAMPUS_CONGO_SIZE=100
REACT_APP_CAMPUS_MADRID_SIZE=16
REACT_APP_STUDENTS_PROJECTED=2600
REACT_APP_EMPLOYMENT_RATE=90
REACT_APP_INVESTMENT_TOTAL=80000000
```

### Configuración de Dominios

```json
{
  "sites": {
    "eyenga": {
      "local": {
        "domain": "eyenga.local",
        "port": 3001
      },
      "staging": {
        "domain": "staging.eyenga-project.org",
        "port": 443
      },
      "production": {
        "domain": "www.eyenga-project.org",
        "port": 443,
        "apiUrl": "https://api.eyenga-project.org"
      }
    }
  },
  "environment": "production"
}
```

---

## 🏗️ Proceso de Build

### Build para Producción

```bash
# Script de build completo
#!/bin/bash
echo "🏗️ Iniciando build para producción..."

# 1. Limpiar builds anteriores
rm -rf apps/*/build

# 2. Build de todas las aplicaciones
npm run build:all

# 3. Verificar builds exitosos
if [ -d "apps/corporativa/build" ] && [ -d "apps/eyenga/build" ]; then
    echo "✅ Build completado exitosamente"

    # 4. Mostrar tamaños de build
    du -sh apps/*/build
else
    echo "❌ Error en el build"
    exit 1
fi
```

### Optimizaciones de Build

```json
{
  "scripts": {
    "build:analyze": "npm run build && npx bundle-analyzer apps/corporativa/build/static/js/*.js",
    "build:optimized": "GENERATE_SOURCEMAP=false npm run build",
    "build:size-check": "npm run build && node scripts/check-bundle-size.js"
  }
}
```

### Script de Verificación de Tamaño

```javascript
// scripts/check-bundle-size.js
const fs = require("fs");
const path = require("path");

const MAX_BUNDLE_SIZE = 2 * 1024 * 1024; // 2MB

const checkBundleSize = (appName) => {
  const buildDir = path.join(
    __dirname,
    "..",
    "apps",
    appName,
    "build",
    "static",
    "js"
  );

  if (!fs.existsSync(buildDir)) {
    console.error(`❌ Build directory not found for ${appName}`);
    return false;
  }

  const files = fs.readdirSync(buildDir);
  const jsFiles = files.filter(
    (file) => file.endsWith(".js") && !file.includes(".map")
  );

  let totalSize = 0;
  jsFiles.forEach((file) => {
    const filePath = path.join(buildDir, file);
    const size = fs.statSync(filePath).size;
    totalSize += size;
    console.log(`📦 ${appName}/${file}: ${(size / 1024).toFixed(2)} KB`);
  });

  console.log(
    `📊 Total size for ${appName}: ${(totalSize / 1024).toFixed(2)} KB`
  );

  if (totalSize > MAX_BUNDLE_SIZE) {
    console.error(
      `⚠️  ${appName} bundle exceeds ${MAX_BUNDLE_SIZE / 1024 / 1024}MB limit`
    );
    return false;
  }

  return true;
};

const corporativaOk = checkBundleSize("corporativa");
const eyengaOk = checkBundleSize("eyenga");

if (!corporativaOk || !eyengaOk) {
  process.exit(1);
}

console.log("✅ All bundle sizes are within limits");
```

---

## 🌐 Configuración de Dominios

### DNS Configuration

```bash
# Registros DNS requeridos
```

#### Para corporativa.com:

```
Type    Name                Value               TTL
A       @                   192.168.1.100      300
A       www                 192.168.1.100      300
CNAME   staging            staging-server.com  300
```

#### Para eyenga.com:

```
Type    Name                Value               TTL
A       @                   192.168.1.101      300
A       www                 192.168.1.101      300
CNAME   staging            staging-server.com  300
```

### Certificados SSL

```bash
# Usando Let's Encrypt con certbot
sudo apt install certbot python3-certbot-nginx

# Obtener certificados
sudo certbot --nginx -d corporativa.com -d www.corporativa.com
sudo certbot --nginx -d eyenga.com -d www.eyenga.com

# Verificar auto-renovación
sudo certbot renew --dry-run
```

---

## 🔒 Seguridad en Producción

### Content Security Policy (CSP)

```html
<!-- En public/index.html de cada app -->
<meta
  http-equiv="Content-Security-Policy"
  content="
  default-src 'self';
  script-src 'self' 'unsafe-inline' https://www.google-analytics.com;
  style-src 'self' 'unsafe-inline' https://fonts.googleapis.com;
  font-src 'self' https://fonts.gstatic.com;
  img-src 'self' data: https:;
  connect-src 'self' https://api.corporativa.com;
"
/>
```

### Security Headers (Nginx Config)

```nginx
# /etc/nginx/sites-available/corporativa.com
server {
    listen 443 ssl http2;
    server_name corporativa.com www.corporativa.com;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/corporativa.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/corporativa.com/privkey.pem;

    # Security Headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

    # Root directory
    root /var/www/corporativa/build;
    index index.html;

    # Handle React Router
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location /static/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

---

## 📊 Monitoreo y Analytics

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
