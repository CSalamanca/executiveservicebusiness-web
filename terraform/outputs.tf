# outputs.tf - Salidas de la infraestructura Free Tier
output "vm_public_ip" {
  description = "IP pública de la VM vm-esb"
  value       = oci_core_instance.ebs_vm.public_ip
}

output "vm_private_ip" {
  description = "IP privada de la VM vm-esb"
  value       = oci_core_instance.ebs_vm.private_ip
}

output "vm_hostname" {
  description = "Hostname de la VM"
  value       = "vm-esb.${oci_core_subnet.ebs_subnet.dns_label}.${oci_core_vcn.ebs_vcn.dns_label}.oraclevcn.com"
}

output "ssh_connection" {
  description = "Comando para conectar por SSH"
  value       = "ssh -i ~/.ssh/oracle_key ubuntu@${oci_core_instance.ebs_vm.public_ip}"
}

output "vm_ocid" {
  description = "OCID de la VM"
  value       = oci_core_instance.ebs_vm.id
}

output "vcn_ocid" {
  description = "OCID de la VCN"
  value       = oci_core_vcn.ebs_vcn.id
}

output "subnet_ocid" {
  description = "OCID de la subnet"
  value       = oci_core_subnet.ebs_subnet.id
}

output "security_list_ocid" {
  description = "OCID de la security list"
  value       = oci_core_security_list.ebs_security_list.id
}

output "free_tier_summary" {
  description = "Resumen de recursos Free Tier utilizados"
  value = {
    vm_shape     = oci_core_instance.ebs_vm.shape
    ocpus        = oci_core_instance.ebs_vm.shape_config[0].ocpus
    memory_gb    = oci_core_instance.ebs_vm.shape_config[0].memory_in_gbs
    storage_gb   = oci_core_instance.ebs_vm.source_details[0].boot_volume_size_in_gbs
    always_free  = "true"
    cost         = "0.00 USD"
  }
}

output "domains_info" {
  description = "Información sobre dominios para configurar"
  value = {
    corporativa = var.corporativa_domain
    eyenga     = var.eyenga_domain
    note       = "Apunta estos dominios a la IP: ${oci_core_instance.ebs_vm.public_ip}"
  }
}
