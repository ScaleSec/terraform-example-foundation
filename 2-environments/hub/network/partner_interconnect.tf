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

module "partner_interconnect" {
  count                          = var.enable_partner_interconnect && var.preactivate_partner_interconnect ? 1 : 0
  source                         = "../../../modules/partner_interconnect"

  org_id                         = var.org_id
  parent_folder                  = var.parent_folder
  vpc_name                       = "${local.environment_code}-shared-base"
  environment                    = local.env
  enable_hub_and_spoke           = var.enable_hub_and_spoke
  vpc_type                       = "base"
  preactivate                    = var.preactivate_partner_interconnect

  region1                        = var.default_region1
  region1_router1_name           = module.net_hub_shared_vpc[0].region1_router1.router.name
  region1_interconnect1_location = "las-zone1-770"
  region1_router2_name           = module.net_hub_shared_vpc[0].region1_router2.router.name
  region1_interconnect2_location = "las-zone1-770"

  region2                        = var.default_region2
  region2_router1_name           = module.net_hub_shared_vpc[0].region2_router1.router.name
  region2_interconnect1_location = "lax-zone2-19"
  region2_router2_name           = module.net_hub_shared_vpc[0].region2_router2.router.name
  region2_interconnect2_location = "lax-zone1-403"

  folder_prefix                  = var.folder_prefix

  cloud_router_labels = {
    vlan_1 = "cr1",
    vlan_2 = "cr2",
    vlan_3 = "cr3",
    vlan_4 = "cr4"
  }
}
