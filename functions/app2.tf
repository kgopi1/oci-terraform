# oci_functions_application.python_app:
resource "oci_functions_application" "python_app" {
    compartment_id             = oci_core_vcn.vcn.compartment_id
    config                     = {}
    display_name               = "pythonapp"
    freeform_tags              = {}
    network_security_group_ids = []
    security_attributes        = {}
    shape                      = "GENERIC_X86"
    subnet_ids                 = [
        oci_core_subnet.fun_subnet.id 
    ]
    logging {
        line_format = "PLAIN_TEXT"
    }
    depends_on = [ oci_core_subnet.fun_subnet ]
}
