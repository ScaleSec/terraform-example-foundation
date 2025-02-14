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

variable "org_id" {
  type        = string
  description = "Organization ID"
}

variable "enable_hub_and_spoke" {
  description = "Enable Hub-and-Spoke architecture."
  type        = bool
  default     = true
}

variable "enable_hub_and_spoke_transitivity" {
  description = "Enable transitivity via gateway VMs on Hub-and-Spoke architecture."
  type        = bool
  default     = false
}

variable "access_context_manager_policy_id" {
  type        = number
  description = "The id of the default Access Context Manager policy created in step `1-org`. Can be obtained by running `gcloud access-context-manager policies list --organization YOUR_ORGANIZATION_ID --format=\"value(name)\"`."
}

variable "default_region1" {
  type        = string
  description = "First subnet region for DNS Hub network."
}

variable "default_region2" {
  type        = string
  description = "Second subnet region for DNS Hub network."
}

variable "dns_enable_logging" {
  type        = bool
  description = "Toggle DNS logging for VPC DNS."
  default     = true
}

variable "subnetworks_enable_logging" {
  type        = bool
  description = "Toggle subnetworks flow logging for VPC Subnetworks."
  default     = true
}

variable "domain" {
  type        = string
  description = "The DNS name of forwarding managed zone, for instance 'example.com'. Must end with a period."
}

variable "bgp_asn_dns" {
  type        = number
  description = "BGP Autonomous System Number (ASN)."
  default     = 64667
}

variable "target_name_server_addresses" {
  description = "List of IPv4 address of target name servers for the forwarding zone configuration. See https://cloud.google.com/dns/docs/overview#dns-forwarding-zones for details on target name servers in the context of Cloud DNS forwarding zones."
  type        = list(string)
}

variable "parent_folder" {
  description = "Optional - for an organization with existing projects or for development/validation. It will place all the example foundation resources under the provided folder instead of the root organization. The value is the numeric folder ID. The folder must already exist. Must be the same value used in previous step."
  type        = string
  default     = ""
}

variable "folder_prefix" {
  description = "Name prefix to use for folders created. Should be the same in all steps."
  type        = string
  default     = "fldr"
}

variable "net_hub_windows_activation_enabled" {
  type        = bool
  description = "Enable Windows license activation for Windows workloads in Base Hub"
  default     = false
}

variable "net_hub_dns_enable_inbound_forwarding" {
  type        = bool
  description = "Toggle inbound query forwarding for Base Hub VPC DNS."
  default     = true
}

variable "net_hub_dns_enable_logging" {
  type        = bool
  description = "Toggle DNS logging for Base Hub VPC DNS."
  default     = true
}

variable "net_hub_firewall_enable_logging" {
  type        = bool
  description = "Toggle firewall logging for VPC Firewalls in Base Hub VPC."
  default     = true
}

variable "net_hub_optional_fw_rules_enabled" {
  type        = bool
  description = "Toggle creation of optional firewall rules: IAP SSH, IAP RDP and Internal & Global load balancing health check and load balancing IP ranges in Base Hub VPC."
  default     = false
}

variable "net_hub_nat_enabled" {
  type        = bool
  description = "Toggle creation of NAT cloud router in Base Hub."
  default     = false
}

variable "net_hub_nat_bgp_asn" {
  type        = number
  description = "BGP ASN for first NAT cloud routes in Base Hub."
  default     = 64514
}

variable "net_hub_nat_num_addresses_region1" {
  type        = number
  description = "Number of external IPs to reserve for first Cloud NAT in Base Hub."
  default     = 2
}

variable "net_hub_nat_num_addresses_region2" {
  type        = number
  description = "Number of external IPs to reserve for second Cloud NAT in Base Hub."
  default     = 2
}

variable "firewall_policies_enable_logging" {
  type        = bool
  description = "Toggle hierarchical firewall logging."
  default     = true
}

variable "enable_partner_interconnect" {
  description = "Enable Partner Interconnect in the environment."
  type        = bool
  default     = false
}

variable "preactivate_partner_interconnect" {
  description = "Preactivate Partner Interconnect VLAN attachment in the environment."
  type        = bool
  default     = false
}

variable "enable_dedicated_interconnect" {
  description = "Enable Dedicated Interconnect in the environment"
  type = bool
  default = false
}

