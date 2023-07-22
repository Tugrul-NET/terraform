resource "aci_tenant" "tenant" {
  name        = var.aci_tenant_name
  description = "Terraform Tenant"
}

resource "aci_vrf" "test-vrf" {
  tenant_dn	= aci_tenant.tenant.id
  name 		= "test-vrf"
}

resource "aci_bridge_domain" "web_bd" {
  tenant_dn	= aci_tenant.tenant.id
  name		= "web_bd"
  relation_fv_rs_ctx = aci_vrf.test-vrf.id
}


resource "aci_subnet" "web_subnet" {
  parent_dn 	= aci_bridge_domain.web_bd.id
  ip 			= "33.33.33.254/24"
}

resource "aci_bridge_domain" "app_bd" {
  tenant_dn = aci_tenant.tenant.id
  name    = "app_bd"
  relation_fv_rs_ctx = aci_vrf.test-vrf.id
}


resource "aci_subnet" "app_subnet" {
  parent_dn   = aci_bridge_domain.app_bd.id
  ip      = "66.66.66.254/24"
}
