# main.tf - Configuración principal de la infraestructura (Free Tier)
terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.0"
}

# Provider configuration - usando el profile DEFAULT del .oci/config
provider "oci" {
  region = var.region
}

# Data sources para obtener información del tenancy
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Obtener imagen Ubuntu ARM para Free Tier
data "oci_core_images" "ubuntu_arm" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.A1.Flex"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# VCN (Virtual Cloud Network) - Free Tier
resource "oci_core_vcn" "ebs_vcn" {
  compartment_id = var.tenancy_ocid
  cidr_blocks    = ["10.0.0.0/16"]
  display_name   = "${var.project_name}-vcn"
  dns_label      = "ebsvcn"
  
  freeform_tags = {
    "Environment" = "free-tier"
    "Project"     = "executive-service-business"
  }
}

# Internet Gateway - Free Tier
resource "oci_core_internet_gateway" "ebs_igw" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.ebs_vcn.id
  display_name   = "${var.project_name}-igw"
  enabled        = true
  
  freeform_tags = {
    "Environment" = "free-tier"
    "Project"     = "executive-service-business"
  }
}

# Route Table - Free Tier
resource "oci_core_route_table" "ebs_rt" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.ebs_vcn.id
  display_name   = "${var.project_name}-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ebs_igw.id
  }
  
  freeform_tags = {
    "Environment" = "free-tier"
    "Project"     = "executive-service-business"
  }
}

# Security List - Free Tier (solo puertos 22 SSH y 443 HTTPS)
resource "oci_core_security_list" "ebs_security_list" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_vcn.ebs_vcn.id
  display_name   = "${var.project_name}-security-list"

  # Permitir tráfico saliente
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }

  # SSH (puerto 22) - REQUERIDO para administración
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 22
      max = 22
    }
    description = "SSH access"
  }

  # HTTPS (puerto 443) - REQUERIDO para aplicaciones web
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
    description = "HTTPS access - Nginx proxy to apps"
  }

  # Ping (ICMP) - Para diagnósticos
  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"
    icmp_options {
      type = 3
      code = 4
    }
    description = "ICMP for diagnostics"
  }
  
  freeform_tags = {
    "Environment" = "free-tier"
    "Project"     = "executive-service-business"
  }
}

# Subnet pública - Free Tier
resource "oci_core_subnet" "ebs_subnet" {
  cidr_block          = "10.0.1.0/24"
  compartment_id      = var.tenancy_ocid
  vcn_id              = oci_core_vcn.ebs_vcn.id
  display_name        = "${var.project_name}-subnet"
  dns_label           = "ebssubnet"
  route_table_id      = oci_core_route_table.ebs_rt.id
  security_list_ids   = [oci_core_security_list.ebs_security_list.id]
  prohibit_public_ip_on_vnic = false
  
  freeform_tags = {
    "Environment" = "free-tier"
    "Project"     = "executive-service-business"
  }
}

# VM ARM Free Tier - VM.Standard.A1.Flex con 24GB RAM
resource "oci_core_instance" "ebs_vm" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.tenancy_ocid
  display_name        = "ebs-vm-esb"
  shape               = "VM.Standard.A1.Flex"

  # Configuración ARM Free Tier: hasta 4 OCPUs y 24GB RAM gratuitos
  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_memory_gb
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.ebs_subnet.id
    display_name              = "ebs-vnic"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "vm-esb"
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_arm.images[0].id
    boot_volume_size_in_gbs = var.boot_volume_size_gb  # Free tier: hasta 200GB
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data = base64encode(templatefile("${path.module}/cloud-init.yaml", {
      corporativa_domain = var.corporativa_domain
      eyenga_domain     = var.eyenga_domain
    }))
  }

  # Always Free: No costo adicional
  freeform_tags = {
    "Environment" = "free-tier"
    "Project"     = "executive-service-business"
    "AlwaysFree"  = "true"
  }

  timeouts {
    create = "15m"
  }
}

# Public IP para la VM (incluido en Free Tier)
resource "oci_core_public_ip" "ebs_public_ip" {
  compartment_id = var.tenancy_ocid
  display_name   = "ebs-public-ip"
  lifetime       = "RESERVED"
  
  freeform_tags = {
    "Environment" = "free-tier"
    "Project"     = "executive-service-business"
    "AlwaysFree"  = "true"
  }
}
