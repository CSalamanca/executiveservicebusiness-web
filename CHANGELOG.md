# 📋 Changelog - Executive Service Business

Todos los cambios importantes de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.1] - 2025-08-15 - Storage Expansion

### 🚀 Changed

#### 💾 Storage Upgrade

- **Boot Volume Expansion**: Expandido de 50GB a 150GB
  - Espacio disponible aumentado de ~45GB a ~142GB
  - Aplicado via Terraform con reinicio automático de VM
  - Mantiene el 100% dentro del Free Tier de Oracle Cloud (hasta 200GB gratuitos)

### 🔄 Infrastructure Update

- **Terraform Configuration**: Actualizado `boot_volume_size_gb = 150`
- **VM Reboot**: Realizado automáticamente para aplicar el cambio
- **File System**: Expandido automáticamente por Oracle Cloud
- **Documentation**: Actualizada en todos los archivos relevantes

### 📊 New Storage Utilization

```yaml
Total Storage: 150GB (75% del límite Free Tier)
Used Space: ~3.4GB
Available Space: ~142GB
File System: ext4 on /dev/sda1
```

---

## [2.0.0] - 2025-08-15 - Oracle Cloud Infrastructure Implementation

### 🎯 Major Infrastructure Overhaul

Esta versión marca una transformación completa del proyecto con la implementación de infraestructura cloud empresarial en Oracle Cloud.

### ✨ Added

#### 🏗️ Infraestructura Oracle Cloud

- **Terraform Infrastructure**: Configuración completa de Infrastructure as Code
  - VCN (Virtual Cloud Network) con subnet pública
  - VM.Standard.A1.Flex ARM instance (4 OCPU, 24GB RAM, 150GB SSD)
  - Security Lists con reglas de firewall optimizadas
  - Public IP estática asignada: `143.47.38.168`
  - Cloud-init script para configuración automatizada

#### 🔧 Configuración Cloud

- **Oracle CLI**: Setup completo con credenciales y configuración
- **SSH Keys**: Generación y configuración de claves para acceso seguro
- **Firewall**: Configuración UFW en VM + Security Lists en Oracle Cloud
- **Nginx**: Web server configurado para servir múltiples aplicaciones

#### 📁 Estructura de Archivos Terraform

```
terraform/
├── main.tf              # Configuración principal de recursos
├── variables.tf         # Variables con validación Free Tier
├── outputs.tf           # Información de deployment
├── cloud-init.yaml     # Script de inicialización de VM
└── terraform.tfvars.example # Template de configuración
```

#### 🔒 Seguridad y Acceso

- **SSH Access**: Configuración segura con key-based authentication
- **Firewall Rules**: Solo puertos 22 (SSH) y 443 (HTTPS) abiertos
- **Security Headers**: Configuración Nginx con headers de seguridad
- **UFW Configuration**: Firewall local en la VM

#### 📚 Documentación Completa

- **README.md**: Actualizado con información Oracle Cloud y arquitectura
- **DEPLOYMENT.md**: Guía completa de despliegue y troubleshooting
- **TECHNICAL_DOCS.md**: Especificaciones técnicas detalladas
- **COMMANDS.md**: Comandos útiles para gestión de la infraestructura

### 🚀 Changed

#### 📦 Configuración del Proyecto

- **package.json**: Scripts actualizados para incluir comandos Terraform
- **.gitignore**: Reglas adicionales para archivos Terraform sensibles
- **DevContainer**: Configuración mejorada con herramientas de Oracle Cloud

#### 🌐 URLs y Acceso

- **Corporativa App**: `http://143.47.38.168` (raíz del sitio)
- **Eyenga App**: `http://143.47.38.168/eyenga` (subpath)
- **SSH Access**: `ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168`

### 🔄 Infrastructure Details

#### 💰 Oracle Cloud Free Tier Usage

```yaml
Compute:
  VM.Standard.A1.Flex: 4 OCPU ARM + 24GB RAM ✅ (100% del límite)
Network:
  VCN: 1 ✅ (100% del límite)
  Public IP: 1 ✅
Storage:
  Boot Volume: 150GB ✅ (75% del límite de 200GB)
Cost: $0.00 USD/month ✅
```

#### 🏗️ Architecture Components

