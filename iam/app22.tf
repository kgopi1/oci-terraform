# Deactivate the app and delete the app. 
resource "oci_identity_domains_app" "test_app2" {
     description               = "Entra SCIM2"
    display_name              = "entra2"
    active = false
     based_on_template {
        #last_modified = "2021-12-17T00:30:25.000Z"
        #ref           = "https://idcs-d7aa8ecc0c3e4bf28540bd4d06017f5f.identity.oraclecloud.com:443/admin/v1/AppTemplates/CustomWebAppTemplateId"
        value         = "CustomWebAppTemplateId"
        well_known_id = "CustomWebAppTemplateId"
    }
    idcs_endpoint = replace(data.oci_identity_domain.domain.url, ":443", "")
    client_type               = "confidential"
    allowed_grants = [ "client_credentials" ]
     schemas                   = [
         "urn:ietf:params:scim:schemas:oracle:idcs:App",
         "urn:ietf:params:scim:schemas:oracle:idcs:extension:OCITags",
     ]
}

output "test_app2_secret" {
  value = oci_identity_domains_app.test_app.client_secret
  sensitive = true
}

output "test_app2_id" {
  value = oci_identity_domains_app.test_app.id
}