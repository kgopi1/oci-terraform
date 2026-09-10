variable "tenancy_ocid" {
  
}

resource "oci_identity_tag_namespace" "tag_namespace" {
    #Required
    compartment_id = var.tenancy_ocid
    description = "Namespace Tag"
    name = "Demo"

    #Optional
    #defined_tags = {"Operations.CostCenter"= "42"}
    #freeform_tags = {"Department"= "Finance"}
    #is_retired = false
}

resource "oci_identity_tag" "tag_definition" {
  #Required
  description      = "Environment Tag Definition"
  name             = "environment"
  tag_namespace_id = oci_identity_tag_namespace.tag_namespace.id

  #Optional
  is_cost_tracking = false // default is "false". The value "true" is only permitted if the associated tag namespace is part of the root compartment.
  is_retired       = false

  validator {
    validator_type = "ENUM"
    values         = ["Prod", "Dev", "Test"]
  }
}