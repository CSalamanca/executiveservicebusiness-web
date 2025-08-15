# Executive Service Business - Multi-Site React Applications

> Un workspace moderno con múltiples aplicaciones React: **Corporativa** y **Eyenga**, con despliegue automatizado en Oracle Cloud Free Tier.

## 🌱 Descripción- VM.Standard.A1.Flex (ARM) (Always Free)

- 4 OCPU ARM + 24GB RAM (Always Free)
- 150GB Boot Volume (Always Free)
- VCN + Public Subnet (Always Free) Proyecto

Este proyecto contiene dos aplicaciones React independientes:

- **Corporativa**: Sitio web corporativo de Executive Service Business
- **Eyenga**: Plataforma educativa enfocada en agricultura sostenible, ganadería y construcción

Ambas aplicaciones están optimizadas para despliegue en **Oracle Cloud Infrastructure (OCI) Free Tier** con **costo $0.00/mes**.

## �️ Estructura del Proyecto

```
executiveservicebusiness-web/
├── apps/
│   ├── corporativa/          # Aplicación corporativa
│   │   ├── src/             # Código fuente React
│   │   ├── public/          # Assets estáticos
│   │   └── package.json     # Dependencias específicas
│   └── eyenga/              # Aplicación educativa
│       ├── src/             # Código fuente React
│       ├── public/          # Assets estáticos
│       └── package.json     # Dependencias específicas
├── terraform/               # 🆕 Infraestructura como código
│   ├── main.tf             # Configuración principal de OCI
│   ├── variables.tf        # Variables de configuración
│   ├── outputs.tf          # Outputs del despliegue
│   ├── cloud-init.yaml     # Script de configuración automática
│   └── README_FREE_TIER.md # Guía completa de despliegue
├── shared/                  # Configuración compartida
└── config/                  # Configuración de dominios
```

## 🚀 Inicio Rápido

### Desarrollo Local

```bash
# Clonar el repositorio
git clone https://github.com/CSalamanca/executiveservicebusiness-web.git
cd executiveservicebusiness-web

# Instalar dependencias
npm run install:all

# Desarrollo - ejecutar ambas apps
npm run dev:all

# O ejecutar individualmente
npm run dev:corporativa    # http://localhost:3000
npm run dev:eyenga        # http://localhost:3001
```

### Despliegue en Oracle Cloud FREE TIER 🆓

**¡Completamente GRATUITO - $0.00/mes!**

```bash
# 1. Ir al directorio de infraestructura
cd terraform/

# 2. Configurar credenciales (ver guía completa)
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars con tus datos

# 3. Desplegar infraestructura
terraform init
terraform plan
terraform apply

# 4. Acceder a las aplicaciones
# http://TU_IP_PUBLICA/corporativa
# http://TU_IP_PUBLICA/eyenga
```

**📖 [Guía Completa de Despliegue en Oracle Cloud](terraform/README_FREE_TIER.md)**

## 🎯 Características Principales

### Aplicaciones React

- **Aplicación Corporativa**: Sitio web empresarial moderno
- **Aplicación Eyenga**: Plataforma educativa interactiva
- **Arquitectura Multi-Site**: Gestión independiente de aplicaciones
- **Responsive Design**: Optimizado para móviles, tablets y desktop

### Infraestructura Cloud (FREE TIER)

- **Oracle Cloud Infrastructure**: VM ARM con 4 OCPU, 24GB RAM
- **Costo**: $0.00 USD/mes (Always Free)
- **Despliegue Automatizado**: Terraform + Cloud-init
- **SSL/HTTPS**: Let's Encrypt automático
- **Firewall**: Configuración de seguridad incluida

## 🛠️ Stack Tecnológico

### Frontend

- **React 18** con TypeScript
- **CSS3** con diseño responsive
- **Create React App** para build y desarrollo
- **ESLint** para calidad de código

### Infraestructura

- **Oracle Cloud Infrastructure (OCI)**
- **Terraform** para Infrastructure as Code
- **Ubuntu 22.04 LTS ARM**
- **Nginx** como servidor web
- **Let's Encrypt** para SSL gratuito

### DevOps

- **GitHub Actions** (configuración pendiente)
- **Docker** support (desarrollo futuro)
- **Cloud-init** para configuración automática

## 📋 Comandos Disponibles

### Desarrollo Local

```bash
# Instalar dependencias
npm run install:all
npm run install:corporativa
npm run install:eyenga

# Desarrollo
npm run dev:all              # Ambas aplicaciones simultáneamente
npm run dev:corporativa      # Solo app corporativa (puerto 3000)
npm run dev:eyenga          # Solo app Eyenga (puerto 3001)

# Producción
npm run build:all           # Compilar ambas aplicaciones
npm run build:corporativa   # Compilar solo corporativa
npm run build:eyenga       # Compilar solo Eyenga
```

### Infraestructura Cloud

