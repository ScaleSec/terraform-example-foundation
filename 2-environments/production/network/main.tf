/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  environment_code          = "p"
  env                       = "production"
  network_project_id        = data.google_projects.network_host_project.projects[0].project_id
  parent_id                 = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
  mode                      = var.enable_hub_and_spoke ? "spoke" : null
  bgp_asn_number            = var.enable_partner_interconnect ? "16550" : "64514"
  enable_transitivity       = var.enable_hub_and_spoke && var.enable_hub_and_spoke_transitivity
  /*
   * Base network ranges
   */
  network_subnet_aggregates    = ["10.0.0.0/16", "10.1.0.0/16", "100.64.0.0/16", "100.65.0.0/16"]
  network_subnet_ranges    = ["10.0.0.0/24", "10.1.0.0/24"]
  network_private_service_cidr = "10.16.64.0/21"
  network_subnet_primary_ranges = {
    (var.default_region1) = "10.0.64.0/21"
    (var.default_region2) = "10.1.64.0/21"
  }
  network_subnet_secondary_ranges = {
    (var.default_region1) = [
      {
        range_name    = "rn-${local.environment_code}-shared-${var.default_region1}-gke-pod"
        ip_cidr_range = "100.64.64.0/21"
      },
      {
        range_name    = "rn-${local.environment_code}-shared-${var.default_region1}-gke-svc"
        ip_cidr_range = "100.65.64.0/21"
      }
    ]
  }
}

data "google_active_folder" "env" {
  display_name = "${var.folder_prefix}-${local.env}"
  parent       = local.parent_id
}

/******************************************
  VPC Host Projects
*****************************************/

data "google_projects" "network_host_project" {
  filter = "parent.id:${split("/", data.google_active_folder.env.name)[1]} labels.application_name=shared-vpc-host labels.environment=${local.env} lifecycleState=ACTIVE"
}

/******************************************
 Shared VPC
*****************************************/

module "shared_vpc" {
  source                        = "../../../modules/shared_vpc"
  project_id                    = local.network_project_id
  environment_code              = local.environment_code
  private_service_cidr          = local.network_private_service_cidr
  org_id                        = var.org_id
  parent_folder                 = var.parent_folder
  default_region1               = var.default_region1
  default_region2               = var.default_region2
  domain                        = var.domain
  bgp_asn_subnet                = local.bgp_asn_number
  windows_activation_enabled    = var.windows_activation_enabled
  dns_enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  dns_enable_logging            = var.dns_enable_logging
  firewall_enable_logging       = var.firewall_enable_logging
  optional_fw_rules_enabled     = var.optional_fw_rules_enabled
  nat_enabled                   = var.nat_enabled
  nat_bgp_asn                   = var.nat_bgp_asn
  nat_num_addresses_region1     = var.nat_num_addresses_region1
  nat_num_addresses_region2     = var.nat_num_addresses_region2
  nat_num_addresses             = var.nat_num_addresses
  folder_prefix                 = var.folder_prefix
  mode                          = local.mode

  subnets = [
    {
      subnet_name           = "sb-${local.environment_code}-shared-${var.default_region1}"
      subnet_ip             = local.network_subnet_primary_ranges[var.default_region1]
      subnet_region         = var.default_region1
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "First ${local.env} subnet example."
    },
    {
      subnet_name           = "sb-${local.environment_code}-shared-${var.default_region2}"
      subnet_ip             = local.network_subnet_primary_ranges[var.default_region2]
      subnet_region         = var.default_region2
      subnet_private_access = "true"
      subnet_flow_logs      = var.subnetworks_enable_logging
      description           = "Second ${local.env} subnet example."
    }
  ]
  secondary_ranges = {
    "sb-${local.environment_code}-shared-${var.default_region1}" = local.network_subnet_secondary_ranges[var.default_region1]
  }
  allow_all_ingress_ranges = local.enable_transitivity ? local.network_subnet_ranges : null
  allow_all_egress_ranges  = local.enable_transitivity ? local.network_subnet_aggregates : null
}