// Region 1 Interconnect 1
variable "region1_interconnect1_candidate_subnets" {
  type = list(string)
  description = "Up to 16 candidate prefixes that can be used to restrict the allocation of cloudRouterIpAddress and customerRouterIpAddress for this attachment. All prefixes must be within link-local address space (169.254.0.0/16) and must be /29 or shorter (/28, /27, etc).	"
}

variable "region1_interconnect1_vlan_tag8021q" {
  type = string
  description = "The IEEE 802.1Q VLAN tag for this attachment, in the range 2-4094."
}

variable "region1_interconnect1_name" {
  type = string
  description = "The resource name of the underlying interconnect object that this attachments traffic will traverse through"
}

variable "region1_interconnect1_location" {
  type = string
  description = "Name of the interconnect location used in the creation of the Interconnect for the first location of region1	"
}

// Region 1 Interconnect 2

variable "region1_interconnect2_candidate_subnets" {
  type = list(string)
  description = "Up to 16 candidate prefixes that can be used to restrict the allocation of cloudRouterIpAddress and customerRouterIpAddress for this attachment. All prefixes must be within link-local address space (169.254.0.0/16) and must be /29 or shorter (/28, /27, etc).	"
}

variable "region1_interconnect2_vlan_tag8021q" {
  type = string
  description = "The IEEE 802.1Q VLAN tag for this attachment, in the range 2-4094."
}

variable "region1_interconnect2_name" {
  type = string
  description = "The resource name of the underlying interconnect object that this attachments traffic will traverse through"
}

variable "region1_interconnect2_location" {
  type = string
  description = "Name of the interconnect location used in the creation of the Interconnect for the second location of region1	"
}

// Region 2 Interconnect 1

variable "region2_interconnect1_candidate_subnets" {
  type = list(string)
  description = "Up to 16 candidate prefixes that can be used to restrict the allocation of cloudRouterIpAddress and customerRouterIpAddress for this attachment. All prefixes must be within link-local address space (169.254.0.0/16) and must be /29 or shorter (/28, /27, etc).	"
}

variable "region2_interconnect1_vlan_tag8021q" {
  type = string
  description = "The IEEE 802.1Q VLAN tag for this attachment, in the range 2-4094."
}

variable "region2_interconnect1_name" {
  type = string
  description = "The resource name of the underlying interconnect object that this attachments traffic will traverse through"
}

variable "region2_interconnect1_location" {
  type = string
  description = "Name of the interconnect location used in the creation of the Interconnect for the first location of region2"
}

// Region 2 Interconnect 1

variable "region2_interconnect2_candidate_subnets" {
  type = list(string)
  description = "Up to 16 candidate prefixes that can be used to restrict the allocation of cloudRouterIpAddress and customerRouterIpAddress for this attachment. All prefixes must be within link-local address space (169.254.0.0/16) and must be /29 or shorter (/28, /27, etc).	"
}

variable "region2_interconnect2_vlan_tag8021q" {
  type = string
  description = "The IEEE 802.1Q VLAN tag for this attachment, in the range 2-4094."
}

variable "region2_interconnect2_name" {
  type = string
  description = "The resource name of the underlying interconnect object that this attachments traffic will traverse through"
}

variable "region2_interconnect2_location" {
  type = string
  description = "Name of the interconnect location used in the creation of the Interconnect for the second location of region2"
}

variable "peer_asn" {
  type = number
  description = "Peer BGP Autonomous System Number (ASN)."
}

variable "peer_name" {
  type = string
  description = "Name of this BGP peer. The name must be 1-63 characters long, and comply with RFC1035. Specifically, the name must be 1-63 characters long and match the regular expression a-z?"
}

variable "members" {
  type        = list(string)
  description = "An allowed list of members (users, service accounts). The signed-in identity originating the request must be a part of one of the provided members. If not specified, a request may come from any user (logged in/not logged in, etc.). Formats: user:{emailid}, serviceAccount:{emailid}"
}

variable "restricted_services" {
  type        = list(string)
  description = "List of services to restrict."
}

variable "mode" {
  type        = string
  description = "Network deployment mode, should be set to `hub` or `spoke` when `enable_hub_and_spoke` architecture chosen, keep as `null` otherwise."
  default     = "hub"
}