```bash
# Despliegue completo
cd terraform/
terraform init              # Inicializar Terraform
terraform plan             # Ver plan de despliegue
terraform apply            # Crear infraestructura

# Gestión
terraform output           # Ver información de despliegue
terraform destroy         # Eliminar infraestructura

# SSH a la VM
ssh -i ~/.ssh/oracle_key ubuntu@TU_IP_PUBLICA
```

## 🌍 Configuración de Dominios

El proyecto soporta múltiples configuraciones de dominio:

```json
{
  "sites": {
    "corporativa": {
      "local": { "domain": "corporativa.local", "port": 3000 },
      "production": { "domain": "corporativa.tudominio.com", "port": 443 }
    },
    "eyenga": {
      "local": { "domain": "eyenga.local", "port": 3001 },
      "production": { "domain": "eyenga.tudominio.com", "port": 443 }
    }
  }
}
```

## 🚀 Estado del Despliegue Actual

### ✅ Completado

- [x] Infraestructura Oracle Cloud Free Tier
- [x] VM ARM: 4 OCPU, 24GB RAM, 150GB storage
- [x] Networking: VCN, Subnet, Security Lists
- [x] IP Pública: `143.47.38.168`
- [x] SSH configurado y funcionando
- [x] Terraform configuración completa
- [x] Seguridad: .gitignore para archivos sensibles

### 🔄 Pendiente

- [ ] Instalación automática de aplicaciones (cloud-init fix)
- [ ] Configuración de Nginx
- [ ] SSL/HTTPS con Let's Encrypt
- [ ] CI/CD con GitHub Actions
- [ ] Monitoreo y logs

## 📖 Documentación

### Guías Principales

- **[🚀 Despliegue Oracle Cloud FREE TIER](terraform/README_FREE_TIER.md)**: Guía completa de despliegue
- **[📋 Comandos Disponibles](COMMANDS.md)**: Referencia de todos los comandos npm
- **[🔧 Documentación Técnica](TECHNICAL_DOCS.md)**: Arquitectura e implementación
- **[📦 Guía de Despliegue](DEPLOYMENT.md)**: Instrucciones de producción

### Documentación de Infraestructura

- **[Terraform Configuration](terraform/)**: Infraestructura como código
- **[Variables de Configuración](terraform/terraform.tfvars.example)**: Plantilla de configuración
- **[Scripts de Automatización](terraform/cloud-init.yaml)**: Configuración automática de VM

### Documentación de Desarrollo

- **[Guía de Diseño](DESIGN_GUIDE.md)**: Principios de UI/UX
- **[Changelog](CHANGELOG.md)**: Historial de versiones y cambios

## 💰 Costos de Infraestructura

### Oracle Cloud Free Tier (SIEMPRE GRATIS)

```
VM ARM (VM.Standard.A1.Flex):     $0.00/mes
- 4 OCPU ARM Ampere               (Always Free)
- 24GB RAM                        (Always Free)
- 50GB Boot Volume                (Always Free)

Red y Conectividad:               $0.00/mes
- VCN, Subnet, Internet Gateway   (Always Free)
- IP Pública Reservada            (Always Free)
- 10TB Transferencia/mes          (Always Free)

TOTAL MENSUAL:                    $0.00 USD
```

## 🔒 Seguridad

### Configuración de Firewall

- **Puerto 22**: SSH (acceso administrativo)
- **Puerto 443**: HTTPS (aplicaciones web)
- **Puertos cerrados**: Todos los demás puertos bloqueados

### Archivos Protegidos (.gitignore)

```
terraform/terraform.tfstate      # Estado de infraestructura
terraform/terraform.tfvars       # Variables con datos sensibles
terraform/.terraform/            # Cache de Terraform
~/.ssh/oracle_key               # Claves SSH privadas
```

## 🤝 Contribución

1. **Fork el repositorio**
2. **Crear rama de feature** (`git checkout -b feature/nueva-caracteristica`)
3. **Commit cambios** (`git commit -m 'Agregar nueva característica'`)
4. **Push a la rama** (`git push origin feature/nueva-caracteristica`)
5. **Crear Pull Request**

### Flujo de Desarrollo

```bash
# 1. Configurar entorno local
git clone https://github.com/CSalamanca/executiveservicebusiness-web.git
cd executiveservicebusiness-web
npm run install:all

# 2. Desarrollo
npm run dev:all

# 3. Testing (cuando esté disponible)
npm run test:all

# 4. Despliegue en staging
cd terraform/
terraform apply
```

## � Soporte y Enlaces

- **🌐 Aplicación Live**: http://143.47.38.168 (IP actual de la VM)
- **📁 Repositorio**: [GitHub](https://github.com/CSalamanca/executiveservicebusiness-web)
- **🐛 Issues**: [GitHub Issues](https://github.com/CSalamanca/executiveservicebusiness-web/issues)
- **💬 Discusiones**: [GitHub Discussions](https://github.com/CSalamanca/executiveservicebusiness-web/discussions)

## 📄 Licencia

Este proyecto es parte de la iniciativa educativa Executive Service Business.

---

**🎉 ¡Infraestructura completamente GRATUITA en Oracle Cloud!**  
**💚 Construido con ❤️ para educación sostenible e innovación digital**
