resource "oci_identity_compartment" "compartment" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "Shared VCN"
    name = "shared-vcn"

    #Optional
    #defined_tags = {"Operations.CostCenter"= "42"}
    #freeform_tags = {"Department"= "Finance"}
}


resource "oci_core_vcn" "vcn" {
    #Required
    compartment_id = oci_identity_compartment.compartment.id


    cidr_block = "10.0.0.0/24"
    #cidr_blocks = var.vcn_cidr_blocks
    #defined_tags = {"Operations.CostCenter"= "42"}
    display_name = "cl-shared-vcn"
    dns_label = "cl"
    #freeform_tags = {"Department"= "Finance"}
    #ipv6private_cidr_blocks = var.vcn_ipv6private_cidr_blocks
    #is_ipv6enabled = var.vcn_is_ipv6enabled
    #is_oracle_gua_allocation_enabled = var.vcn_is_oracle_gua_allocation_enabled
    #security_attributes = var.vcn_security_attributes
}

resource "oci_core_subnet" "test_subnet" {
    #Required
    compartment_id = oci_identity_compartment.compartment.id
    vcn_id = oci_core_vcn.vcn.id
    ipv4cidr_blocks = ["10.0.0.0/26"]
    display_name = "siem-export-sn"
    prohibit_public_ip_on_vnic = false # Public subnet
    prohibit_internet_ingress = false 
}

resource "oci_core_subnet" "fun_subnet" {
  cidr_block = "10.0.0.128/28"
  display_name = "dd-func-sn"
  dns_label = "ddfuncsn"
  prohibit_internet_ingress = true 
  prohibit_public_ip_on_vnic = true 
  compartment_id = oci_core_vcn.vcn.compartment_id
  vcn_id = oci_core_vcn.vcn.id
}