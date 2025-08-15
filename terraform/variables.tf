# variables.tf - Variables para Free Tier de Oracle Cloud
variable "tenancy_ocid" {
  description = "OCID del tenancy de Oracle Cloud"
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaas6unwuf3wsbpw4r4gnldgzliqebbw3sk7ibozkcmwlchksxe3lsa"
}

variable "user_ocid" {
  description = "OCID del usuario de Oracle Cloud"
  type        = string
  default     = "ocid1.user.oc1..aaaaaaaahu4icrylrpamush4g36p6tsvicup5fvgfp2aevc7xol435jm5omq"
}

variable "region" {
  description = "Región de Oracle Cloud donde desplegar"
  type        = string
  default     = "eu-madrid-1"
}

variable "project_name" {
  description = "Prefijo para nombrar todos los recursos"
  type        = string
  default     = "ebs"
}

variable "instance_shape" {
  description = "Shape de la instancia ARM Free Tier"
  type        = string
  default     = "VM.Standard.A1.Flex"
  validation {
    condition     = var.instance_shape == "VM.Standard.A1.Flex"
    error_message = "Solo VM.Standard.A1.Flex está disponible en Free Tier."
  }
}

variable "instance_ocpus" {
  description = "Número de OCPUs ARM para la instancia (máximo 4 en Free Tier)"
  type        = number
  default     = 4
  validation {
    condition     = var.instance_ocpus >= 1 && var.instance_ocpus <= 4
    error_message = "Free Tier ARM permite entre 1 y 4 OCPUs."
  }
}

variable "instance_memory_gb" {
  description = "Memoria en GB para la instancia ARM (máximo 24GB en Free Tier)"
  type        = number
  default     = 24
  validation {
    condition     = var.instance_memory_gb >= 1 && var.instance_memory_gb <= 24
    error_message = "Free Tier ARM permite entre 1 y 24GB de RAM."
  }
}

variable "boot_volume_size_gb" {
  description = "Tamaño del volumen de arranque en GB (máximo 200GB en Free Tier)"
  type        = number
  default     = 50
  validation {
    condition     = var.boot_volume_size_gb >= 47 && var.boot_volume_size_gb <= 200
    error_message = "Free Tier permite entre 47GB y 200GB de almacenamiento."
  }
}

variable "hostname_label" {
  description = "Label del hostname para la VM"
  type        = string
  default     = "vm-esb"
}

variable "corporativa_domain" {
  description = "Dominio para la aplicación corporativa"
  type        = string
  default     = "corporativa.executiveservice.com"
}

variable "eyenga_domain" {
  description = "Dominio para la aplicación Eyenga"
  type        = string
  default     = "eyenga.executiveservice.com"
}

variable "ssh_public_key" {
  description = "Clave SSH pública para acceso a la VM (requerida)"
  type        = string
  default     = ""
  validation {
    condition     = length(var.ssh_public_key) > 0
    error_message = "La clave SSH pública es requerida para acceso a la VM."
  }
}