- **Region**: us-ashburn-1 (Oracle Cloud)
- **Availability Domain**: Single AD deployment
- **Operating System**: Ubuntu 22.04 LTS ARM64
- **Web Server**: Nginx 1.18.x
- **Runtime**: Node.js 20.x LTS

### 📋 Deployment Status

#### ✅ Completed

- [x] Oracle Cloud account setup and CLI configuration
- [x] Terraform infrastructure deployment
- [x] VM instance provisioned and accessible
- [x] SSH access configured and tested
- [x] Nginx web server installed and running
- [x] Firewall and security configuration
- [x] Domain routing configuration (IP-based)
- [x] Complete documentation update

#### 🔄 In Progress

- [ ] Applications deployment to production VM
- [ ] SSL/TLS certificates configuration
- [ ] Monitoring and logging setup
- [ ] Backup automation

#### 📋 Next Steps

1. **Manual Application Deployment**: Upload and configure React builds
2. **SSL Configuration**: Let's Encrypt certificates for HTTPS
3. **Monitoring Setup**: System monitoring and alerting
4. **CI/CD Pipeline**: Automated deployment from Git repository

### 🛠️ Technical Specifications

#### 🖥️ VM Instance Details

```yaml
Shape: VM.Standard.A1.Flex
CPU Architecture: ARM64
Processor: 4 OCPU
Memory: 24 GB DDR4
Storage: 150 GB NVMe SSD
Network: 1 Gbps
OS: Ubuntu 22.04 LTS ARM64
```

#### 🌐 Network Configuration

```yaml
VCN CIDR: 10.0.0.0/16
Public Subnet: 10.0.1.0/24
Public IP: 143.47.38.168 (Static)
Security Lists: SSH (22), HTTPS (443), ICMP
```

### 🔧 Scripts and Automation

#### 📝 New Scripts Added

- `terraform/cloud-init.yaml`: VM initialization script
- `scripts/deploy-apps.sh`: Application deployment automation
- `scripts/setup-oracle.sh`: Oracle CLI setup automation
- `scripts/monitor.sh`: System monitoring script
- `scripts/backup.sh`: Backup automation script
- `scripts/diagnose.sh`: System diagnostics

#### 🚀 NPM Scripts Extended

```json
{
  "terraform:init": "cd terraform && terraform init",
  "terraform:plan": "cd terraform && terraform plan",
  "terraform:apply": "cd terraform && terraform apply",
  "terraform:destroy": "cd terraform && terraform destroy",
  "deploy:apps": "bash scripts/deploy-apps.sh"
}
```

### 🔗 Resources and Links

- **Oracle Cloud Console**: https://cloud.oracle.com/
- **Terraform Provider**: https://registry.terraform.io/providers/oracle/oci/latest/docs
- **VM SSH Access**: `ssh -i ~/.ssh/oracle_key ubuntu@143.47.38.168`
- **Application URLs**:
  - Corporativa: http://143.47.38.168
  - Eyenga: http://143.47.38.168/eyenga

---

## [1.0.0] - 2025-08-15 - Initial Development Setup

### ✨ Added

#### 🎯 Project Foundation

- **Workspace Structure**: Multi-app monorepo setup
- **DevContainer**: Complete development environment
- **React Applications**: Corporativa and Eyenga apps scaffolding

#### 🏗️ Development Environment

- **Node.js 20**: Latest LTS runtime
- **React 18**: Modern React with TypeScript
- **Concurrently**: Parallel app execution
- **Local Development**: Port-based separation (3000, 3001)

### 🚀 Features

#### 🌐 Eyenga Application (Completed)

- **Landing Page**: Complete educational website
- **Hero Section**: Engaging introduction
- **Statistics**: Impact metrics display
- **Programs**: Educational program showcase
- **Gallery**: Visual content presentation
- **About Section**: Project information
- **Contact**: Contact form and information

#### 🏢 Corporativa Application (Scaffolded)

- **Basic Structure**: Ready for development
- **Corporate Theme**: Business-focused styling
- **TypeScript Setup**: Type-safe development ready

---

**Mantenido por**: Executive Service Business Development Team  
**Última actualización**: 15 de Agosto, 2025  
**Repositorio**: Executive Service Business Multi-Site Platform
