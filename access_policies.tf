resource "aci_vlan_pool" "terraform_vlanpool_2" {
    name            =       "terraform_vlanpool_2"
    description     =       "terraform_vlanpool_2"
    alloc_mode      =       "static"
}

resource "aci_ranges" "terraform_vlan_pool_static_2" {
    vlan_pool_dn    =       aci_vlan_pool.terraform_vlanpool_2.id
    from            =       local.static_vlan_start
    to              =       local.static_vlan_end
    alloc_mode      =       "inherit"
    role            =       "external"
}

resource "aci_physical_domain" "terraform_physdom_2" {
    name            =       "terraform_physdom_2"
    relation_infra_rs_vlan_ns = aci_vlan_pool.terraform_vlanpool_2.id
}

resource "aci_attachable_access_entity_profile" "terraform_aep_2" {
    name            =       "terraform_aep_2"
    relation_infra_rs_dom_p =       [aci_physical_domain.terraform_physdom_2.id]
}


## First Port

resource "aci_leaf_access_port_policy_group" "terraform_intpolg_acc_2" {
    name                            = "terraform_intpolg_acc_2"
    relation_infra_rs_att_ent_p     = aci_attachable_access_entity_profile.terraform_aep_2.id
}


resource "aci_leaf_interface_profile" "terraform_acc_intf_p_2" {
    name                            = "terraform_acc_intf_p_2"
}

resource "aci_access_port_selector" "terraform_acc_port_selector_2" {
    leaf_interface_profile_dn      = aci_leaf_interface_profile.terraform_acc_intf_p_2.id
    name                           = "terraform_acc_port_selector_2"
    access_port_selector_type      = "range"
    relation_infra_rs_acc_base_grp = aci_leaf_access_port_policy_group.terraform_intpolg_acc_2.id
}

resource "aci_access_port_block" "terraform_acc_port_block_2" {
    access_port_selector_dn = aci_access_port_selector.terraform_acc_port_selector_2.id
    name                    = "terraform_acc_port_block_2"
    from_card               = "1"
    from_port               = local.access_port
    to_card                 = "1"
    to_port                 = local.access_port
}

resource "aci_leaf_profile" "terraform_access_sp_2" {
    name                         = "terraform_access_sp_2"
    relation_infra_rs_acc_port_p = [aci_leaf_interface_profile.terraform_acc_intf_p_2.id]
}

resource "aci_leaf_selector" "terraform_access_sp_2" {
    leaf_profile_dn         = aci_leaf_profile.terraform_access_sp_2.id
    name                    = "terraform_access_sp_2"
    switch_association_type = "range"
}

resource "aci_node_block" "terraform_access_leaf_nodes_2" {
    switch_association_dn = aci_leaf_selector.terraform_access_sp_2.id
    name                  = "terraform_access_leaf_nodes_2"
    from_                 = local.access_leaf
    to_                   = local.access_leaf
}

## Second Port

resource "aci_leaf_access_port_policy_group" "terraform_intpolg_pc_2" {
    name                            = "terraform_intpolg_pc_2"
    relation_infra_rs_att_ent_p     = aci_attachable_access_entity_profile.terraform_aep_2.id
}


resource "aci_leaf_interface_profile" "terraform_pc_intf_p_2" {
    name                            = "terraform_pc_intf_p_2"
}

resource "aci_access_port_selector" "terraform_pc_port_selector_2" {
    leaf_interface_profile_dn      = aci_leaf_interface_profile.terraform_pc_intf_p_2.id
    name                           = "terraform_pc_port_selector_2"
    access_port_selector_type      = "range"
    relation_infra_rs_acc_base_grp = aci_leaf_access_port_policy_group.terraform_intpolg_pc_2.id
}

resource "aci_access_port_block" "terraform_pc_port_block_2" {
    access_port_selector_dn = aci_access_port_selector.terraform_pc_port_selector_2.id
    name                    = "terraform_pc_port_block_2"
    from_card               = "1"
    from_port               = local.PC_port_1
    to_card                 = "1"
    to_port                 = local.PC_port_1
}

resource "aci_access_port_block" "terraform_pc_port_block_3" {
    access_port_selector_dn = aci_access_port_selector.terraform_pc_port_selector_2.id
    name                    = "terraform_pc_port_block_3"
    from_card               = "1"
    from_port               = local.PC_port_2
    to_card                 = "1"
    to_port                 = local.PC_port_2
}

resource "aci_leaf_profile" "terraform_pc_sp_2" {
    name                         = "terraform_pc_sp_2"
    relation_infra_rs_acc_port_p = [aci_leaf_interface_profile.terraform_pc_intf_p_2.id]
}

resource "aci_leaf_selector" "terraform_pc_sp_2" {
    leaf_profile_dn         = aci_leaf_profile.terraform_pc_sp_2.id
    name                    = "terraform_pc_sp_2"
    switch_association_type = "range"
}

resource "aci_node_block" "terraform_pc_leaf_nodes_2" {
    switch_association_dn = aci_leaf_selector.terraform_pc_sp_2.id
    name                  = "terraform_pc_leaf_nodes_2"
    from_                 = local.PC_leaf
    to_                   = local.PC_leaf
}
