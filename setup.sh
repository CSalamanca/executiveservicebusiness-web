#!/bin/bash

echo "🚀 Configurando workspace React Multi-Site..."

# Instalar dependencias del workspace principal
echo "📦 Instalando dependencias del workspace..."
npm install

# Crear directorio apps si no existe
mkdir -p apps

# Crear aplicación Corporativa
echo "🏢 Creando aplicación Corporativa..."
cd apps
npx create-react-app corporativa --template typescript

# Crear aplicación Eyenga
echo "👁️ Creando aplicación Eyenga..."
npx create-react-app eyenga --template typescript

cd ..

# Configurar package.json de cada app para usar puertos específicos
echo "⚙️ Configurando puertos específicos..."

# Corporativa - Puerto 3000
sed -i 's/"start": "react-scripts start"/"start": "PORT=3000 react-scripts start"/' apps/corporativa/package.json

# Eyenga - Puerto 3001
sed -i 's/"start": "react-scripts start"/"start": "PORT=3001 react-scripts start"/' apps/eyenga/package.json

# Crear archivos de configuración específicos para cada app
echo "📄 Creando archivos de configuración..."

# Configuración para Corporativa
cat > apps/corporativa/src/config.ts << 'EOF'
import { getCorporativaConfig } from '../../../shared/config';

export const siteConfig = getCorporativaConfig();
export const SITE_NAME = 'Corporativa';
EOF

# Configuración para Eyenga
cat > apps/eyenga/src/config.ts << 'EOF'
import { getEyengaConfig } from '../../../shared/config';

export const siteConfig = getEyengaConfig();
export const SITE_NAME = 'Eyenga';
EOF

echo "✅ Configuración completada!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Ejecuta 'npm run dev:all' para iniciar ambas apps"
echo "2. Accede a:"
echo "   - Corporativa: http://localhost:3000"
echo "   - Eyenga: http://localhost:3001"
echo ""
echo "💡 Para usar dominios locales:"
echo "   sudo ./scripts/setup-hosts.sh"
echo "   - Corporativa: http://corporativa.local:3000"
echo "   - Eyenga: http://eyenga.local:3001"
