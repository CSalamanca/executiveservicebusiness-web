# 🚀 Despliegue en Oracle Cloud con Terraform

Este directorio contiene la configuración de Terraform para desplegar las aplicaciones React (Corporativa y Eyenga) en Oracle Cloud Infrastructure (OCI).

## 📋 Prerrequisitos

1. **Oracle CLI configurado** ✅ (ya configurado)
2. **Terraform instalado** ✅ (ya instalado)
3. **Clave SSH** (necesitas generar una)
4. **Dominios** (opcional pero recomendado)

## 🔑 Generar clave SSH

```bash
# Genera una nueva clave SSH
ssh-keygen -t rsa -b 4096 -f ~/.ssh/oracle_key -C "tu_email@ejemplo.com"

# Ver la clave pública (copia este contenido)
cat ~/.ssh/oracle_key.pub
```

## ⚙️ Configuración

1. **Copia el archivo de ejemplo:**

```bash
cp terraform.tfvars.example terraform.tfvars
```

2. **Edita `terraform.tfvars`** con tus valores:
   - **ssh_public_key**: Pega el contenido de `~/.ssh/oracle_key.pub`
   - **corporativa_domain**: Tu dominio para la app corporativa
   - **eyenga_domain**: Tu dominio para la app Eyenga
   - **project_name**: Nombre de tu proyecto

## 🚀 Despliegue

```bash
# 1. Inicializar Terraform
terraform init

# 2. Ver el plan de despliegue
terraform plan

# 3. Aplicar la configuración (crear infraestructura)
terraform apply
```

## 📊 Arquitectura desplegada

```
┌─────────────────────────────────────────┐
│           Load Balancer                 │
│       (Oracle Cloud LB)               │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│              VM Instance                │
│         Ubuntu 22.04 LTS               │
│  ┌─────────────────────────────────────┐│
│  │           Nginx                     ││
│  │  ┌─────────────┬─────────────────┐  ││
│  │  │ corporativa │     eyenga      │  ││
│  │  │   build/    │    build/       │  ││
│  │  └─────────────┴─────────────────┘  ││
│  └─────────────────────────────────────┘│
└─────────────────────────────────────────┘
```

## 🌐 Acceso a las aplicaciones

Después del despliegue, tendrás:

- **Por IP**:

  - `http://TU_IP_PUBLICA/corporativa`
  - `http://TU_IP_PUBLICA/eyenga`
  - `http://TU_IP_PUBLICA` (página de inicio)

- **Por dominio** (si configuraste dominios):
  - `http://corporativa.tudominio.com`
  - `http://eyenga.tudominio.com`

## 🔒 Configurar HTTPS (SSL)

1. **Apunta tus dominios** a la IP pública de la VM
2. **Conecta por SSH** a la VM:
   ```bash
   ssh -i ~/.ssh/oracle_key ubuntu@TU_IP_PUBLICA
   ```
3. **Ejecuta el script de SSL**:
   ```bash
   sudo /home/ubuntu/setup-ssl.sh corporativa.tudominio.com eyenga.tudominio.com
   ```

## 🔧 Comandos útiles

```bash
# Ver outputs (IPs, URLs, etc.)
terraform output

# Conectar por SSH a la VM
terraform output ssh_connection

# Redeploy de aplicaciones (en la VM)
sudo /home/ubuntu/deploy.sh

# Ver logs de Nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Estado de servicios
sudo systemctl status nginx
```

## 💰 Costos estimados

Con la configuración por defecto (VM.Standard.E4.Flex, 2 OCPU, 8GB RAM):

- **VM**: ~$15-20/mes
- **Almacenamiento**: ~$5/mes
- **Transferencia**: ~$1-3/mes
- **Total**: ~$20-30/mes

## 🗑️ Destruir infraestructura

⚠️ **¡CUIDADO!** Esto eliminará todo:

```bash
terraform destroy
```

## 📁 Archivos importantes

- `main.tf`: Configuración principal de infraestructura
- `variables.tf`: Definición de variables
- `outputs.tf`: Valores de salida
- `cloud-init.yaml`: Configuración automática de la VM
- `terraform.tfvars`: Tu configuración personalizada

## 🔧 Personalización avanzada

### Cambiar el tipo de instancia

En `terraform.tfvars`:

```hcl
instance_shape = "VM.Standard3.Flex"  # AMD en lugar de ARM
instance_ocpus = 4                    # Más potencia
instance_memory_gb = 16               # Más memoria
```

### Agregar más almacenamiento

En `terraform.tfvars`:

```hcl
boot_volume_size_gb = 100  # 100GB en lugar de 50GB
```

## 🆘 Resolución de problemas

### Error: "No capacity available"

- Cambia a otra región o tipo de instancia
- Intenta con `VM.Standard3.Flex` (AMD)

### Error: "Service limit exceeded"

- Verifica tus límites en Oracle Cloud Console
- Solicita aumento de límites si es necesario

### No se puede acceder a la aplicación

1. Verifica que la VM esté ejecutándose: `terraform output`
2. Revisa los security groups: puerto 80 y 443 deben estar abiertos
3. Conecta por SSH y verifica Nginx: `sudo systemctl status nginx`

## 📚 Documentación adicional

- [Oracle Cloud Terraform Provider](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [Oracle Cloud Compute Shapes](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm)
- [Oracle Cloud Free Tier](https://www.oracle.com/cloud/free/)

---

**¿Necesitas ayuda?** Revisa los logs en `/var/log/` de la VM o contacta al equipo de desarrollo.
