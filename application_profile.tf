resource "aci_application_profile" "test-app" {
  tenant_dn   = aci_tenant.tenant.id
  name        = "test-app"
  description = "This app profile is created by terraform"
}

resource "aci_application_epg" "WEB_EPG" {
  application_profile_dn = aci_application_profile.test-app.id
  name			 = "WEB_EPG"
  relation_fv_rs_bd = aci_bridge_domain.web_bd.id
}


resource "aci_application_epg" "APP_EPG" {
  application_profile_dn = aci_application_profile.test-app.id
  name			 = "APP_EPG"
  relation_fv_rs_bd = aci_bridge_domain.app_bd.id
}

resource "aci_epg_to_static_path" "WEB_EPG" {
  application_epg_dn  = "${aci_application_epg.WEB_EPG.id}"
  tdn  = local.tdn_1
  encap  = local.vlan_1
  mode  = "regular"
}

resource "aci_epg_to_static_path" "APP_EPG" {
  application_epg_dn  = "${aci_application_epg.APP_EPG.id}"
  tdn  = local.tdn_2 
  encap  = local.vlan_2
  mode  = "regular"
}

resource "aci_epg_to_domain" "WEB_EPG" {

  application_epg_dn    = "${aci_application_epg.WEB_EPG.id}"
  tdn                   = "${aci_physical_domain.terraform_physdom_2.id}"
}

resource "aci_epg_to_domain" "APP_EPG" {

  application_epg_dn    = "${aci_application_epg.APP_EPG.id}"
  tdn                   = "${aci_physical_domain.terraform_physdom_2.id}"
}
