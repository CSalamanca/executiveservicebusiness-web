# 🚀 Despliegue FREE TIER en Oracle Cloud con Terraform

Este directorio contiene la configuración de Terraform para desplegar las aplicaciones React (Corporativa y Eyenga) en Oracle Cloud Infrastructure (OCI) usando **SOLO recursos del Free Tier**.

## 🆓 **¡COMPLETAMENTE GRATUITO!**

Esta configuración utiliza exclusivamente recursos del Free Tier de Oracle Cloud:

- **VM ARM**: VM.Standard.A1.Flex (4 OCPU, 24GB RAM) - GRATIS para siempre
- **Almacenamiento**: 150GB Boot Volume - GRATIS (hasta 200GB)
- **Networking**: VCN completa + IP pública - GRATIS
- **IP Pública**: GRATIS
- **Transferencia**: 10TB/mes - GRATIS

**💰 Costo total: $0.00 USD/mes**

## 📋 Prerrequisitos

1. **Oracle CLI configurado** ✅ (ya configurado)
2. **Terraform instalado** ✅ (ya instalado)
3. **Clave SSH** ✅ (ya generada)
4. **Cuenta Oracle Cloud** con Free Tier activado

## 🏗️ Arquitectura Free Tier

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

## 🔧 Configuración específica Free Tier

### Variables configuradas para Free Tier:

```hcl
# VM ARM Free Tier (MÁXIMO PERMITIDO)
instance_shape     = "VM.Standard.A1.Flex"
instance_ocpus     = 4     # Máximo en Free Tier
instance_memory_gb = 24     # Máximo permitido en Free Tier
boot_volume_size_gb = 150   # Hasta 200GB permitidos
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E... tu-clave-publica"

# Prefijo para recursos
project_name = "ebs"  # Executive Business Service

# Región
region = "eu-madrid-1"
```

## 🚀 Despliegue paso a paso

```bash
# 1. Ir al directorio terraform
cd /workspace/terraform

# 2. Inicializar Terraform
terraform init

# 3. Ver el plan (verificar que todo sea FREE)
terraform plan

# 4. Aplicar la configuración
terraform apply

# 5. Confirmar con 'yes' cuando se solicite
```

## 📊 Recursos creados (TODOS FREE TIER)

| Recurso          | Nombre              | Tipo                  | Costo     |
| ---------------- | ------------------- | --------------------- | --------- |
| VM               | `ebs-vm-esb`        | VM.Standard.A1.Flex   | $0.00     |
| VCN              | `ebs-vcn`           | Virtual Cloud Network | $0.00     |
| Subnet           | `ebs-subnet`        | Public Subnet         | $0.00     |
| Internet Gateway | `ebs-igw`           | Internet Gateway      | $0.00     |
| Route Table      | `ebs-rt`            | Route Table           | $0.00     |
| Security List    | `ebs-security-list` | Firewall Rules        | $0.00     |
| Public IP        | `ebs-public-ip`     | Reserved Public IP    | $0.00     |
| **TOTAL**        |                     |                       | **$0.00** |

## 🔐 Firewall (Security List)

Configuración de puertos abiertos:

- **Puerto 22**: SSH (acceso administrativo)
- **Puerto 443**: HTTPS (aplicaciones web)
- **ICMP**: Ping (diagnósticos)

## 🌐 Acceso después del despliegue

```bash
# Ver información de conexión
terraform output

# Conectar por SSH
ssh -i ~/.ssh/oracle_key ubuntu@IP_PUBLICA

# URLs de acceso:
# https://IP_PUBLICA/corporativa
# https://IP_PUBLICA/eyenga
```

## 🔒 Configurar dominios y SSL (opcional)

1. **Configurar DNS**: Apunta tus dominios a la IP pública
2. **Conectar por SSH**:
   ```bash
   ssh -i ~/.ssh/oracle_key ubuntu@$(terraform output -raw vm_public_ip)
   ```
3. **Configurar SSL gratuito** (Let's Encrypt):
   ```bash
   sudo /home/ubuntu/setup-ssl.sh corporativa.tudominio.com eyenga.tudominio.com
   ```

## 📈 Monitoreo Free Tier

```bash
# Verificar uso de recursos en la VM
ssh -i ~/.ssh/oracle_key ubuntu@IP_PUBLICA

# CPU y memoria
htop

# Espacio en disco
df -h

# Estado de servicios
sudo systemctl status nginx

# Logs de aplicación
sudo tail -f /var/log/nginx/access.log
```

## ⚠️ Límites del Free Tier

**Oracle Cloud Free Tier incluye:**

- ✅ VM ARM: 4 OCPU, 24GB RAM (para siempre)
- ✅ Almacenamiento: 200GB (para siempre)
- ✅ Transferencia: 10TB/mes
- ✅ IP pública: 2 IP reservadas
- ✅ VCN: Ilimitadas

**Importante:**

- Solo funciona con `VM.Standard.A1.Flex` (ARM)
- Máximo 4 OCPU y 24GB RAM por tenancy
- Si superas los límites, se aplicarán cargos

## 🗑️ Limpiar recursos

```bash
# CUIDADO: Esto elimina toda la infraestructura
terraform destroy

# Confirmar con 'yes'
```

## 🆘 Problemas comunes

### "No capacity available for shape VM.Standard.A1.Flex"

**Solución**: Las VMs ARM Free Tier son muy populares y pueden no estar disponibles temporalmente.

```bash
# Intentar en diferentes momentos del día
# O cambiar región (pero no olvides actualizar la región en terraform.tfvars)
```

### "Service limit exceeded"

**Solución**: Ya tienes una VM ARM activa en tu tenancy.

```bash
# Verifica en Oracle Cloud Console si ya tienes una VM ARM
# Free Tier solo permite 1 VM ARM por tenancy
```

### No puedo acceder a la aplicación

1. **Verificar VM**:

   ```bash
   terraform output vm_public_ip
   ```

2. **Verificar firewall**:

   ```bash
   # En Oracle Cloud Console: Networking > Security Lists
   # Debe permitir puertos 22 y 443
   ```

3. **Verificar servicios en la VM**:
   ```bash
   ssh -i ~/.ssh/oracle_key ubuntu@IP_PUBLICA
   sudo systemctl status nginx
   ```

## 📚 Documentación Free Tier

- [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)
- [ARM Compute Shapes](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm#vm-standard-a1)
- [Free Tier FAQ](https://www.oracle.com/cloud/free/faq/)

---

**🎉 ¡Disfruta de tu infraestructura completamente GRATUITA!**
