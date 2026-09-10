resource "oci_identity_compartment" "comp" {
  name = "tag-comp"
  description = "tag demo Comp"
  compartment_id = var.tenancy_ocid
  enable_delete = true 
  freeform_tags = {
    "Environment" = "Test"
  }
  defined_tags = {"Demo.environment"= "Test"}
  # lifecycle block removed so Terraform will manage `defined_tags`
}