variable "network_address_list" {
    type = list(string)
    description = "Network source List"
    default = [ 
"8.8.8.8",
"9.9.9.9",
"13.107.42.21",
"27.111.228.99",
"31.13.71.38",
"45.33.32.156",
"52.7.94.118",
"64.233.177.188",
"66.249.93.104",
"74.125.0.101",
"80.239.167.27",
"91.198.174.192",
"104.16.123.96",
"108.177.126.28",
"128.14.0.1",
"142.250.190.14",
"162.159.137.54",
"185.199.108.153",
"216.58.216.46"
    
    ]
  
}


data "oci_identity_domain" "domain" {
  domain_id =  "ocid1.domain.oc1..aaaaaaaaizzm5qnttv3npxrscqx6a2ppomc6qcevujkhorxgc5j2ysxfyisa"
}

resource "oci_identity_domains_network_perimeter" "network_perimeter" {
	#Required
	idcs_endpoint = data.oci_identity_domain.domain.url
	dynamic "ip_addresses" {
        for_each = var.network_address_list
		content {
		value = ip_addresses.value
		#Optional
		type = "EXACT"
		version = "IPV4"
	}
    }
	name = "Cloudlabs-AddresList"
	schemas = ["urn:ietf:params:scim:schemas:oracle:idcs:NetworkPerimeter"]

	#Optional
	#attribute_sets = ["all"]
	#attributes = ""
	#authorization = var.network_perimeter_authorization
	description = "Cloudlabs Address List"
	#external_id = "externalId"
	#id = var.network_perimeter_id
	#ocid = var.network_perimeter_ocid
	#resource_type_schema_version = var.network_perimeter_resource_type_schema_version
	#tags {
}

