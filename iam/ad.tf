# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_identity_domain" "domain" {
  domain_id = "ocid1.domain.oc1..aaaaaaaaizzm5qnttv3npxrscqx6a2ppomc6qcevujkhorxgc5j2ysxfyisa"
}

# Output the result
output "show-ads" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

output "idcs_endpoint" {
  value = replace(data.oci_identity_domain.domain.url, ":443", "")
}

output "idcs_endpoint2" {
  value = data.oci_identity_domain.domain.url
}
