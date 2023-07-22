resource "aci_contract" "app_to_web" {
  tenant_dn = aci_tenant.tenant.id
  name      = "app_to_web"
}

resource "aci_filter" "allow_tcp" {
  tenant_dn = aci_tenant.tenant.id
  name      = "allow_tcp"
}

resource "aci_filter" "allow_tomcat2" {
  tenant_dn = aci_tenant.tenant.id
  name      = "allow_tomcat2"
}

resource "aci_filter" "allow_icmp" {
  tenant_dn = aci_tenant.tenant.id
  name      = "allow_icmp"
}

resource "aci_filter_entry" "tcp" {
  filter_dn = aci_filter.allow_tcp.id
  name      = "tcp"
  d_from_port = "1"
  d_to_port   = "65535"
  prot        = "tcp"
  ether_t     = "ip"
}

resource "aci_filter_entry" "tomcat" {
  filter_dn = aci_filter.allow_tomcat2.id
  name      = "tomcat"
  d_from_port = "8080"
  d_to_port   = "8082"
  prot        = "tcp"
  ether_t     = "ip"
}

resource "aci_filter_entry" "icmp" {
  filter_dn = aci_filter.allow_icmp.id
  name      = "icmp"
  prot        = "icmp"
  ether_t     = "ip"
}

#Contract Subject Creation
resource "aci_contract_subject" "dev_app" {
  contract_dn = aci_contract.app_to_web.id
  name        = "tomcat_and_tcp"
  relation_vz_rs_subj_filt_att = [aci_filter.allow_tomcat2.id,aci_filter.allow_tcp.id,aci_filter.allow_icmp.id]
}

# app_to_web contract association with WEB_EPG and APP_EPG
resource "aci_epg_to_contract" "app_to_web_consumer" {
  application_epg_dn = aci_application_epg.WEB_EPG.id
  contract_dn        = aci_contract.app_to_web.id
  contract_type      = "consumer"
}

resource "aci_epg_to_contract" "app_to_web_provider" {
  application_epg_dn = aci_application_epg.APP_EPG.id
  contract_dn        = aci_contract.app_to_web.id
  contract_type      = "provider"
}

